package haxe.org.dassista;

import neko.Lib;

class TestPrc
{
	public function new() { }
	public static function main():Bool
	{
		var cmd:String = "haxe.exe --version";
		var exec:Dynamic = Lib.load("Prc", "exec", 1);
		try
		{
			var v = exec(untyped cmd.__s);
			trace(v);
		}
		catch ( e : Dynamic )
		{
			throw "Process creation failure : " + e;
		}
		
		return true;
	}
}