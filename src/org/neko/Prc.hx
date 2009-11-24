package org.neko;

class Prc
{
	public function new() { }
	
	public function exec(cmd:String):String
	{
		return neko.Lib.nekoToHaxe(_exec(untyped cmd.__s));
	}
	
	static var _exec = neko.Lib.load("Prc","exec",1);
}