package haxe.org.dassista.tools.proxy;

import haxe.org.dassista.IMultiModule;
import haxe.org.dassista.IMultiModuleContext;
import neko.Sys;
import neko.FileSystem;

class Cmd implements IMultiModule
{
	public function new() { }
	public static function main() { return new Cmd(); }
	
	public function execute(context:IMultiModuleContext):Bool
	{
		var root:String = context.getRealPath(context.get("root"));
		
		if (context.get("exec") != null) // special case for execution of any kind of downloaded classPath like resource
		{
			var oldCwd:String = Sys.getCwd();
			if (!FileSystem.exists(root))
				Sys.command('mkdir "'+root+'"');
			Sys.setCwd(root);
			var result:Int = -1;
			var exec:String = context.getRealPath(context.get("exec"));
			
			// to be changed for unix support
			if (!FileSystem.exists(exec + ".exe"))
			{
				if (FileSystem.exists(exec))
					FileSystem.rename(exec, exec + ".exe");
			}
			result = Sys.command(exec + ".exe"); 
			
			Sys.setCwd(oldCwd);
			return result == 0;
		}
		
		var cmd:String = context.get("cmd");
		var oldCwd:String = Sys.getCwd();
		if (!FileSystem.exists(root))
			Sys.command('mkdir "'+root+'"');
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
		return result == 0;
	}
}