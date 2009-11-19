package haxe.org.dassista;

import neko.Lib;
import prc.Prc;

class TestPrc
{
	public function new() { }
	public static function main():Void
	{
		var cmd:String = "haxe -lib prc -neko d:\\pd-repo\\haxe\\org\\dassista\\TestPrc.n -main haxe.org.dassista.TestPrc -D use_rtti_doc";
		var prc:Prc = new Prc();
		trace(prc.exec(cmd));
	}
}