package haxe.org.dassista.tools.proxy;

import haxe.org.dassista.IMultiModule;
import haxe.org.dassista.IMultiModuleContext;
import haxe.rtti.Infos;
import neko.Sys;
import neko.FileSystem;

/**
 * @description module proxy for zip
 */
class Zip implements IMultiModule, implements Infos
{
	public function new() { }
	public static function main() { return new Zip(); }
	
	/**
	 * @src source directory to be zipped
	 * @dest dest directory for the zip
	 * @name name of the zip to be produced
	 * @return Bool
	 */
	public function execute(context:IMultiModuleContext):Dynamic
	{
		var cmdContext:IMultiModuleContext = context.clone();
		cmdContext.set("root", context.get("src"));
		cmdContext.set("cmd", "zip -r -q " + context.getRealPath(context.get("dest"))+"\\"+context.get("name") + " *");
		return context.executeTargetModule("haxe.org.dassista.tools.proxy.Cmd", cmdContext) == 0;
	}
}