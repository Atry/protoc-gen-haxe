package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.sourceCodeInfo;
class Location_Builder {
	@:optional public var unknownFields(default,default):com.dongxiguo.protobuf.unknownField.UnknownFieldMap;
	public var path(default,default):Array<com.dongxiguo.protobuf.Types.TYPE_INT32>;
	public var span(default,default):Array<com.dongxiguo.protobuf.Types.TYPE_INT32>;
	@:optional public var leadingComments(default,default):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_STRING>;
	@:optional public var trailingComments(default,default):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_STRING>;
	public inline function new() {
		this.path=[];
		this.span=[];
	}
}