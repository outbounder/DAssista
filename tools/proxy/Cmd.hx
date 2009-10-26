package haxe.org.dassista.tools.proxy;

import haxe.org.dassista.IMultiModule;
import haxe.org.dassista.IMultiModuleContext;
import neko.Sys;

class Cmd implements IMultiModule
{
	public function new() { }
	public static function main() { return new Cmd(); }
	
	public function execute(context:IMultiModuleContext):Bool
	{
		var root:String = context.getRealPath(context.get("root"));
		var cmd:String = context.get("cmd");
		var oldCwd:String = Sys.getCwd();
		Sys.setCwd(root);
		var result:Int = Sys.command(cmd);
		context.set("result", result);
		return result == 0;
	}
}