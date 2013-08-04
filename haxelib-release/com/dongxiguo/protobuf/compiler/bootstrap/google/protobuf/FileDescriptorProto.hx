package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf;
typedef FileDescriptorProto = {
	@:optional public var unknownFields(default,null):com.dongxiguo.protobuf.unknownField.ReadonlyUnknownFieldMap;
	@:optional public var name(default,null):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_STRING>;
	@:optional public var package_(default,null):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_STRING>;
	public var dependency(default,null):Iterable<com.dongxiguo.protobuf.Types.TYPE_STRING>;
	public var publicDependency(default,null):Iterable<com.dongxiguo.protobuf.Types.TYPE_INT32>;
	public var weakDependency(default,null):Iterable<com.dongxiguo.protobuf.Types.TYPE_INT32>;
	public var messageType(default,null):Iterable<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.DescriptorProto>;
	public var enumType(default,null):Iterable<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.EnumDescriptorProto>;
	public var service(default,null):Iterable<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.ServiceDescriptorProto>;
	public var extension(default,null):Iterable<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FieldDescriptorProto>;
	@:optional public var options(default,null):StdTypes.Null<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FileOptions>;
	@:optional public var sourceCodeInfo(default,null):StdTypes.Null<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.SourceCodeInfo>;
}