package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf;
abstract EnumValueOptions_ExtensionSet(Array<com.dongxiguo.protobuf.UnknownField<Dynamic>>) to Array<com.dongxiguo.protobuf.UnknownField<Dynamic>> {
	inline function new(sortedArray:Array<com.dongxiguo.protobuf.UnknownField<Dynamic>>) {
		this=sortedArray;
	}
	public static inline function sortUnknownFields(array:Array<com.dongxiguo.protobuf.UnknownField<Dynamic>>):com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.EnumValueOptions_ExtensionSet {
		array.sort(com.dongxiguo.protobuf.UnknownField.compare);
		return new com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.EnumValueOptions_ExtensionSet(array);
	}
}