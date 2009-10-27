package haxe.org.dassista.tools.proxy;

import haxe.org.dassista.IMultiModule;
import haxe.org.dassista.IMultiModuleContext;
import neko.Sys;
import neko.FileSystem;

class Dir implements IMultiModule
{
	public function new() { }
	public static function main() { return new Dir(); }
	
	public function execute(context:IMultiModuleContext):Bool
	{
		return false;
	}
	
	public function create(context:IMultiModuleContext):Bool
	{
		if (context.get("target") == null)
			throw "target is required";
			
		var root:String = context.getRealPath(context.get("target"));
		if (!FileSystem.exists(root))
			Sys.command('mkdir "' + root + '"');
		return true;
	}
}