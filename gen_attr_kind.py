#!/usr/bin/env python3

# SPDX-FileCopyrightText: 2020 Gerion Entrup <entrup@sra.uni-hannover.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Generate attr_kind.pyx and attr_kind.pxd.

Needs a c preprocessor.
"""
import argparse
import itertools
import os
import re
import subprocess
import sys
import tempfile

pyx_header = """#pragma once

{}

cimport attr_kind

from enum import IntEnum

class AttrKind(IntEnum):
"""

pxd_header = """# cython: language_level=3
# vim: set et ts=4 sw=4:

{}

cdef extern from "llvm/IR/Attributes.h" namespace "llvm::Attribute":
    cdef cppclass AttrKind:
        pass

cdef extern from "llvm/IR/Attributes.h" namespace "llvm::Attribute::AttrKind":
"""


def main():
    """Entry function."""
    parser = argparse.ArgumentParser(
        prog=sys.argv[0],
        description=sys.modules[__name__].__doc__,
        formatter_class=argparse.RawTextHelpFormatter)
    parser.add_argument('--include', '-I', nargs='*', default=[],
                        help='list of includes for cpp')
    parser.add_argument('--cpp', help="path to a c preprocessor (default: cpp)",
                        default='cpp')
    parser.add_argument('--outdir', '-o', help="output directory (default: .)",
                        default='.')
    parser.add_argument('--verbose', '-v', help="be verbose", default=False,
                        action='store_true')
    args = parser.parse_args()

    # get list of attributes with preprocessor
    with tempfile.NamedTemporaryFile(delete=False, mode='w') as fp:
        file_name = fp.name
        fp.write('#define GET_ATTR_ENUM\n')
        fp.write('#include "llvm/IR/Attributes.inc"\n')
    cmd = ([args.cpp] +
           list(itertools.chain(*[('-I', x) for x in args.include])) +
           [file_name])
    if args.verbose:
        print("Executing: " + ' '.join([f"'{x}'" for x in cmd]),
              file=sys.stderr)
    cpp_output = subprocess.run(cmd, capture_output=True)

    if (cpp_output.returncode != 0):
        sys.stderr.write(cpp_output.stderr.decode('UTF-8'))
        print(f"Hint: Not removing {file_name} for debugging purposes. " +
              "You may want to remove it manually.", file=sys.stderr)
        sys.exit(1)
    os.remove(file_name)
    attr_list = cpp_output.stdout.decode('UTF-8')
    attr_list = [re.sub(r'(.*),', r'\1', x) for x in attr_list.split('\n')
                 if x and not x.startswith('#')]

    directory = os.path.abspath(args.outdir)
    pyx = os.path.join(directory, 'attr_kind.pyx')
    pxd = os.path.join(directory, 'attr_kind.pxd')

    includes = ' '.join(["'" + str(x) + "'" for x in args.include])
    autogen_msg = f'# autogenerated with {sys.argv[0]} and includes {includes}'

    with open(pxd, 'w') as fp:
        fp.write(pxd_header.format(autogen_msg))
        for attr in attr_list:
            fp.write(f'    cdef AttrKind {attr}\n')
    with open(pyx, 'w') as fp:
        fp.write(pyx_header.format(autogen_msg))
        for attr in attr_list:
            fp.write(f'    {attr} = <int> attr_kind.{attr}\n')

    if args.verbose:
        print(f"Successfully generated {pyx} and {pxd}.", file=sys.stderr)


if __name__ == "__main__":
    main()
