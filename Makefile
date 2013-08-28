all release.zip: \
haxelib-release/haxelib.json \
haxelib-release/run.n \
haxelib-release/haxedoc.xml \
haxelib-release/LICENSE

all release.zip haxelib-release/haxedoc.xml haxelib-release/run.n: \
$(wildcard haxelib-release/com/dongxiguo/protobuf/compiler/bootstrap/google/protobuf/*.hx haxelib-release/com/dongxiguo/protobuf/compiler/bootstrap/google/protobuf/*/*.hx haxelib-release/com/dongxiguo/protobuf/*/*.hx haxelib-release/com/dongxiguo/protobuf/*.hx)

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

.PHONY: all clean install
