package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf;
typedef ServiceDescriptorProto = {
	@:optional public var unknownFields(default,null):com.dongxiguo.protobuf.unknownField.ReadonlyUnknownFieldMap;
	@:optional public var name(default,null):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_STRING>;
	public var method(default,null):Iterable<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.MethodDescriptorProto>;
	@:optional public var options(default,null):StdTypes.Null<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.ServiceOptions>;
}