package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.uninterpretedOption;
class NamePart_Merger {
	static var FIELD_MAP(default,never):com.dongxiguo.protobuf.binaryFormat.ReadUtils.FieldMap<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.uninterpretedOption.NamePart_Builder>={
		var fieldMap=new com.dongxiguo.protobuf.binaryFormat.ReadUtils.FieldMap<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.uninterpretedOption.NamePart_Builder>();
		{
			fieldMap.set(10,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.uninterpretedOption.NamePart_Builder,input:com.dongxiguo.protobuf.binaryFormat.ILimitableInput) builder.namePart=com.dongxiguo.protobuf.binaryFormat.ReadUtils.readString(input));
			fieldMap.set(16,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.uninterpretedOption.NamePart_Builder,input:com.dongxiguo.protobuf.binaryFormat.ILimitableInput) builder.isExtension=com.dongxiguo.protobuf.binaryFormat.ReadUtils.readBool(input));
		};
		fieldMap;
	};
	public static inline function mergeFrom(builder,input):Void {
		com.dongxiguo.protobuf.binaryFormat.ReadUtils.mergeFrom(FIELD_MAP,builder,input);
	}
	public static inline function mergeDelimitedFrom(builder,input):Void {
		com.dongxiguo.protobuf.binaryFormat.ReadUtils.mergeDelimitedFrom(FIELD_MAP,builder,input);
	}
}