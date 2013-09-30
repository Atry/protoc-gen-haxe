package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf;
class ServiceDescriptorProto_Builder {
	@:optional public var unknownFields(default,default):com.dongxiguo.protobuf.unknownField.UnknownFieldMap;
	@:optional public var name(default,default):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_STRING>;
	public var method(default,default):Array<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.MethodDescriptorProto_Builder>;
	@:optional public var options(default,default):StdTypes.Null<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.ServiceOptions_Builder>;
	public inline function new() {
		this.method=[];
	}
}