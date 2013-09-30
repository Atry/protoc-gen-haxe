package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto;
abstract Label(StdTypes.Int) {
	public inline function new(number:StdTypes.Int) {
		this=number;
	}
	public var number(get,never):StdTypes.Int;
	inline function get_number():StdTypes.Int {
		return this;
	}
	static public var LABEL_OPTIONAL(default,never)=new com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Label(1);
	static public var LABEL_REQUIRED(default,never)=new com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Label(2);
	static public var LABEL_REPEATED(default,never)=new com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Label(3);
}