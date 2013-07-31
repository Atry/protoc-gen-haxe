package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldOptions;
extern class CType_EnumClass {
	@:extern public static inline function valueOf(number:StdTypes.Int):com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldOptions.CType return switch number {
		case 0:{
			com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldOptions.CType.STRING;
		}
		case 1:{
			com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldOptions.CType.CORD;
		}
		case 2:{
			com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldOptions.CType.STRING_PIECE;
		}
		default:{
			throw "Unknown enum value: "+number;
		}
	}
}