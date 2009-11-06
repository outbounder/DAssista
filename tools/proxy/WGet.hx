package haxe.org.dassista.tools.proxy;

import haxe.org.dassista.IMultiModule;
import haxe.org.dassista.IMultiModuleContext;
import haxe.org.dassista.ModuleException;
import haxe.rtti.Infos;

import neko.io.Path;

/**
 * @description proxy module for WGet
 */
class WGet implements IMultiModule, implements Infos
{
	public function new() { }
	public static function main() { return new WGet(); }
	
	/**
	 * @root folder upon wget will be invoked
	 * @cmd wget command arguments
	 * @return Bool
	 */
	public function execute(context:IMultiModuleContext):Dynamic
	{
		var cmdContext:IMultiModuleContext = context.clone();
		cmdContext.set("root", context.get("root"));
		cmdContext.set("cmd", "wget " + context.get("cmd"));
		trace("wget " + context.get("cmd"));
		return context.executeTargetModule("haxe.org.dassista.tools.proxy.Cmd", cmdContext) == 0;
	}
	
	/**
	 * @dest directory class path which will be used as destination of the download
	 * @src any url (internet resource)
	 * @name name of the outputfile
	 * @return Bool
	 */
	public function download(context:IMultiModuleContext):Dynamic
	{
		if (!context.has("dest") || !context.has("src") || !context.has("name"))
			throw "dest, src and name are needed";
		var dest:String = context.getRealPath(context.get("dest"));
		context.set("root", "" );
		context.set("cmd", "-x -O "+dest+"\\"+context.get("name")+" "+context.get("src"));
		return this.execute(context);
	}
}