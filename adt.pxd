# SPDX-FileCopyrightText: 2020 Gerion Entrup <entrup@sra.uni-hannover.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# cython: language_level=3
# vim: set et ts=4 sw=4:

from libcpp.string cimport string

cdef extern from "llvm/ADT/StringRef.h" namespace "llvm":
    cdef cppclass StringRef:
        string str()
