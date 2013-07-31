package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fileOptions;
class OptimizeMode_EnumClass {
	static public function getNumber(enumValue:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fileOptions.OptimizeMode):StdTypes.Int return switch enumValue {
		case com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fileOptions.OptimizeMode.SPEED:1;
		case com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fileOptions.OptimizeMode.CODE_SIZE:2;
		case com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fileOptions.OptimizeMode.LITE_RUNTIME:3;
	}
	static public function valueOf(number:StdTypes.Int):com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fileOptions.OptimizeMode return switch number {
		case 1:{
			com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fileOptions.OptimizeMode.SPEED;
		};
		case 2:{
			com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fileOptions.OptimizeMode.CODE_SIZE;
		};
		case 3:{
			com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fileOptions.OptimizeMode.LITE_RUNTIME;
		};
		default:{
			throw "Unknown enum value: "+number;
		};
	}
}