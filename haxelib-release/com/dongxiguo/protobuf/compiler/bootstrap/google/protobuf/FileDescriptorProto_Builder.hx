package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf;
class FileDescriptorProto_Builder {
	@:optional public var unknownFields(default,default):com.dongxiguo.protobuf.unknownField.UnknownFieldMap;
	@:optional public var name(default,default):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_STRING>;
	@:optional public var package_(default,default):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_STRING>;
	public var dependency(default,default):Array<com.dongxiguo.protobuf.Types.TYPE_STRING>;
	public var publicDependency(default,default):Array<com.dongxiguo.protobuf.Types.TYPE_INT32>;
	public var weakDependency(default,default):Array<com.dongxiguo.protobuf.Types.TYPE_INT32>;
	public var messageType(default,default):Array<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.DescriptorProto_Builder>;
	public var enumType(default,default):Array<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.EnumDescriptorProto_Builder>;
	public var service(default,default):Array<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.ServiceDescriptorProto_Builder>;
	public var extension(default,default):Array<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FieldDescriptorProto_Builder>;
	@:optional public var options(default,default):StdTypes.Null<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FileOptions_Builder>;
	@:optional public var sourceCodeInfo(default,default):StdTypes.Null<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.SourceCodeInfo_Builder>;
	public inline function new() {
		this.dependency=[];
		this.publicDependency=[];
		this.weakDependency=[];
		this.messageType=[];
		this.enumType=[];
		this.service=[];
		this.extension=[];
	}
}