package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf;
typedef DescriptorProto = {
	@:optional public var name(default,null):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_STRING>;
	public var field(default,null):Iterable<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FieldDescriptorProto>;
	public var extension(default,null):Iterable<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FieldDescriptorProto>;
	public var nestedType(default,null):Iterable<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.DescriptorProto>;
	public var enumType(default,null):Iterable<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.EnumDescriptorProto>;
	public var extensionRange(default,null):Iterable<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.descriptorProto.ExtensionRange>;
	@:optional public var options(default,null):StdTypes.Null<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.MessageOptions>;
}