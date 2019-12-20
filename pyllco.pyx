# cython: language_level=3
# vim: set et ts=4 sw=4:

cimport pyllco
cimport ir

from pyllco_helper cimport get, get_subclass
from libcpp.memory cimport unique_ptr


cdef class User(Value):
    cdef inline ir.User* _user(self):
        return get[ir.User](self._val)


cdef class Constant(User):
    cdef inline ir.Constant* _constant(self):
        return get[ir.Constant](self._val)


cdef class BlockAddress(Constant):
    cdef inline ir.BlockAddress* _block_address(self):
        return get[ir.BlockAddress](self._val)


cdef class ConstantAggregate(Constant):
    pass


cdef class ConstantArray(Constant):
    pass


cdef class ConstantStruct(Constant):
    pass


cdef class ConstantVector(Constant):
    pass


cdef class ConstantData(Constant):
    pass


cdef class ConstantAggregateZero(Constant):
    pass


cdef class ConstantDataSequential(Constant):
    pass


cdef class ConstantDataArray(Constant):
    pass


cdef class ConstantDataVector(Constant):
    pass


cdef class ConstantFP(Constant):
    pass


cdef class ConstantInt(Constant):
    pass


cdef class ConstantPointerNull(Constant):
    pass


cdef class ConstantTokenNone(Constant):
    pass


cdef class UndefValue(Constant):
    pass


cdef class ConstantExpr(Constant):
    pass


cdef class CompareConstantExpr(Constant):
    pass


cdef class GlobalValue(Constant):
    pass


cdef class GlobalIndirectSymbol(Constant):
    pass


cdef class GlobalAlias(Constant):
    pass


cdef class GlobalIFunc(Constant):
    pass


cdef class GlobalObject(Constant):
    pass


cdef class Function(Constant):
    pass


cdef class GlobalVariable(Constant):
    pass


cdef public object get_obj(ir.Value* val):
    c = get_subclass(val)
    print(c)
    print(globals())
