# cython: language_level=3
# vim: set et ts=4 sw=4:

cimport ir
from pyllco_helper cimport get

cdef class BasicBlock(Value):
    cdef inline ir.BasicBlock* _bb(self):
        return get[ir.BasicBlock](self._val)
