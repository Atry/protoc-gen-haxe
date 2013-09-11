package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fileOptions;
class OptimizeMode_EnumClass {
	inline static public function getNumber(enumValue:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fileOptions.OptimizeMode):StdTypes.Int {
		return Type.enumIndex(enumValue) + 1;
	}
	inline static public function valueOf(number:StdTypes.Int):com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fileOptions.OptimizeMode {
		return Type.createEnumIndex(com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fileOptions.OptimizeMode, number - 1);
	}
}