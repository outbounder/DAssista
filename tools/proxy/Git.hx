package haxe.org.dassista.tools.proxy;

import haxe.org.dassista.IMultiModule;
import haxe.org.dassista.IMultiModuleContext;

class Git implements IMultiModule
{
	public function new() { }
	public static function main() { return new Git(); }
	
	public function execute(context:IMultiModuleContext):Bool
	{
		var cmdContext:IMultiModuleContext = context.clone();
		cmdContext.set("root", context.get("target"));
		cmdContext.set("cmd", "git "+context.get("cmd"));
		var result:Bool = context.executeTargetModule("haxe.org.dassista.tools.proxy.Cmd", cmdContext);
		if (!result)
			trace("cmd:" + context.get("cmd") + " target:" + context.get("target"));
		return result;
	}
}