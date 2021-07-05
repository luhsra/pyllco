# cython: language_level=3
# vim: set et ts=4 sw=4:

from ir cimport Value, GetElementPtrInst

from libcpp.string cimport string
from libcpp.memory cimport unique_ptr
from libcpp cimport bool
from libc.stdint cimport int64_t

cdef extern from "pyllco_helper.h" namespace "pyllco":
    T* get[T](Value*)
    string get_subclass(const Value&)
    string to_string[T](T&)
    bool get_gep_offset(const GetElementPtrInst&, int64_t&)
