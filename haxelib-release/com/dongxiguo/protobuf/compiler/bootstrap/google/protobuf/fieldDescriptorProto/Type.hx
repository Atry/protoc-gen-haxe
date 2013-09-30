package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto;
abstract Type(StdTypes.Int) {
	public inline function new(number:StdTypes.Int) {
		this=number;
	}
	public var number(get,never):StdTypes.Int;
	inline function get_number():StdTypes.Int {
		return this;
	}
	static public var TYPE_DOUBLE(default,never)=new com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type(1);
	static public var TYPE_FLOAT(default,never)=new com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type(2);
	static public var TYPE_INT64(default,never)=new com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type(3);
	static public var TYPE_UINT64(default,never)=new com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type(4);
	static public var TYPE_INT32(default,never)=new com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type(5);
	static public var TYPE_FIXED64(default,never)=new com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type(6);
	static public var TYPE_FIXED32(default,never)=new com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type(7);
	static public var TYPE_BOOL(default,never)=new com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type(8);
	static public var TYPE_STRING(default,never)=new com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type(9);
	static public var TYPE_GROUP(default,never)=new com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type(10);
	static public var TYPE_MESSAGE(default,never)=new com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type(11);
	static public var TYPE_BYTES(default,never)=new com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type(12);
	static public var TYPE_UINT32(default,never)=new com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type(13);
	static public var TYPE_ENUM(default,never)=new com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type(14);
	static public var TYPE_SFIXED32(default,never)=new com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type(15);
	static public var TYPE_SFIXED64(default,never)=new com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type(16);
	static public var TYPE_SINT32(default,never)=new com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type(17);
	static public var TYPE_SINT64(default,never)=new com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type(18);
}