package haxe.org.dassista.tools.proxy;

import haxe.org.dassista.IMultiModule;
import haxe.org.dassista.IMultiModuleContext;
import haxe.rtti.Infos;

class Mxmlc implements IMultiModule, implements Infos
{
	public function new() { }
	public static function main() { return new Mxmlc(); }
	
	/**
	 * @root folder on which git will be executed
	 * @cmd args which will apply to git execution
	 * @return Bool
	 */
	public function execute(context:IMultiModuleContext):Dynamic
	{
		throw "not implemented";
		return false;
	}
	
	/**
	 * @target class path of the application to be compiled
	 * @dest class path where the output will be placed
	 * @return Bool
	 */
	public function compile(context:IMultiModuleContext):Dynamic
	{
		if (!context.has("target") || !context.has("dest"))
			throw "target and dest are needed";
		
		var cmdContext:IMultiModuleContext = context.clone();
		cmdContext.set('root', context.getRealPath(context.get("dest")));
		cmdContext.set("cmd", "amxmlc " + context.getRealPath(context.get('target'))+'.mxml');
		var result:Bool = context.executeTargetModule("haxe.org.dassista.tools.proxy.Cmd", cmdContext) == 0;
		if (result == true)
		{
			var fileContext:IMultiModuleContext = context.clone();
			fileContext.set("src", context.getRealPath(context.get('target')) + ".swf");
			fileContext.set("dest", context.getRealPath(context.get("dest")));
			return context.executeTargetModule("haxe.org.dassista.tools.proxy.Move", fileContext);
		}
		else
			return false;
	}
}