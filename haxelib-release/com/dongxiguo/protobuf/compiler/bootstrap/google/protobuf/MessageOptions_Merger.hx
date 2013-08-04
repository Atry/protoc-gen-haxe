package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf;
class MessageOptions_Merger {
	static var FIELD_MAP(default,never):com.dongxiguo.protobuf.binaryFormat.ReadUtils.FieldMap<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.MessageOptions_Builder>={
		var fieldMap=new com.dongxiguo.protobuf.binaryFormat.ReadUtils.FieldMap<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.MessageOptions_Builder>();
		{
			fieldMap.set(8,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.MessageOptions_Builder,input:com.dongxiguo.protobuf.binaryFormat.IBinaryInput) builder.messageSetWireFormat=com.dongxiguo.protobuf.binaryFormat.ReadUtils.readBool(input));
			fieldMap.set(16,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.MessageOptions_Builder,input:com.dongxiguo.protobuf.binaryFormat.IBinaryInput) builder.noStandardDescriptorAccessor=com.dongxiguo.protobuf.binaryFormat.ReadUtils.readBool(input));
			fieldMap.set(7994,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.MessageOptions_Builder,input:com.dongxiguo.protobuf.binaryFormat.IBinaryInput) builder.uninterpretedOption.push({
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