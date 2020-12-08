# cython: language_level=3
# vim: set et ts=4 sw=4:

cimport ir
from pyllco_helper cimport get

cdef class Constant(User):
    cdef inline ir.Constant* _constant(self):
        return get[ir.Constant](self._val)

    def get(self, AttributeSet attrs=None):
        raise NotImplementedError(f"Type '{self.__class__.__name__}' cannot return a Python value")


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
    cdef inline ir.ConstantDataSequential* _cds(self):
        return get[ir.ConstantDataSequential](self._val)

    def get_as_c_string(self):
        return deref(self._cds()).getAsCString().str().decode('UTF-8')

    def get(self, AttributeSet attrs=None):
        return self.get_as_c_string()

cdef class ConstantDataArray(ConstantDataSequential):

    pass


cdef class ConstantDataVector(ConstantDataSequential):
    pass


cdef class ConstantFP(ConstantData):
    pass


cdef class ConstantInt(ConstantData):
    cdef inline ir.ConstantInt* _constant_int(self):
        return get[ir.ConstantInt](self._val)

    def get_bit_width(self):
        return deref(self._constant_int()).getBitWidth()

    def get_s_ext_value(self):
        return deref(self._constant_int()).getSExtValue()

    def get_z_ext_value(self):
        return deref(self._constant_int()).getZExtValue()

    def is_negative(self):
        return deref(self._constant_int()).isNegative()

    def get(self, AttributeSet attrs=None):
        if attrs and attrs.has_attribute(AttrKind.ZExt):
            return self.get_z_ext_value()
        else:
            return self.get_s_ext_value()

    def __int__(self):
        return self.get()


cdef class ConstantPointerNull(ConstantData):
    def get(self, AttributeSet attrs=None):
        return 0
    def __int__(self):
        return 0
    def __str__(self):
        return "NULL"


cdef class ConstantTokenNone(ConstantData):
    def get(self, AttributeSet attrs=None):
        raise InvalidValue("Constant has no value.")


cdef class UndefValue(ConstantData):
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
    cdef inline ir.Function* _function(self):
        return get[ir.Function](self._val)


cdef class GlobalVariable(Constant):
    def get(self, AttributeSet attrs=None):
        raise InvalidValue("GlobalVariable has no value.")

