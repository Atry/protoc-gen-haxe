package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fileOptions;
abstract OptimizeMode(StdTypes.Int) {
	public inline function new(number:StdTypes.Int) {
		this=number;
	}
	public var number(get,never):StdTypes.Int;
	inline function get_number():StdTypes.Int {
		return this;
	}
	static public var SPEED(default,never)=new com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fileOptions.OptimizeMode(1);
	static public var CODE_SIZE(default,never)=new com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fileOptions.OptimizeMode(2);
	static public var LITE_RUNTIME(default,never)=new com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fileOptions.OptimizeMode(3);
}