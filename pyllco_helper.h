#pragma once

#include <exception>
#include <iostream>
#include <llvm/IR/Value.h>
#include <llvm/IR/Instructions.h>
#include <llvm/IR/Module.h>
#include <llvm/Support/raw_ostream.h>
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
	std::string get_subclass(const llvm::Value& v);

	/**
	 * return output to llvm stream as string
	 */
	template <class T>
	std::string to_string(T& obj) {
		std::string ret;
		llvm::raw_string_ostream retsstream(ret);
		retsstream << obj;
		retsstream.str();
		return ret;
	}

	/**
	 * Calculate the offset of an GetElementPtrInst if possible
	 */
	bool get_gep_offset(const llvm::GetElementPtrInst& gep, int64_t& offset);

} // namespace pyllco
