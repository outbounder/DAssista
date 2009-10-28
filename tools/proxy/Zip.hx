package haxe.org.dassista.tools.proxy;

import haxe.org.dassista.IMultiModule;
import haxe.org.dassista.IMultiModuleContext;
import neko.Sys;
import neko.FileSystem;

class Zip implements IMultiModule
{
	public function new() { }
	public static function main() { return new Zip(); }
	
	public function execute(context:IMultiModuleContext):Dynamic
	{
		var cmdContext:IMultiModuleContext = context.clone();
		cmdContext.set("root", context.get("src"));
		cmdContext.set("cmd", "zip -r -q " + context.getRealPath(context.get("dest"))+"\\"+context.get("name") + " *");
		return context.executeTargetModule("haxe.org.dassista.tools.proxy.Cmd", cmdContext) == 0;
	}
}