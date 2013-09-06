package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto;
import Type;
class Label_EnumClass {
	
	inline static public function getNumber(enumValue:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Label):StdTypes.Int {
		return Type.enumIndex(enumValue) + 1;
	}
	
	inline static public function valueOf(number:StdTypes.Int):com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Label {
		return Type.createEnumIndex(com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Label, number - 1);
	}
	
}