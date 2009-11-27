package org.dassista.modules.proxy;

import org.dassista.api.contexts.neko.MethodContext;
import haxe.rtti.Infos;

/**
 * @desc module proxy for svn client
 */
class Svn implements Infos
{
	public function new() { }
	public static function main() { return new Svn(); }
	
	/**
	 * @repo svn path to repository to be checked out
	 * @dest destination class path where the repo will be checked out
	 * @return Bool
	 */
	public function checkout(context:MethodContext):Bool
	{
		if (!context.hasArg("repo") || !context.hasArg("dest"))
			throw "repo & dest are needed";
		var repo:String = context.getArg("repo");
		var dest:String = context.getRealPath(context.getArg("dest"));
		
		var cmd:String = 'cmd.exe /c "svn checkout ' + repo + " " + dest + '"';
		
		var cmdContext:MethodContext = new MethodContext(context);
		cmdContext.setArg("root", "");
		cmdContext.setArg("cmd", cmd);
		if (context.callModuleMethod("org.dassista.modules.proxy.Cmd", "execute", cmdContext).length == 0)
			return true;
		else
			return false;
	}
}