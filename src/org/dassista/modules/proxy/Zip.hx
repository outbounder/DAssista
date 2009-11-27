package org.dassista.modules.proxy;

import org.dassista.api.contexts.neko.MethodContext;

import haxe.rtti.Infos;
import neko.Sys;
import neko.FileSystem;

/**
 * @description module proxy for zip
 */
class Zip implements Infos
{
	public function new() { }
	public static function main() { return new Zip(); }
	
	/**
	 * @src source directory to be zipped
	 * @dest dest directory for the zip
	 * @name name of the zip to be produced
	 * @return Bool
	 */
	public function execute(context:MethodContext):Dynamic
	{
		if (!context.hasArg("src") || !context.hasArg("dest") || !context.hasArg("name"))
			throw "src,dest and name are needed";
			
		var cmd:String = context.getRealPath("_app.org.dassista.tools") +  '\\zip.exe -r -q ' + 
							context.getRealPath(context.getArg("dest")) + "\\" + context.getArg("name") + ' *"';
		var cmdContext:MethodContext = new MethodContext(context);
		cmdContext.setArg("root", context.getArg("src"));
		cmdContext.setArg("cmd", cmd);
		return context.callModuleMethod("org.dassista.modules.proxy.Cmd", "execute", cmdContext).length == 0;
	}
}