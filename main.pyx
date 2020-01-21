# cython: language_level=3
# vim: set et ts=4 sw=4:

cimport pyllco
cimport ir
cimport attr_kind

from pyllco_helper cimport get, get_subclass
from libcpp.memory cimport unique_ptr
from libcpp.string cimport string
from cython.operator cimport dereference as deref

#include "attr_kind.pyx"

class InvalidValue(Exception):
    pass

cdef class AttributeSet():
    cdef inline _has_attribute_str(self, attr):
        cdef string a = attr.encode('UTF-8')
        return self._set.hasAttribute(a)

    cdef inline _has_attribute_attr(self, int attr):
        cdef attr_kind.AttrKind a = <attr_kind.AttrKind> attr
        return self._set.hasAttribute(a)

    def has_attribute(self, attr):
        if isinstance(attr, str):
            return self._has_attribute_str(attr)
        if isinstance(attr, AttrKind):
            return self._has_attribute_attr(attr)
        return False


cdef public object get_obj_from_attr_set(ir.AttributeSet& s):
    cdef AttributeSet attrs = AttributeSet()
    attrs._set = s
    return attrs


cdef class Value:
    def get_name(self):
        return self._val.getName().str().decode('UTF-8')


cdef class User(Value):
    cdef inline ir.User* _user(self):
        return get[ir.User](self._val)


cdef class Constant(User):
    cdef inline ir.Constant* _constant(self):
        return get[ir.Constant](self._val)

    def get(self, AttributeSet attrs=None):
        raise NotImplementedError("Type cannot return a Python value")


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


cdef class ConstantPointerNull(ConstantData):
    def get(self, AttributeSet attrs=None):
        return 0


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
    pass


cdef public object get_obj_from_value(ir.Value* val):
    c = get_subclass(val).decode('UTF-8')
    cdef Value py_val
    if c in globals():
        py_val = globals()[c]()
        py_val._val = val
        return py_val
    assert False, "Pyllco is incomplete. It should never reach this state."
