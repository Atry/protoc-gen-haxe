package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf;
class EnumValueOptions_Builder {
	@:optional public var unknownFields(default,default):Array<com.dongxiguo.protobuf.UnknownField<Dynamic>>;
	public var uninterpretedOption(default,default):Array<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.UninterpretedOption_Builder>;
	public function new() {
		this.uninterpretedOption=[];
	}
	public inline function sortUnknownFields() {
		return com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.EnumValueOptions_ExtensionSet.sortUnknownFields(this.unknownFields);
	}
}