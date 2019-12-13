# cython: language_level=3
# vim: set et ts=4 sw=4:

from ir cimport Value

from libcpp.string cimport string
from libcpp.memory cimport unique_ptr

cdef extern from "pyllco_helper.h" namespace "pyllco":
    T* get[T](Value*)
    string get_subclass(Value*)
