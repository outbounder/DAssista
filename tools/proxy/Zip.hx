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
		//zip -r mydir mydir
		var cmdContext:IMultiModuleContext = context.clone();
		cmdContext.set("root", context.get("dest"));
		cmdContext.set("cmd", "zip -r " + context.get("name") + " " + context.getRealPath(context.get("src"))+" -q");
		return context.executeTargetModule("haxe.org.dassista.tools.proxy.Cmd", cmdContext) == 0;
	}
}