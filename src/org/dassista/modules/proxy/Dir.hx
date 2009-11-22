package org.dassista.modules.proxy;

import org.dassista.api.contexts.neko.MethodContext;

import haxe.rtti.Infos;
import neko.Sys;
import neko.FileSystem;

/**
 * @author Boris Filipov
 * @version 0.1
 * @name haxe.org.dassista.tools.proxy.Dir
 * @description Module for creating & cleaning directories. 
 * @uses haxe.org.dassista.tools.proxy.Cmd
 * @requirements Windows OS(mkdir, rmdir)
 */
class Dir implements Infos
{
	public function new() { }
	public static function main() { return new Dir(); }
	
	/**
	 * @target class path which will be created fully
	 * @return Bool
	 */
	public function create(context:MethodContext):Bool
	{
		if (context.hasArg("target") == null)
			throw "target is required for create";
			
		var target:String = context.getRealPath(context.getArg("target"));
		if (!FileSystem.exists(target))
		{
			var cmdContext:MethodContext = new MethodContext(context);
			cmdContext.setArg("root", "");
			cmdContext.setArg("cmd", 'mkdir '+target);
			return context.callModuleMethod("haxe.org.dassista.tools.proxy.Cmd", "execute", cmdContext).length == 0;
		}
		
		return true;
	}
	
	/**
	 * @desc Deletes all that is found at the provided target including itself
	 * @target class path which will be cleaned, leaving the class path empty
	 * @return Bool
	 */
	public function clean(context:MethodContext):Bool
	{
		if (context.hasArg("target") == null)
			throw "target is required for clean";
		var target:String = context.getRealPath(context.getArg("target"));
		if (FileSystem.exists(target))
		{
			var cmdContext:MethodContext = new MethodContext(context);
			cmdContext.setArg("root", "");
			cmdContext.setArg("cmd", 'rmdir /s /q '+target);
			var result:String = context.callModuleMethod("haxe.org.dassista.tools.proxy.Cmd", "execute", cmdContext);
			return result.length == 0;
		}
		return true;
	}
}