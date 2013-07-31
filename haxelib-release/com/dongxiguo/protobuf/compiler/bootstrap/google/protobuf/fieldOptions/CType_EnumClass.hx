package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldOptions;
class CType_EnumClass {
	static public function getNumber(enumValue:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldOptions.CType):StdTypes.Int return switch enumValue {
		case com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldOptions.CType.STRING:0;
		case com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldOptions.CType.CORD:1;
		case com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldOptions.CType.STRING_PIECE:2;
	}
	static public function valueOf(number:StdTypes.Int):com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldOptions.CType return switch number {
		case 0:{
			com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldOptions.CType.STRING;
		};
		case 1:{
			com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldOptions.CType.CORD;
		};
		case 2:{
			com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldOptions.CType.STRING_PIECE;
		};
		default:{
			throw "Unknown enum value: "+number;
		};
	}
}