package org.dassista.modules.proxy;

import org.dassista.api.contexts.neko.MethodContext;

import haxe.rtti.Infos;
import neko.io.File;
import neko.FileSystem;
/**
 * @description proxy module for Ftp operations
 */
class Ftp implements Infos
{
	public function new() { }
	public static function main() { return new Ftp(); }
	
	
	/**
	 * @return Bool
	 * @user username
	 * @pass password
	 * @host hostname
	 * @dest destination directory within the host
	 * @src source directory to be uploaded recursively
	 */
	public function execute(context:MethodContext):Bool
	{
		if (!context.hasArg("src"))
			throw "src is needed";
		if (!context.hasArg("dest") || !context.hasArg("user") || !context.hasArg("pass") || !context.hasArg("host"))
			throw "dest,user,pass,host are needed";
			
		var src:String = context.getArg("src");
		var dest:String = context.getArg("dest");
		var user:String = context.getArg("user");
		var pass:String = context.getArg("pass");
		var host:String = context.getArg("host");
		
		var cmd:String = context.getRealPath("_app.org.dassista.tools.lftp") + '\\lftp.exe -u ' + user + ',' + pass + ' -e "mirror -R ./ ' + dest + '" ' + host;
		
		var cmdContext:MethodContext = new MethodContext(context);
		cmdContext.setArg("root", src);
		cmdContext.setArg("cmd", cmd);
		trace(src);
		trace(cmd);
		return context.callModuleMethod("org.dassista.modules.proxy.Cmd", "execute", cmdContext).length == 0;
	}
}