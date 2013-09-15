package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf;
class FileOptions_Merger {
	static var FIELD_MAP(default,never):com.dongxiguo.protobuf.binaryFormat.ReadUtils.FieldMap<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FileOptions_Builder>={
		var fieldMap=new com.dongxiguo.protobuf.binaryFormat.ReadUtils.FieldMap<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FileOptions_Builder>();
		{
			fieldMap.set(10,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FileOptions_Builder,input:com.dongxiguo.protobuf.binaryFormat.ILimitableInput) builder.javaPackage=com.dongxiguo.protobuf.binaryFormat.ReadUtils.readString(input));
			fieldMap.set(66,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FileOptions_Builder,input:com.dongxiguo.protobuf.binaryFormat.ILimitableInput) builder.javaOuterClassname=com.dongxiguo.protobuf.binaryFormat.ReadUtils.readString(input));
			fieldMap.set(80,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FileOptions_Builder,input:com.dongxiguo.protobuf.binaryFormat.ILimitableInput) builder.javaMultipleFiles=com.dongxiguo.protobuf.binaryFormat.ReadUtils.readBool(input));
			fieldMap.set(160,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FileOptions_Builder,input:com.dongxiguo.protobuf.binaryFormat.ILimitableInput) builder.javaGenerateEqualsAndHash=com.dongxiguo.protobuf.binaryFormat.ReadUtils.readBool(input));
			fieldMap.set(72,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FileOptions_Builder,input:com.dongxiguo.protobuf.binaryFormat.ILimitableInput) builder.optimizeFor=new com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fileOptions.OptimizeMode(com.dongxiguo.protobuf.binaryFormat.ReadUtils.readInt32(input)));
			fieldMap.set(90,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FileOptions_Builder,input:com.dongxiguo.protobuf.binaryFormat.ILimitableInput) builder.goPackage=com.dongxiguo.protobuf.binaryFormat.ReadUtils.readString(input));
			fieldMap.set(128,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FileOptions_Builder,input:com.dongxiguo.protobuf.binaryFormat.ILimitableInput) builder.ccGenericServices=com.dongxiguo.protobuf.binaryFormat.ReadUtils.readBool(input));
			fieldMap.set(136,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FileOptions_Builder,input:com.dongxiguo.protobuf.binaryFormat.ILimitableInput) builder.javaGenericServices=com.dongxiguo.protobuf.binaryFormat.ReadUtils.readBool(input));
			fieldMap.set(144,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FileOptions_Builder,input:com.dongxiguo.protobuf.binaryFormat.ILimitableInput) builder.pyGenericServices=com.dongxiguo.protobuf.binaryFormat.ReadUtils.readBool(input));
			fieldMap.set(7994,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FileOptions_Builder,input:com.dongxiguo.protobuf.binaryFormat.ILimitableInput) builder.uninterpretedOption.push({
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