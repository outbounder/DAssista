package haxe.org.dassista.tools.proxy;

import haxe.org.dassista.IMultiModule;
import haxe.org.dassista.IMultiModuleContext;

import neko.io.Path;

class Wget implements IMultiModule
{
	public function new() { }
	public static function main() { return new Wget(); }
	
	public function execute(context:IMultiModuleContext):Bool
	{
		var cmdContext:IMultiModuleContext = context.clone();
		cmdContext.set("root", context.get("root"));
		cmdContext.set("cmd", "wget " + context.get("cmd"));
		return context.executeTargetModule("haxe.org.dassista.tools.proxy.Cmd", cmdContext);
	}
	
	public function download(context:IMultiModuleContext):Bool
	{
		var dest:String = context.getRealPath(context.get("dest"));
		context.set("root", Path.directory(dest) );
		context.set("cmd", "-O "+Path.withoutDirectory(dest)+" "+context.get("src"));
		return this.execute(context);
	}
}