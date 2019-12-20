#pragma once

#include <exception>
#include <iostream>
#include <llvm/IR/Value.h>
#include <memory>
#include <string>
#include <variant>

namespace pyllco {
	template <class T>
	T* get(llvm::Value* c) {
		if (T* r = llvm::dyn_cast<T>(c)) {
			return r;
		}
		throw std::bad_cast();
		return nullptr;
	}

	/**
	 * Return the actual subclass of llvm::Value as std::string.
	 */
	std::string get_subclass(llvm::Value* v);
} // namespace pyllco
