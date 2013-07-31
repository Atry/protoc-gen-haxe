package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto;
class Type_EnumClass {
	static public function getNumber(enumValue:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type):StdTypes.Int return switch enumValue {
		case com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type.TYPE_DOUBLE:1;
		case com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type.TYPE_FLOAT:2;
		case com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type.TYPE_INT64:3;
		case com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type.TYPE_UINT64:4;
		case com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type.TYPE_INT32:5;
		case com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type.TYPE_FIXED64:6;
		case com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type.TYPE_FIXED32:7;
		case com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type.TYPE_BOOL:8;
		case com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type.TYPE_STRING:9;
		case com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type.TYPE_GROUP:10;
		case com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type.TYPE_MESSAGE:11;
		case com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type.TYPE_BYTES:12;
		case com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type.TYPE_UINT32:13;
		case com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type.TYPE_ENUM:14;
		case com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type.TYPE_SFIXED32:15;
		case com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type.TYPE_SFIXED64:16;
		case com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type.TYPE_SINT32:17;
		case com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type.TYPE_SINT64:18;
	}
	static public function valueOf(number:StdTypes.Int):com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type return switch number {
		case 1:{
			com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type.TYPE_DOUBLE;
		};
		case 2:{
			com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type.TYPE_FLOAT;
		};
		case 3:{
			com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type.TYPE_INT64;
		};
		case 4:{
			com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type.TYPE_UINT64;
		};
		case 5:{
			com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type.TYPE_INT32;
		};
		case 6:{
			com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type.TYPE_FIXED64;
		};
		case 7:{
			com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type.TYPE_FIXED32;
		};
		case 8:{
			com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type.TYPE_BOOL;
		};
		case 9:{
			com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type.TYPE_STRING;
		};
		case 10:{
			com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type.TYPE_GROUP;
		};
		case 11:{
			com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type.TYPE_MESSAGE;
		};
		case 12:{
			com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type.TYPE_BYTES;
		};
		case 13:{
			com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type.TYPE_UINT32;
		};
		case 14:{
			com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type.TYPE_ENUM;
		};
		case 15:{
			com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type.TYPE_SFIXED32;
		};
		case 16:{
			com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type.TYPE_SFIXED64;
		};
		case 17:{
			com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type.TYPE_SINT32;
		};
		case 18:{
			com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type.TYPE_SINT64;
		};
		default:{
			throw "Unknown enum value: "+number;
		};
	}
}