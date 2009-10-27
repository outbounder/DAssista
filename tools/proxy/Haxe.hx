package haxe.org.dassista.tools.proxy;

import haxe.org.dassista.IMultiModule;
import haxe.org.dassista.IMultiModuleContext;

class Haxe implements IMultiModule
{
	public function new() { }
	public static function main() { return new Haxe(); }
	
	public function execute(context:IMultiModuleContext):Bool
	{
		var cmdContext:IMultiModuleContext = context.clone();
		cmdContext.set("root", context.get("root"));
		cmdContext.set("cmd",  "haxe "+context.get("cmd"));
		return context.executeTargetModule("haxe.org.dassista.tools.proxy.Cmd", cmdContext);
	}
	
	public function php(context:IMultiModuleContext):Bool
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
				return context.executeTargetModule("haxe.org.dassista.tools.proxy.Cmd", cmdContext);
			};
		}
		trace("not recognized platform " + context.get("platform"));
		return false;
	}
}