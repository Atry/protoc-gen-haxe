package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.sourceCodeInfo;
typedef Location = {
	public var path(default,null):Iterable<com.dongxiguo.protobuf.Types.TYPE_INT32>;
	public var span(default,null):Iterable<com.dongxiguo.protobuf.Types.TYPE_INT32>;
	@:optional public var leadingComments(default,null):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_STRING>;
	@:optional public var trailingComments(default,null):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_STRING>;
}