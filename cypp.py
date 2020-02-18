#!/usr/bin/env python3
"""The Cython preprocessor

Cython cannot natively compile multiple pyx files to one module.
This script "fixes" this by does a text preprocess of the given file, just like
the cpp. All directives thereby have to stand in their own line.

Supported directives:
    #include "foo.pyx" -- embed "foo.pyx" as is instead of the directive
    #pragma once -- embed this file at maximum one time
"""

import argparse
import os
import re
import sys


class ParseException(Exception):
    pass


class LineProcessor:
    """Iterator for lines that supports dynamic stacking.

    That means that you can push or append more lines while iterating them.
    """
    def __init__(self):
        self._files = []

    def _get_file(self, file):
        """Open the file, if file is a file path and return a file object."""
        if isinstance(file, str):
            if file == '-':
                file = sys.stdin
            else:
                file = open(file, 'rb')
        return file

    def push(self, file):
        """Push a new file on top of the file stack.

        File can be a file path or an already open file object.
        """
        self._files.append(self._get_file(file))

    def insert(self, index, file):
        """Append a new file at the specific index of the file stack.

        Index 0 is the bottom of the stack. File can be a file path or an
        already open file object.
        """
        self._files.insert(index, self._get_file(file))

    def get_current_filename(self):
        """Return the current file name."""
        return self._files[-1].name

    def __iter__(self):
        return self

    def __next__(self):
        if not self._files:
            raise StopIteration
        top = self._files[-1]
        try:
            return next(top)
        except StopIteration:
            # file is done
            top.close()
            self._files.pop()
            return next(self)


class Interpreter:
    """Interprets one line."""

    def __init__(self, line_p, include, depfile):
        """Initialize with a LineProcessor."""
        self._line_p = line_p
        self._file_cache = set()
        self._includes = ['.'] + include
        self._depfile = depfile

    def _find_file(self, file):
        """Try to find files to include, check therefore all include paths,
        beginning with the current directory.
        """
        for dir in self._includes:
            candidate = os.path.join(os.path.abspath(dir), file)
            if os.path.exists(candidate):
                return candidate
        raise FileNotFoundError(f"{file} cannot be found.")

    def _include(self, line):
        res = re.search(r'#include "(.*)"', line.decode('UTF-8'))
        if res:
            new_file = res.group(1)
            path = self._find_file(new_file)
            if path not in self._file_cache:
                self._line_p.push(open(path, 'rb'))
                self._depfile.write(path)
        else:
            raise ParseException(f"#include directive incorrect: {line}")

    def _pragma_once(self, _):
        file_name = self._line_p.get_current_filename()
        path = os.path.abspath(file_name)
        self._file_cache.add(path)

    def interpret(self, line):
        """Interpret the given line."""
        if line.startswith(b'#include'):
            self._include(line)
            line = b''
        elif line.startswith(b'#pragma once'):
            self._pragma_once(line)
            line = b''
        return line


class DepfileWriter:
    """Produces a make/ninja compatible depfile."""
    def __init__(self, file, output):
        self._file = file
        if self._file:
            self._file.write(output + ':')

    def write(self, path):
        """Write a new path into file."""
        if self._file:
            self._file.write(' ' + str(path))


def main():
    """Entry function."""
    parser = argparse.ArgumentParser(
        prog=sys.argv[0],
        description=sys.modules[__name__].__doc__,
        formatter_class=argparse.RawTextHelpFormatter)
    parser.add_argument('--output', '-o', help="output file (default: STDOUT)",
                        type=argparse.FileType('wb'),
                        default=sys.stdout.buffer)
    parser.add_argument('--include', '-I', action='append', default=[],
                        help='list of include path')
    parser.add_argument('--depfile', '-d', help='write a dependency file',
                        type=argparse.FileType('w'))
    parser.add_argument('INPUT', help="input file (type - for STDIN)")

    args = parser.parse_args()

    line_p = LineProcessor()
    line_p.push(args.INPUT)

    ip = Interpreter(line_p, args.include,
                     DepfileWriter(args.depfile, args.output.name))

    for line in line_p:
        args.output.write(ip.interpret(line))


if __name__ == "__main__":
    main()
