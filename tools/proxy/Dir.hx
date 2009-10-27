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
			
		var target:String = context.getRealPath(context.get("target"));
		if (!FileSystem.exists(target))
		{
			var cmdContext:Dynamic = context.clone();
			cmdContext.set("root", "");
			cmdContext.set("cmd", "mkdir "+target);
			return context.executeTargetModule("haxe.org.dassista.tools.proxy.Cmd", cmdContext);
		}
		return true;
	}
	
	public function clean(context:IMultiModuleContext):Bool
	{
		if (context.get("target") == null)
			throw "target is required";
		var target:String = context.getRealPath(context.get("target"));
		if (FileSystem.exists(target))
		{
			var cmdContext:Dynamic = context.clone();
			cmdContext.set("root", "");
			cmdContext.set("cmd", "rmdir "+target+" /s /q ");
			return context.executeTargetModule("haxe.org.dassista.tools.proxy.Cmd", cmdContext);
		}
		else
			return true;
	}
}