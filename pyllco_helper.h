#pragma once

#include <llvm/IR/Value.h>
#include <exception>
#include <string>
#include <variant>
#include <memory>

namespace pyllco {
	template<class T>
	T* get(llvm::Value* c) {
		if (T* r = llvm::dyn_cast<T>(c)) {
			return r;
		}
		throw std::bad_cast();
		return nullptr;
	}

	/**
	 * Return the actual Subclass of Value as String. Since LLVM uses its own homegrown kind of RTTI this is kind of complicated.
	 */
	std::string get_subclass(llvm::Value* v) {
		return "foobar";
	}
}
