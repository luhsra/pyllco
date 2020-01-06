# cython: language_level=3
# vim: set et ts=4 sw=4:

cimport adt
cimport attr_kind

from libcpp cimport bool
from libcpp.string cimport string
from libc.stdint cimport int64_t, uint64_t

cdef extern from "llvm/IR/Module.h" namespace "llvm":
    cdef cppclass Module:
        pass

cdef extern from "llvm/IR/Value.h" namespace "llvm":
    cdef cppclass Value:
        adt.StringRef getName()

cdef extern from "llvm/IR/User.h" namespace "llvm":
    cdef cppclass User:
        pass

cdef extern from "llvm/IR/Constant.h" namespace "llvm":
    cdef cppclass Constant:
        pass

cdef extern from "llvm/IR/Constants.h" namespace "llvm":
    cdef cppclass BlockAddress:
        pass
