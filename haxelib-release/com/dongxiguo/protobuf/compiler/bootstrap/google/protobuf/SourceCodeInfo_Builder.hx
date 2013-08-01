package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf;
class SourceCodeInfo_Builder {
	@:optional public var unknownFields(default,default):Array<com.dongxiguo.protobuf.UnknownField<Dynamic>>;
	public var location(default,default):Array<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.sourceCodeInfo.Location_Builder>;
	public function new() {
		this.location=[];
	}
	public inline function sortUnknownFields() {
		return com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.SourceCodeInfo_ExtensionSet.sortUnknownFields(this.unknownFields);
	}
}