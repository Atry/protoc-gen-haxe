package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto;
extern class Label_EnumClass {
	@:extern public static inline function valueOf(number:StdTypes.Int):com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Label return switch number {
		case 1:{
			com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Label.LABEL_OPTIONAL;
		}
		case 2:{
			com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Label.LABEL_REQUIRED;
		}
		case 3:{
			com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Label.LABEL_REPEATED;
		}
		default:{
			throw "Unknown enum value: "+number;
		}
	}
}