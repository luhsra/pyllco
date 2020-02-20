#include "pyllco_helper.h"

#include <llvm/IR/Instruction.h>

namespace pyllco {
	std::string get_subclass(const llvm::Value& v) {
		// this is getting a little big ugly but the only possibility to circumvent
		// LLVM's strange handmade RTTI.
		//
		// This RTTI stores in every (child) object an additional number to indicate the type. Therefore the super class
		// needs to know all number in advance. This is mainly done with the ValueTy enum in Value.h. This enum is not
		// hardcoded but includes a special header Value.def. We can use this header as well to reverse the process.
		// Unfortunately, Instructions are handled separate. The concept of one unique number per subclass is broken. It
		// is one unique number per Opcode. This is done in another special header "Instruction.def". See
		// "Instruction.h" and "InstVisitor.h" for its regular usage. We can use this header as well.
		switch (v.getValueID()) {
#define HANDLE_VALUE(Name)                                                                                             \
	case llvm::Value::Name##Val:                                                                                       \
		return #Name;
#include <llvm/IR/Value.def>

#define HANDLE_INST(N, Opcode, Class)                                                                                  \
	case llvm::Value::InstructionVal + llvm::Instruction::Opcode:                                                      \
		return #Class;
#include <llvm/IR/Instruction.def>
		}

		assert(false);
		// make the compiler happy
		return "";
	}
} // namespace pyllco
