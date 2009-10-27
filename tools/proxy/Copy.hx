package haxe.org.dassista.tools.proxy;

import haxe.org.dassista.IMultiModule;
import haxe.org.dassista.IMultiModuleContext;

import neko.io.File;

class Copy implements IMultiModule
{
	public function new() { }
	public static function main() { return new Copy(); }
	
	public function execute(context:IMultiModuleContext):Bool
	{
		if (context.get("src") == null || context.get("dest") == null)
			throw "src & dest are required";
		
		var src:String = context.getRealPath(context.get("src"));
		var dest:String = context.getRealPath(context.get("dest"));
		if (context.get("name") != null)
		{
			src = src + "//" + context.get("name");
			dest = dest + "//" + context.get("name");
		}
		File.copy(src, dest);
		return true;
	}
}