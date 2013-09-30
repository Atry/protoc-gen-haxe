package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf;
class FileOptions_Builder {
	@:optional public var unknownFields(default,default):com.dongxiguo.protobuf.unknownField.UnknownFieldMap;
	@:optional public var javaPackage(default,default):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_STRING>;
	@:optional public var javaOuterClassname(default,default):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_STRING>;
	static var __default_javaMultipleFiles(null,never):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_BOOL>=false;
	inline function set_javaMultipleFiles(value) {
		return javaMultipleFiles=value;
	}
	inline function get_javaMultipleFiles() if(javaMultipleFiles!=null) {
		return javaMultipleFiles;
	} else {
		return __default_javaMultipleFiles;
	}
	@:isVar public var javaMultipleFiles(get_javaMultipleFiles,set_javaMultipleFiles):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_BOOL>;
	static var __default_javaGenerateEqualsAndHash(null,never):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_BOOL>=false;
	inline function set_javaGenerateEqualsAndHash(value) {
		return javaGenerateEqualsAndHash=value;
	}
	inline function get_javaGenerateEqualsAndHash() if(javaGenerateEqualsAndHash!=null) {
		return javaGenerateEqualsAndHash;
	} else {
		return __default_javaGenerateEqualsAndHash;
	}
	@:isVar public var javaGenerateEqualsAndHash(get_javaGenerateEqualsAndHash,set_javaGenerateEqualsAndHash):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_BOOL>;
	static var __default_optimizeFor(null,never):StdTypes.Null<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fileOptions.OptimizeMode>=com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fileOptions.OptimizeMode.SPEED;
	inline function set_optimizeFor(value) {
		return optimizeFor=value;
	}
	inline function get_optimizeFor() if(optimizeFor!=null) {
		return optimizeFor;
	} else {
		return __default_optimizeFor;
	}
	@:isVar public var optimizeFor(get_optimizeFor,set_optimizeFor):StdTypes.Null<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fileOptions.OptimizeMode>;
	@:optional public var goPackage(default,default):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_STRING>;
	static var __default_ccGenericServices(null,never):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_BOOL>=false;
	inline function set_ccGenericServices(value) {
		return ccGenericServices=value;
	}
	inline function get_ccGenericServices() if(ccGenericServices!=null) {
		return ccGenericServices;
	} else {
		return __default_ccGenericServices;
	}
	@:isVar public var ccGenericServices(get_ccGenericServices,set_ccGenericServices):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_BOOL>;
	static var __default_javaGenericServices(null,never):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_BOOL>=false;
	inline function set_javaGenericServices(value) {
		return javaGenericServices=value;
	}
	inline function get_javaGenericServices() if(javaGenericServices!=null) {
		return javaGenericServices;
	} else {
		return __default_javaGenericServices;
	}
	@:isVar public var javaGenericServices(get_javaGenericServices,set_javaGenericServices):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_BOOL>;
	static var __default_pyGenericServices(null,never):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_BOOL>=false;
	inline function set_pyGenericServices(value) {
		return pyGenericServices=value;
	}
	inline function get_pyGenericServices() if(pyGenericServices!=null) {
		return pyGenericServices;
	} else {
		return __default_pyGenericServices;
	}
	@:isVar public var pyGenericServices(get_pyGenericServices,set_pyGenericServices):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_BOOL>;
	public var uninterpretedOption(default,default):Array<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.UninterpretedOption_Builder>;
	public inline function new() {
		this.uninterpretedOption=[];
	}
}