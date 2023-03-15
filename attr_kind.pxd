# SPDX-FileCopyrightText: 2020 Gerion Entrup <entrup@sra.uni-hannover.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# cython: language_level=3
# vim: set et ts=4 sw=4:

# autogenerated with ./gen_attr_kind.py and includes '/usr/lib/llvm/9/include/'

cdef extern from "llvm/IR/Attributes.h" namespace "llvm::Attribute":
    cdef cppclass AttrKind:
        pass

cdef extern from "llvm/IR/Attributes.h" namespace "llvm::Attribute::AttrKind":
    cdef AttrKind Alignment
    cdef AttrKind AllocSize
    cdef AttrKind AlwaysInline
    cdef AttrKind ArgMemOnly
    cdef AttrKind Builtin
    cdef AttrKind ByVal
    cdef AttrKind Cold
    cdef AttrKind Convergent
    cdef AttrKind Dereferenceable
    cdef AttrKind DereferenceableOrNull
    cdef AttrKind ImmArg
    cdef AttrKind InAlloca
    cdef AttrKind InReg
    cdef AttrKind InaccessibleMemOnly
    cdef AttrKind InaccessibleMemOrArgMemOnly
    cdef AttrKind InlineHint
    cdef AttrKind JumpTable
    cdef AttrKind MinSize
    cdef AttrKind Naked
    cdef AttrKind Nest
    cdef AttrKind NoAlias
    cdef AttrKind NoBuiltin
    cdef AttrKind NoCapture
    cdef AttrKind NoCfCheck
    cdef AttrKind NoDuplicate
    cdef AttrKind NoFree
    cdef AttrKind NoImplicitFloat
    cdef AttrKind NoInline
    cdef AttrKind NoRecurse
    cdef AttrKind NoRedZone
    cdef AttrKind NoReturn
    cdef AttrKind NoSync
    cdef AttrKind NoUnwind
    cdef AttrKind NonLazyBind
    cdef AttrKind NonNull
    cdef AttrKind OptForFuzzing
    cdef AttrKind OptimizeForSize
    cdef AttrKind OptimizeNone
    cdef AttrKind ReadNone
    cdef AttrKind ReadOnly
    cdef AttrKind Returned
    cdef AttrKind ReturnsTwice
    cdef AttrKind SExt
    cdef AttrKind SafeStack
    cdef AttrKind SanitizeAddress
    cdef AttrKind SanitizeHWAddress
    cdef AttrKind SanitizeMemTag
    cdef AttrKind SanitizeMemory
    cdef AttrKind SanitizeThread
    cdef AttrKind ShadowCallStack
    cdef AttrKind Speculatable
    cdef AttrKind SpeculativeLoadHardening
    cdef AttrKind StackAlignment
    cdef AttrKind StackProtect
    cdef AttrKind StackProtectReq
    cdef AttrKind StackProtectStrong
    cdef AttrKind StrictFP
    cdef AttrKind StructRet
    cdef AttrKind SwiftError
    cdef AttrKind SwiftSelf
    cdef AttrKind UWTable
    cdef AttrKind WillReturn
    cdef AttrKind WriteOnly
    cdef AttrKind ZExt
