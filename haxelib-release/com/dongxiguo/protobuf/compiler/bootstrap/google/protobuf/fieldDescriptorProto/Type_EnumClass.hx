package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto;
import Type;
class Type_EnumClass {
	inline static public function getNumber(enumValue:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type):StdTypes.Int {
		return Type.enumIndex(enumValue) + 1;
	}
	inline static public function valueOf(number:StdTypes.Int):com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type {
		return Type.createEnumIndex(com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type, number - 1);
	}
	
}