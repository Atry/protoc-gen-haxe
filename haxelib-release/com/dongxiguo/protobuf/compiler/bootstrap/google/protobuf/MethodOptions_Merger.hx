package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf;
class MethodOptions_Merger {
	public static var FIELD_MAP(default,never):com.dongxiguo.protobuf.binaryFormat.ReadUtils.FieldMap<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.MethodOptions_Builder>={
		var fieldMap=new com.dongxiguo.protobuf.binaryFormat.ReadUtils.FieldMap<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.MethodOptions_Builder>();
		{
			fieldMap.set(7994,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.MethodOptions_Builder,input:com.dongxiguo.protobuf.binaryFormat.IBinaryInput) builder.uninterpretedOption.push({
				var fieldBuilder=new com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.UninterpretedOption_Builder();
				com.dongxiguo.protobuf.binaryFormat.ReadUtils.mergeDelimitedFrom(com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.UninterpretedOption_Merger.FIELD_MAP,fieldBuilder,input);
				fieldBuilder;
			}));
		};
		fieldMap;
	}
	@:extern public static inline function mergeFrom(builder,input):Void {
		com.dongxiguo.protobuf.binaryFormat.ReadUtils.mergeFrom(FIELD_MAP,builder,input);
	}
	@:extern public static inline function mergeDelimitedFrom(builder,input):Void {
		com.dongxiguo.protobuf.binaryFormat.ReadUtils.mergeDelimitedFrom(FIELD_MAP,builder,input);
	}
}