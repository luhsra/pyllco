# cython: language_level=3
# vim: set et ts=4 sw=4:

cdef extern from "llvm/IR/Module.h" namespace "llvm":
    cdef cppclass Module:
        pass

cdef extern from "llvm/IR/Value.h" namespace "llvm":
    cdef cppclass Value:
        pass

cdef extern from "llvm/IR/User.h" namespace "llvm":
    cdef cppclass User:
        pass

cdef extern from "llvm/IR/Constant.h" namespace "llvm":
    cdef cppclass Constant:
        pass

cdef extern from "llvm/IR/Constants.h" namespace "llvm":
    cdef cppclass BlockAddress:
        pass
