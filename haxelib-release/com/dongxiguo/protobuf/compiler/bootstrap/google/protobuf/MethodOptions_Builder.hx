package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf;
class MethodOptions_Builder {
	@:optional public var unknownFields(default,default):Array<com.dongxiguo.protobuf.UnknownField<Dynamic>>;
	public var uninterpretedOption(default,default):Array<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.UninterpretedOption_Builder>;
	public function new() {
		this.uninterpretedOption=[];
	}
	public inline function sortUnknownFields() {
		return com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.MethodOptions_ExtensionSet.sortUnknownFields(this.unknownFields);
	}
}