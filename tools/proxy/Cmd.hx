package haxe.org.dassista.tools.proxy;

import haxe.org.dassista.IMultiModule;
import haxe.org.dassista.IMultiModuleContext;
import neko.Sys;
import neko.FileSystem;

class Cmd implements IMultiModule
{
	public function new() { }
	public static function main() { return new Cmd(); }
	
	public function execute(context:IMultiModuleContext):Dynamic
	{
		if (context.get("root") == null || context.get("cmd") == null)
			throw "root and cmd are needed";
		var root:String = context.getRealPath(context.get("root"));
		var cmd:String = context.get("cmd");
		
		var oldCwd:String = Sys.getCwd();
		Sys.setCwd(root); 
		var oldPath:String = Sys.getEnv("PATH");
		var newPath:String  = oldPath + ";" + context.getRealPath("haxe.org.dassista.tools")+"\\"; // to be changed for unix support
		Sys.putEnv("PATH", newPath); // this shouldn't be here.
		var result:Int = Sys.command(cmd);
		Sys.setCwd(oldCwd);
		Sys.putEnv("PATH", oldPath);
		if (result != 0)
			trace("root: " + root + " cmd:" + cmd);
		context.set("result", result);
		return result;
	}
}