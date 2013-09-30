package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldOptions;
abstract CType(StdTypes.Int) {
	public inline function new(number:StdTypes.Int) {
		this=number;
	}
	public var number(get,never):StdTypes.Int;
	inline function get_number():StdTypes.Int {
		return this;
	}
	static public var STRING(default,never)=new com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldOptions.CType(0);
	static public var CORD(default,never)=new com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldOptions.CType(1);
	static public var STRING_PIECE(default,never)=new com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldOptions.CType(2);
}