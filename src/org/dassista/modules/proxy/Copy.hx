package org.dassista.modules.proxy;

import org.dassista.api.contexts.neko.MethodContext;
import haxe.rtti.Infos;

import neko.io.File;
import neko.FileSystem;

/**
 * @description proxy module for Copy operations
 */
class Copy implements Infos
{
	public function new() { }
	public static function main() { return new Copy(); }
	
	/**
	 * @src source dir 
	 * @dest dest dir
	 * @name used to define file(s) to be copied
	 * @excludeFiles file names to be excluded
	 * @excludeDirs dir names to be excludded
	 * @return Bool
	 */
	public function execute(context:MethodContext):Dynamic
	{
		if (!context.hasArg("src")|| !context.hasArg("dest"))
			throw "src & dest are required";
		
		// conversions
		var src:String = context.getRealPath(context.getArg("src"));
		var dest:String = context.getRealPath(context.getArg("dest"));
		
		if (!FileSystem.exists(src) || !FileSystem.isDirectory(src))
			throw "src dir does not exists : " + src;
		
		var excludes:String = "";
		if (context.hasArg("exclude"))
			excludes += "/XD " + context.getArg("exclude");
		if (context.hasArg("excludeFiles"))
			excludes += "/XF " + context.getArg("excludeFiles")+" ";
		if (context.hasArg("excludeDirs"))
			excludes += "/XD " + context.getArg("excludeDirs")+" ";
		
		// if name presented then it will be appened. hopefully this should be named something else
		if (!context.hasArg("name"))
		{
			var cmdContext:MethodContext = new MethodContext(context);
			cmdContext.setArg("root", "");
			cmdContext.setArg("cmd", "robocopy " + src + " " + dest + " " + excludes + " /e /NFL /NDL /NJH /NJS");
			var result:String = context.callModuleMethod("org.dassista.modules.proxy.Cmd", "execute", cmdContext);
			return result.length == 2;
		}
		else
		{
			var files:String = context.getArg("name");
			var cmdContext:MethodContext = new MethodContext(context);
			cmdContext.setArg("root", "");
			cmdContext.setArg("cmd", "robocopy " + src + " " + dest+" "+files+" "+excludes+" /NFL /NDL /NJH /NJS");
			var result:String = context.callModuleMethod("org.dassista.modules.proxy.Cmd", "execute", cmdContext);
			return result.length == 2;
		}
	}
}