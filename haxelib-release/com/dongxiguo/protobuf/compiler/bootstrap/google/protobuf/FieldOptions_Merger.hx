package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf;
class FieldOptions_Merger {
	static var FIELD_MAP(default,never):com.dongxiguo.protobuf.binaryFormat.ReadUtils.FieldMap<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FieldOptions_Builder>={
		var fieldMap=new com.dongxiguo.protobuf.binaryFormat.ReadUtils.FieldMap<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FieldOptions_Builder>();
		{
			fieldMap.set(8,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FieldOptions_Builder,input:com.dongxiguo.protobuf.binaryFormat.ILimitableInput) builder.ctype=new com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldOptions.CType(com.dongxiguo.protobuf.binaryFormat.ReadUtils.readInt32(input)));
			fieldMap.set(16,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FieldOptions_Builder,input:com.dongxiguo.protobuf.binaryFormat.ILimitableInput) builder.packed=com.dongxiguo.protobuf.binaryFormat.ReadUtils.readBool(input));
			fieldMap.set(40,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FieldOptions_Builder,input:com.dongxiguo.protobuf.binaryFormat.ILimitableInput) builder.lazy=com.dongxiguo.protobuf.binaryFormat.ReadUtils.readBool(input));
			fieldMap.set(24,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FieldOptions_Builder,input:com.dongxiguo.protobuf.binaryFormat.ILimitableInput) builder.deprecated=com.dongxiguo.protobuf.binaryFormat.ReadUtils.readBool(input));
			fieldMap.set(74,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FieldOptions_Builder,input:com.dongxiguo.protobuf.binaryFormat.ILimitableInput) builder.experimentalMapKey=com.dongxiguo.protobuf.binaryFormat.ReadUtils.readString(input));
			fieldMap.set(80,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FieldOptions_Builder,input:com.dongxiguo.protobuf.binaryFormat.ILimitableInput) builder.weak=com.dongxiguo.protobuf.binaryFormat.ReadUtils.readBool(input));
			fieldMap.set(7994,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FieldOptions_Builder,input:com.dongxiguo.protobuf.binaryFormat.ILimitableInput) builder.uninterpretedOption.push({
				var fieldBuilder=new com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.UninterpretedOption_Builder();
				com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.UninterpretedOption_Merger.mergeDelimitedFrom(fieldBuilder,input);
				fieldBuilder;
			}));
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