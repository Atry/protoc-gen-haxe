package ;

import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import haxe.unit.TestCase;
import haxe.unit.TestRunner;
import neko.Lib;

import com.dongxiguo.protobuf.binaryFormat.LimitableBytesInput;
import samplePackage.Optional_Builder;
using samplePackage.Optional_Merger;
using samplePackage.Optional_Writer;

/**
 * Tests for protobuf
 * @author AxGord <axgord@gmail.com>
 */

class Main extends TestCase {
	
	static function main() {
		var r = new TestRunner();
		r.add(new Main());
		r.run();
	}
	
	public function testOptionalString():Void {
		
		var b = new Optional_Builder();
		b.tString = 'hello';
		var out = new BytesOutput();
		b.writeTo(out);
		
		var inp = new BytesInput(out.getBytes());
		var rb = new Optional_Builder();
		rb.mergeFrom(new LimitableBytesInput(inp.readAll()));
		
		assertEquals(rb.tString, 'hello');
	}
	
	public function testOptionalEmpty():Void {
		
		var b = new Optional_Builder();
		var out = new BytesOutput();
		b.writeTo(out);
		
		var inp = new BytesInput(out.getBytes());
		var rb = new Optional_Builder();
		rb.mergeFrom(new LimitableBytesInput(inp.readAll()));
		
		assertEquals(rb.tString, null);
		assertEquals(rb.tInt, null);
		assertEquals(rb.tBool, null);
		assertEquals(rb.tFloat, null);
	}
	
	public function testOptionalInt():Void {
		
		var b = new Optional_Builder();
		b.tInt = 3;
		var out = new BytesOutput();
		b.writeTo(out);
		
		var inp = new BytesInput(out.getBytes());
		var rb = new Optional_Builder();
		rb.mergeFrom(new LimitableBytesInput(inp.readAll()));
		
		assertEquals(rb.tInt, 3);
	}
	
	
	public function testOptionalInt0():Void {
		
		var b = new Optional_Builder();
		b.tInt = 0;
		var out = new BytesOutput();
		b.writeTo(out);
		
		var inp = new BytesInput(out.getBytes());
		var rb = new Optional_Builder();
		rb.mergeFrom(new LimitableBytesInput(inp.readAll()));
		
		assertEquals(rb.tInt, 0);
	}
	
	public function testOptionalFloat():Void {
		
		
		var b = new Optional_Builder();
		b.tFloat = 3.654;
		var out = new BytesOutput();
		b.writeTo(out);
		
		var inp = new BytesInput(out.getBytes());
		var rb = new Optional_Builder();
		rb.mergeFrom(new LimitableBytesInput(inp.readAll()));
		
		assertEquals(Math.floor(rb.tFloat*1000), 3654);
	}
	
	public function testOptionalFloat0():Void {
		
		var b = new Optional_Builder();
		b.tFloat = 0;
		var out = new BytesOutput();
		b.writeTo(out);
		
		var inp = new BytesInput(out.getBytes());
		var rb = new Optional_Builder();
		rb.mergeFrom(new LimitableBytesInput(inp.readAll()));
		
		assertEquals(rb.tFloat, 0);
	}
	
	public function testOptionalBool():Void {
		
		var b = new Optional_Builder();
		b.tBool = true;
		var out = new BytesOutput();
		b.writeTo(out);
		
		var inp = new BytesInput(out.getBytes());
		var rb = new Optional_Builder();
		rb.mergeFrom(new LimitableBytesInput(inp.readAll()));
		
		assertTrue(rb.tBool);
	}
	
	public function testOptionalFalse():Void {
		
		var b = new Optional_Builder();
		b.tBool = false;
		var out = new BytesOutput();
		b.writeTo(out);
		
		var inp = new BytesInput(out.getBytes());
		var rb = new Optional_Builder();
		rb.mergeFrom(new LimitableBytesInput(inp.readAll()));
		
		assertFalse(rb.tBool);
	}
	
	
}