package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldOptions;

class CType_EnumClass {
	inline static public function getNumber(enumValue:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldOptions.CType):StdTypes.Int {
		return Type.enumIndex(enumValue);
	}
	inline static public function valueOf(number:StdTypes.Int):com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldOptions.CType {
		return Type.createEnumIndex(com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldOptions.CType, number);
	}
}