package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf;
class DescriptorProto_Merger {
	static var FIELD_MAP(default,never):com.dongxiguo.protobuf.binaryFormat.ReadUtils.FieldMap<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.DescriptorProto_Builder>={
		var fieldMap=new com.dongxiguo.protobuf.binaryFormat.ReadUtils.FieldMap<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.DescriptorProto_Builder>();
		{
			fieldMap.set(10,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.DescriptorProto_Builder,input:com.dongxiguo.protobuf.binaryFormat.ILimitableInput) builder.name=com.dongxiguo.protobuf.binaryFormat.ReadUtils.readString(input));
			fieldMap.set(18,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.DescriptorProto_Builder,input:com.dongxiguo.protobuf.binaryFormat.ILimitableInput) builder.field.push({
				var fieldBuilder=new com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FieldDescriptorProto_Builder();
				com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FieldDescriptorProto_Merger.mergeDelimitedFrom(fieldBuilder,input);
				fieldBuilder;
			}));
			fieldMap.set(50,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.DescriptorProto_Builder,input:com.dongxiguo.protobuf.binaryFormat.ILimitableInput) builder.extension.push({
				var fieldBuilder=new com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FieldDescriptorProto_Builder();
				com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FieldDescriptorProto_Merger.mergeDelimitedFrom(fieldBuilder,input);
				fieldBuilder;
			}));
			fieldMap.set(26,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.DescriptorProto_Builder,input:com.dongxiguo.protobuf.binaryFormat.ILimitableInput) builder.nestedType.push({
				var fieldBuilder=new com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.DescriptorProto_Builder();
				com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.DescriptorProto_Merger.mergeDelimitedFrom(fieldBuilder,input);
				fieldBuilder;
			}));
			fieldMap.set(34,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.DescriptorProto_Builder,input:com.dongxiguo.protobuf.binaryFormat.ILimitableInput) builder.enumType.push({
				var fieldBuilder=new com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.EnumDescriptorProto_Builder();
				com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.EnumDescriptorProto_Merger.mergeDelimitedFrom(fieldBuilder,input);
				fieldBuilder;
			}));
			fieldMap.set(42,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.DescriptorProto_Builder,input:com.dongxiguo.protobuf.binaryFormat.ILimitableInput) builder.extensionRange.push({
				var fieldBuilder=new com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.descriptorProto.ExtensionRange_Builder();
				com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.descriptorProto.ExtensionRange_Merger.mergeDelimitedFrom(fieldBuilder,input);
				fieldBuilder;
			}));
			fieldMap.set(58,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.DescriptorProto_Builder,input:com.dongxiguo.protobuf.binaryFormat.ILimitableInput) builder.options={
				var fieldBuilder=new com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.MessageOptions_Builder();
				com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.MessageOptions_Merger.mergeDelimitedFrom(fieldBuilder,input);
				fieldBuilder;
			});
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