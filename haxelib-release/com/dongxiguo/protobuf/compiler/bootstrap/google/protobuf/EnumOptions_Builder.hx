package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf;
class EnumOptions_Builder {
	@:optional public var unknownFields(default,default):Array<com.dongxiguo.protobuf.UnknownField<Dynamic>>;
	static var __default_allowAlias(null,never):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_BOOL>=true;
	inline function set_allowAlias(value) {
		return allowAlias=value;
	}
	inline function get_allowAlias() if(allowAlias!=null) {
		return allowAlias;
	} else {
		return __default_allowAlias;
	}
	@:isVar public var allowAlias(get_allowAlias,set_allowAlias):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_BOOL>;
	public var uninterpretedOption(default,default):Array<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.UninterpretedOption_Builder>;
	public function new() {
		this.uninterpretedOption=[];
	}
	public inline function sortUnknownFields() {
		return com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.EnumOptions_ExtensionSet.sortUnknownFields(this.unknownFields);
	}
}