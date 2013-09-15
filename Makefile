PROTOC=protoc

all release.zip: \
haxelib-release/haxelib.json \
haxelib-release/run.n \
haxelib-release/haxedoc.xml \
haxelib-release/LICENSE

ALL_SRCS=$(wildcard haxelib-release/com/dongxiguo/protobuf/compiler/bootstrap/google/protobuf/*.hx haxelib-release/com/dongxiguo/protobuf/compiler/bootstrap/google/protobuf/*/*.hx haxelib-release/com/dongxiguo/protobuf/*/*.hx haxelib-release/com/dongxiguo/protobuf/*.hx)

ALL_TESTS=$(wildcard test/com/dongxiguo/protobuf/test/*.hx)

all release.zip haxelib-release/haxedoc.xml haxelib-release/run.n: $(ALL_SRCS)\


install: release.zip
	haxelib local release.zip

haxelib-release/run.n:
	haxe run.hxml

haxelib-release/haxedoc.xml:
	haxe -lib haxelib-run --no-output -cp haxelib-release -xml $@ -dce no --macro 'include("com.dongxiguo.protobuf",true)'

release.zip:
	cd haxelib-release && zip --filesync ../$@ $(subst haxelib-release/,,$^)

clean:
	$(RM) haxelib-release/run.n haxelib-release/haxedoc.xml release.zip

descriptor.proto.bin: google/protobuf/descriptor.proto
	$(PROTOC) $< --descriptor_set_out=$@

google/protobuf: | google
	mkdir $@

google:
	mkdir $@

google/protobuf/%.proto: | google/protobuf
	svn export --force http://protobuf.googlecode.com/svn/trunk/src/google/protobuf/$*.proto $@

unittest.proto.bin: google/protobuf/unittest.proto google/protobuf/unittest_import.proto google/protobuf/unittest_import_public.proto
	$(PROTOC) --proto_path=. $^ --descriptor_set_out=$@

test_cs: test_cs.hxml unittest.proto.bin $(ALL_SRCS) $(ALL_TESTS)
	haxe test_cs.hxml
	touch $@

test_cpp: test_cpp.hxml unittest.proto.bin $(ALL_SRCS) $(ALL_TESTS)
	haxe test_cpp.hxml
	touch $@

test.n: test.n.hxml unittest.proto.bin $(ALL_SRCS) $(ALL_TESTS)
	haxe test.n.hxml

test.swf: test.swf.hxml unittest.proto.bin $(ALL_SRCS) $(ALL_TESTS)
	haxe test.swf.hxml

test.js: test.js.hxml unittest.proto.bin $(ALL_SRCS) $(ALL_TESTS)
	haxe test.js.hxml

test: test.js test.swf test.n test_cpp test_cs

regenerate-bootstrap: haxelib-release/run.n descriptor.proto.bin
	cd haxelib-release && neko run.n generateBootstrapFiles descriptor.proto.bin haxelib-release ..

.PHONY: all clean install test regenerate-bootstrap
