# cython: language_level=3
# vim: set et ts=4 sw=4:

cimport ir

cdef class Instruction(User):
    pass

cdef class AtomicCmpXchgInst(Instruction):
    pass

cdef class AtomicRMWInst(Instruction):
    pass

cdef class BinaryOperator(Instruction):
    pass

cdef class BranchInst(Instruction):
    pass

cdef class CallBase(Instruction):
    pass

cdef class CallBrInst(Instruction):
    pass

cdef class CallInst(Instruction):
    pass

cdef class InvokeInst(Instruction):
    pass

cdef class CatchReturnInst(Instruction):
    pass

cdef class CatchSwitchInst(Instruction):
    pass

cdef class CleanupReturnInst(Instruction):
    pass

cdef class CmpInst(Instruction):
    pass

cdef class ICmpInst(Instruction):
    pass

cdef class FCmpInst(Instruction):
    pass

cdef class ExtractElementInst(Instruction):
    pass

cdef class FenceInst(Instruction):
    pass

cdef class FuncletPadInst(Instruction):
    pass

cdef class CleanupPadInst(Instruction):
    pass

cdef class CatchPadInst(Instruction):
    pass

cdef class GetElementPtrInst(Instruction):
    pass

cdef class IndirectBrInst(Instruction):
    pass

cdef class InsertElementInst(Instruction):
    pass

cdef class InsertValueInst(Instruction):
    pass

cdef class LandingPadInst(Instruction):
    pass

cdef class PHINode(Instruction):
    pass

cdef class ResumeInst(Instruction):
    pass

cdef class ReturnInst(Instruction):
    pass

cdef class SelectInst(Instruction):
    pass

cdef class ShuffleVectorInst(Instruction):
    pass

cdef class StoreInst(Instruction):
    pass

cdef class SwitchInst(Instruction):
    pass

cdef class UnaryInstruction(Instruction):
    pass

cdef class UnreachableInst(Instruction):
    pass
