#include "pyllco_helper.h"

namespace pyllco {
	std::string get_subclass(llvm::Value* v) {
		// this is getting a little big ugly but the only possibility to circumvent
		// LLVM's strange handmade RTTI.
		switch (v->getValueID()) {
#define HANDLE_VALUE(Name)                                                                                             \
	case llvm::Value::Name##Val:                                                                                       \
		return #Name;
#include "llvm/IR/Value.def"
		}

		assert(false);
		// make the compiler happy
		return "";
	}
} // namespace pyllco
