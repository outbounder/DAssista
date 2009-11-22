package haxe.org.dassista.tools.proxy;

import haxe.org.dassista.IMultiModule;
import haxe.org.dassista.IMultiModuleContext;
import haxe.rtti.Infos;

class Git implements IMultiModule, implements Infos
{
	public function new() { }
	public static function main() { return new Git(); }
	
	/**
	 * @root folder on which git will be executed
	 * @cmd args which will apply to git execution
	 * @return Bool
	 */
	public function execute(context:IMultiModuleContext):Dynamic
	{
		var cmdContext:IMultiModuleContext = context.clone();
		cmdContext.set("root", context.get("target"));
		cmdContext.set("cmd", "git "+context.get("cmd"));
		var result:Dynamic = context.executeTargetModule("haxe.org.dassista.tools.proxy.Cmd", cmdContext);
		return result == 0;
	}
	
	/**
	 * @target openSSL public key full path
	 * @return Bool
	 */
	public function pageant(context:IMultiModuleContext):Dynamic
	{
		var cmdContext:IMultiModuleContext = context.clone();
		cmdContext.set("root", "");
		cmdContext.set("cmd", 'pageant "' + context.get('target') + '"');
		return context.executeTargetModule("haxe.org.dassista.tools.proxy.Cmd", cmdContext) == 0;
	}
}