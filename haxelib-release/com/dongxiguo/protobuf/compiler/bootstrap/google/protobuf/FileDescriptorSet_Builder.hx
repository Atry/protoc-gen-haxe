package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf;
class FileDescriptorSet_Builder {
	@:optional public var unknownFields(default,default):com.dongxiguo.protobuf.unknownField.UnknownFieldMap;
	public var file(default,default):Array<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FileDescriptorProto_Builder>;
	public inline function new() {
		this.file=[];
	}
}