package haxe.org.dassista.tools;

import haxe.org.dassista.IMultiModule;
import haxe.org.dassista.IMultiModuleContext;

class Moduler implements IMultiModule
{
	public function new()
    {
    }
	
	public static function main():Dynamic
	{
		return new Moduler();
	}
	
	public function execute(context:IMultiModuleContext):Bool
	{
		return false;
	}
	
	public function initModule(context:IMultiModuleContext):Bool
	{
		if (context.get("target") == null)
			throw "target required";
			
		// create pdml target dir
		var dirContext:IMultiModuleContext = context.clone();
		dirContext.set("target", context.get("target") + "._pdmls");
		if (!context.callTargetModuleMethod("haxe.org.dassista.tools.proxy.Dir", "create", dirContext))
			return false;
		
		// create module.pdml	
		var copyContext:IMultiModuleContext = context.clone();
		copyContext.set("src", context.getRealPath("haxe.org.dassista.templates._pdmls.module")+".pdml");
		copyContext.set("dest", context.getRealPath(context.get("target") + "._pdmls.module")+".pdml");
		if (!context.executeTargetModule("haxe.org.dassista.tools.proxy.Copy", copyContext))
			return false;
			
		trace("module initiated at " + context.get("target"));
		return true;
	}
}