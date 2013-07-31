package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fileOptions;
extern class OptimizeMode_EnumClass {
	@:extern public static inline function valueOf(number:StdTypes.Int):com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fileOptions.OptimizeMode return switch number {
		case 1:{
			com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fileOptions.OptimizeMode.SPEED;
		}
		case 2:{
			com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fileOptions.OptimizeMode.CODE_SIZE;
		}
		case 3:{
			com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fileOptions.OptimizeMode.LITE_RUNTIME;
		}
		default:{
			throw "Unknown enum value: "+number;
		}
	}
}