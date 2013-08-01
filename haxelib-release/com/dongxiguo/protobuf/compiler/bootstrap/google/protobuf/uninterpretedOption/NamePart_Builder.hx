package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.uninterpretedOption;
class NamePart_Builder {
	@:optional public var unknownFields(default,default):Array<com.dongxiguo.protobuf.UnknownField<Dynamic>>;
	public var namePart(default,default):com.dongxiguo.protobuf.Types.TYPE_STRING;
	public var isExtension(default,default):com.dongxiguo.protobuf.Types.TYPE_BOOL;
	public function new() {
	}
	public inline function sortUnknownFields() {
		return com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.uninterpretedOption.NamePart_ExtensionSet.sortUnknownFields(this.unknownFields);
	}
}