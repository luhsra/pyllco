# cython: language_level=3
# vim: set et ts=4 sw=4:

cimport ir

from pyllco_helper cimport get, get_subclass
from libcpp.memory cimport unique_ptr


# Module is special and actually exists as unique_ptr
# TODO: implement that the module is stored elsewhere and only a raw pointer is
# needed in Python
cdef class Module:
    cdef unique_ptr[ir.Module] _mod


# Value are stored in the static LLVM context
# Currently, they cannot be constructed in Python
# TODO: change that
cdef class Value:
    cdef ir.Value* _val

cdef class User(Value):
    cdef inline ir.User* _user(self)

cdef class Instruction(User):
    pass

cdef class GetElementPtrInst(Instruction):
    cdef inline ir.GetElementPtrInst* _gep_inst(self)

cdef class AttributeSet:
    cdef ir.AttributeSet _set

    # internal helper functions, do not use
    cdef inline _has_attribute_str(self, attr)
    cdef inline _has_attribute_attr(self, int attr)
