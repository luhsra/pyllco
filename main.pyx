# SPDX-FileCopyrightText: 2020 Gerion Entrup <entrup@sra.uni-hannover.de>
# SPDX-FileCopyrightText: 2021 Gerion Entrup <entrup@sra.uni-hannover.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# cython: language_level=3
# vim: set et ts=4 sw=4:

cimport pyllco
cimport ir
cimport attr_kind

from pyllco_helper cimport get, get_subclass, to_string
from libcpp.memory cimport unique_ptr
from libcpp.string cimport string
from cython.operator cimport dereference as deref
from libc.stdint cimport intptr_t

#include "attr_kind.pyx"

class InvalidValue(Exception):
    """LLVM value has no Python representation."""

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

    def __str__(self):
        return to_string[ir.Value](deref(self._val)).decode('UTF-8')

    def __hash__(self):
        return hash("pyllco.Value") + int(<intptr_t> self._val)

    def __eq__(self, Value other):
        return self._val == other._val


cdef public object get_obj_from_value(ir.Value& val):
    c = get_subclass(val).decode('UTF-8')
    cdef Value py_val
    if c in globals():
        py_val = globals()[c]()
        py_val._val = &val
        return py_val
    assert False, f"Unreachable state. Subclass = {c}"


cdef class User(Value):
    cdef inline ir.User* _user(self):
        return get[ir.User](self._val)

#include "argument.pyx"
#include "basic_block.pyx"
#include "constants.pyx"
#include "instructions.pyx"

cdef public ir.Value* get_value_from_obj(object val_o):
    cdef Value val = val_o
    return val._val
