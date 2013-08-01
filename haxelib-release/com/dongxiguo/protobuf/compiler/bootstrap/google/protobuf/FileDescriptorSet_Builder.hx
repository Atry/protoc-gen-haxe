package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf;
class FileDescriptorSet_Builder {
	@:optional public var unknownFields(default,default):Array<com.dongxiguo.protobuf.UnknownField<Dynamic>>;
	public var file(default,default):Array<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FileDescriptorProto_Builder>;
	public function new() {
		this.file=[];
	}
	public inline function sortUnknownFields() {
		return com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FileDescriptorSet_ExtensionSet.sortUnknownFields(this.unknownFields);
	}
}