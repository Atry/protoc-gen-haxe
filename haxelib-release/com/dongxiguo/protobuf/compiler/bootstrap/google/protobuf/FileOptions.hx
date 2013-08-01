package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf;
typedef FileOptions = {
	@:optional public var unknownFields(default,null):Iterable<com.dongxiguo.protobuf.UnknownField<Dynamic>>;
	@:optional public var javaPackage(default,null):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_STRING>;
	@:optional public var javaOuterClassname(default,null):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_STRING>;
	@:isVar public var javaMultipleFiles(get_javaMultipleFiles,set_javaMultipleFiles):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_BOOL>;
	@:isVar public var javaGenerateEqualsAndHash(get_javaGenerateEqualsAndHash,set_javaGenerateEqualsAndHash):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_BOOL>;
	@:isVar public var optimizeFor(get_optimizeFor,set_optimizeFor):StdTypes.Null<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fileOptions.OptimizeMode>;
	@:optional public var goPackage(default,null):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_STRING>;
	@:isVar public var ccGenericServices(get_ccGenericServices,set_ccGenericServices):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_BOOL>;
	@:isVar public var javaGenericServices(get_javaGenericServices,set_javaGenericServices):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_BOOL>;
	@:isVar public var pyGenericServices(get_pyGenericServices,set_pyGenericServices):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_BOOL>;
	public var uninterpretedOption(default,null):Iterable<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.UninterpretedOption>;
}