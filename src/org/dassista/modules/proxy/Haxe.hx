package org.dassista.modules.proxy;

import org.dassista.api.contexts.neko.MethodContext;

import neko.io.Path;
import neko.FileSystem;

/**
 * @author Boris Filipov
 * @version 0.1
 * @name haxe.org.dassista.tools.proxy.Haxe
 * @description proxy for haxe compiler compatible to DAssistA class path, works only within the swarm
 */
class Haxe implements haxe.rtti.Infos
{
	public function new() { }
	public static function main() { return new Haxe(); }
	
	/**
	 * @return Bool
	 * @src source code base dir
	 * @main the main entry point for as3 code generation
	 * @dest destination as3 code base dir
	 */
	public function as3(context:MethodContext):Bool
	{
		if (!context.hasArg("src") || !context.hasArg("main") || !context.hasArg("dest"))
			throw "target,src,main needed";
			
		var main:String = context.getArg("main");
		var src:String = context.getArg("src");
		var dest:String = context.getArg("dest");
		var useRttiInfos:String = context.hasArg("usertti")?" -D use_rtti_doc":"";
		var sourceEntry:String = context.getRealPath(src) + "\\" + main.split(".").join("\\");
		
		var cmdContext:MethodContext = new MethodContext(context);
		cmdContext.setArg("target", dest);
		if (!cmdContext.callModuleMethod("org.dassista.modules.proxy.Dir", "create", cmdContext))
			throw "can not create dir " + dest;
		
		var cmd:String = "haxe -as3 " +context.getRealPath(dest) + " " + main + useRttiInfos;
		
		var cmdContext:MethodContext = new MethodContext(context);
		cmdContext.setArg("root", context.getRealPath(src));
		cmdContext.setArg("cmd",  cmd);
		var result:String = context.callModuleMethod("org.dassista.modules.proxy.Cmd", "execute", cmdContext);
		
		return result.length == 0;
	}
	
	/**
	 * @return Bool
	 * @throws ModuleException
	 * @target class path to entry (dir or file without hx extension)
	 */
	public function neko(context:MethodContext):Bool
	{
		if (!context.hasArg("src") || !context.hasArg("main") || !context.hasArg("dest"))
			throw "target,src,main needed";

		context.setArg("platform", "neko");
		var main:String = context.getArg("main");
		var src:String = context.getArg("src");
		var sourceEntry:String = context.getRealPath(src) + "\\" + main.split(".").join("\\");
		if (FileSystem.exists(sourceEntry+".hx")) // check such file exists
			return this.haxe(context);
		else
		if(FileSystem.isDirectory(sourceEntry))
			return this.haxeThisDir(context);
		else
			throw "can not compile to neko "+context;
	}
	
	/**
	 * @return Bool
	 * @throws ModuleException
	 * @target class path to main for php project
	 * @dest class path to destination folder
	 */
	public function php(context:MethodContext):Bool
	{
		if (!context.hasArg("target") || !context.hasArg("dest"))
			throw "target and dest needed";
			
		context.setArg("platform", "php");
		return this.haxe(context);
	}
	
	private function haxeThisDir(context:MethodContext):Bool
	{
		var sourceFiles:Array < String > = context.getRealPathTreeList(context.getArg("src") + "." + context.getArg("main"), "hx");
		var src:String = context.getRealPath(context.getArg("src"));
		var dest:String = context.getRealPath(context.getArg("dest"));
		
		for(source in sourceFiles)
		{
			var binaryDest:String = Path.withoutExtension(source).split(src).join(dest);
			var main:String = context.getClassPath(Path.withoutExtension(source.split(src)[1]));
			context.setArg("dest", binaryDest);
			context.setArg("main", main);
			// context.output("compiling source:" + source + " -> binaryDest:" + binaryDest + " | main:" + main + " src:" + src);
			if(!this.haxe(context))
			{
				context.output("failed "+main+" at "+src);
				return false;
			}
		}
		return true;
	}
	
	/**
	 * @platform php|neko
	 * @dest used in php to define the destination folder
	 * @target used to define where is the entry point upon which a compile will be made
	 * @usertti optional neko argument for specifing compilation with rtti included
	 * @return Bool
	 */
	private function haxe(context:MethodContext):Bool
	{
		switch(context.getArg("platform"))
		{
			case "php":
			{
				var dest:String = context.getRealPath(context.getArg("dest"));
				
				var cmdContext:MethodContext = new MethodContext(context);
				cmdContext.setArg("target", dest);
				if (!context.callModuleMethod("org.dassista.modules.proxy.Dir", "create", cmdContext))
					throw "can not create target dir " + dest;
					
				cmdContext = new MethodContext(context);
				if (context.hasArg("root"))
					cmdContext.setArg("root", context.getRealPath(context.getArg("root")));
				else
					cmdContext.setArg("root", "");
					
				cmdContext.setArg("cmd",  "haxe -php " + dest + " --php-front " + context.getArg("front") + " -main " + context.getArg("target"));
				var result:String = context.callModuleMethod("haxe.org.dassista.tools.proxy.Cmd", "execute", cmdContext);
				return result.length == 0;
			};
			case "neko":
			{
				var main:String = context.getArg("main");

				var useRttiInfos:String = context.hasArg("usertti")?" -D use_rtti_doc":"";
				var destTarget:String = context.getRealPath(context.getArg("dest")) + ".n";
				var cmd:String = "haxe -neko " + destTarget + " -main " + context.getArg("main") + useRttiInfos;
				
				var cmdContext:MethodContext = new MethodContext(context);
				cmdContext.setArg("target", Path.directory(destTarget));
				if (!context.callModuleMethod("org.dassista.modules.proxy.Dir", "create", cmdContext))
					throw "can not create target dir " + Path.directory(destTarget);
				
				cmdContext = new MethodContext(context);
				cmdContext.setArg("root", context.getRealPath(context.getArg("src")));
				cmdContext.setArg("cmd",  cmd);
				var result:String = context.callModuleMethod("org.dassista.modules.proxy.Cmd", "execute", cmdContext);
				return result.length == 0;
			};
		}
		
		throw "not recognized platform " + context.getArg("platform");
	}
}