package haxe.org.dassista.tools.proxy;

import haxe.org.dassista.IMultiModule;
import haxe.org.dassista.IMultiModuleContext;

import neko.io.Path;
import neko.FileSystem;

class Haxe implements IMultiModule
{
	public function new() { }
	public static function main() { return new Haxe(); }
	
	public function execute(context:IMultiModuleContext):Dynamic
	{
		var cmdContext:IMultiModuleContext = context.clone();
		cmdContext.set("root", context.get("root"));
		cmdContext.set("cmd",  "haxe "+context.get("cmd"));
		return context.executeTargetModule("haxe.org.dassista.tools.proxy.Cmd", cmdContext);
	}
	
	public function neko(context:IMultiModuleContext):Dynamic
	{
		context.set("platform", "neko");
		if (context.get("target") == null)
			throw "target needed";
		var target:String = context.get("target");
		if (target.indexOf("*") == -1)
		{
			return this.haxe(context);
		}
		else
		{
			context.set("target", target.split("*")[0]);
			return this.haxeThisDir(context);
		}
	}
	
	public function php(context:IMultiModuleContext):Dynamic
	{
		context.set("platform", "php");
		return this.haxe(context);
	}
	
	private function haxeThisDir(context:IMultiModuleContext):Dynamic
	{
		var target:String = context.get("target");
		var dirFullPath:String = context.getRealPath(target);
		
		// compile all
		var entries:Array<String> = FileSystem.readDirectory(dirFullPath);
		for (entry in entries)
		{
			if (FileSystem.kind(dirFullPath+entry) == FileKind.kdir)
			{
				context.set("target", target + entry + ".");
				if (!this.haxeThisDir(context))
					return false;
			}
			else if(Path.extension(entry) == "hx")
			{
				context.set("target", target + Path.withoutExtension(entry));
				if (!this.haxe(context))
					return false;
			}
		}
		return true;
	}
	
	private function haxe(context:IMultiModuleContext):Dynamic
	{
		var cmdContext:IMultiModuleContext = context.clone();
		switch(context.get("platform"))
		{
			case "php":
			{
				var target:String = context.getRealPath(context.get("target"));
				// create the target directory
				var dirContext:IMultiModuleContext = context.clone();
				dirContext.set("target", target);
				if (!context.callTargetModuleMethod("haxe.org.dassista.tools.proxy.Dir", "create", dirContext))
					return false;
				
				cmdContext.set("root", "");
				cmdContext.set("cmd",  "haxe -php " + target + " --php-front " + context.get("front") + " -main " + context.get("root") + "." + context.get("main"));
				var result:Dynamic = context.executeTargetModule("haxe.org.dassista.tools.proxy.Cmd", cmdContext);
				return result == 0;
			};
			case "neko":
			{
				var target:String = context.get("target");
				var moduleDir:String = context.getRealPath(Path.withoutExtension(target)); // only rootFolder + the directory of the module 
				var moduleName:String = Path.extension(target); // only module name
		
				cmdContext.set("root", "");
				cmdContext.set("cmd",  "haxe  -neko " + moduleDir + "\\" + moduleName + ".n -main " + target);
				var result:Dynamic = context.executeTargetModule("haxe.org.dassista.tools.proxy.Cmd", cmdContext);
				return result == 0;
			};
		}
		trace("not recognized platform " + context.get("platform"));
		return false;
	}
}