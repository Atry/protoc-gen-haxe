package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf;
class DescriptorProto_Builder {
	@:optional public var unknownFields(default,default):com.dongxiguo.protobuf.unknownField.UnknownFieldMap;
	@:optional public var name(default,default):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_STRING>;
	public var field(default,default):Array<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FieldDescriptorProto_Builder>;
	public var extension(default,default):Array<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FieldDescriptorProto_Builder>;
	public var nestedType(default,default):Array<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.DescriptorProto_Builder>;
	public var enumType(default,default):Array<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.EnumDescriptorProto_Builder>;
	public var extensionRange(default,default):Array<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.descriptorProto.ExtensionRange_Builder>;
	@:optional public var options(default,default):StdTypes.Null<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.MessageOptions_Builder>;
	public inline function new() {
		this.field=[];
		this.extension=[];
		this.nestedType=[];
		this.enumType=[];
		this.extensionRange=[];
	}
}