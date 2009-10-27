package haxe.org.dassista.tools.proxy;

import haxe.org.dassista.IMultiModule;
import haxe.org.dassista.IMultiModuleContext;

import neko.io.File;
import neko.FileSystem;

class Copy implements IMultiModule
{
	public function new() { }
	public static function main() { return new Copy(); }
	
	public function execute(context:IMultiModuleContext):Dynamic
	{
		if (context.get("src") == null || context.get("dest") == null)
			throw "src & dest are required";
		
		// conversions
		var src:String = context.getRealPath(context.get("src"));
		var dest:String = context.getRealPath(context.get("dest"));
		
		if (!FileSystem.exists(src))
			throw "src does not exists : " + src;
		
		if (src.indexOf("*") != -1 || FileSystem.isDirectory(src))
		{
			var excludes:String = "";
			if (context.get("exclude") != null)
				excludes += "/XD " + context.get("exclude");
			if (context.get("excludeFiles") != null)
				excludes += "/XF " + context.get("excludeFiles")+" ";
			if (context.get("excludeDirs") != null)
				excludes += "/XD " + context.get("excludeDirs")+" ";
			
			// if name presented then it will be appened. hopefully this should be named something else
			if (context.get("name") == null)
			{
				var cmdContext:IMultiModuleContext = context.clone();
				cmdContext.set("root", "");
				cmdContext.set("cmd", "robocopy " + src + " " + dest+" "+excludes+" /e /NFL /NDL /NJH /NJS");
				var result:Dynamic = context.executeTargetModule("haxe.org.dassista.tools.proxy.Cmd", cmdContext);
				return result == 1;
			}
			else
			{
				var files:String = context.get("name");
				var cmdContext:IMultiModuleContext = context.clone();
				cmdContext.set("root", "");
				cmdContext.set("cmd", "robocopy " + src + " " + dest+" "+files+" "+excludes+" /NFL /NDL /NJH /NJS");
				var result:Dynamic = context.executeTargetModule("haxe.org.dassista.tools.proxy.Cmd", cmdContext);
				return result == 1;
			}
		}
		else
		{
			// if name presented then it will be appened. hopefully this should be named something else
			if (context.get("name") != null)
			{
				src = src + "//" + context.get("name");
				dest = dest + "//" + context.get("name");
			}
		
			var dirContext:IMultiModuleContext = context.clone();
			dirContext.set("target", dest);
			if (!context.callTargetModuleMethod("haxe.org.dassista.tools.proxy.Dir", "create", dirContext))
				return false;
			File.copy(src, dest);
			return true;
		}
	}
}