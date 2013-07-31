package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto;
class Label_EnumClass {
	static public function getNumber(enumValue:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Label):StdTypes.Int return switch enumValue {
		case com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Label.LABEL_OPTIONAL:1;
		case com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Label.LABEL_REQUIRED:2;
		case com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Label.LABEL_REPEATED:3;
	}
	static public function valueOf(number:StdTypes.Int):com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Label return switch number {
		case 1:{
			com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Label.LABEL_OPTIONAL;
		};
		case 2:{
			com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Label.LABEL_REQUIRED;
		};
		case 3:{
			com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Label.LABEL_REPEATED;
		};
		default:{
			throw "Unknown enum value: "+number;
		};
	}
}