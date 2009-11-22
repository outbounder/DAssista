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
	 * @target classname entry point which will be used to generate swc 
	 * @dest class path dir which will be used as destination
	 * @throws ModuleException 
	 */
	public function swc(context:MethodContext):Bool
	{
		if (!context.hasArg("target") || !context.hasArg("dest"))
			throw "target and dest needed";
		var target:String = context.getArg("target");
		var dest:String = context.getArg("dest");
		var useRttiInfos:String = context.hasArg("usertti")?"-D use_rtti_doc":"";
		
		context.setArg("target", Path.withoutExtension(dest));
		if (!context.callModuleMethod("org.dassista.modules.proxy.Dir", "create", context))
			throw "can not create dir " + target;
		
		context.setArg("root", "");
		context.setArg("cmd",  "haxe -swf9 " +context.getRealPath(dest) + ".swc " + target + " " +useRttiInfos+" --flash-strict -swf-version 10");
		var result:Dynamic = context.callModuleMethod("org.dassista.modules.proxy.Cmd", "execute", context);
		return result == 0;
	}
	
	/**
	 * @return Bool
	 * @target classname entry point which will be used to generate as3 code 
	 * @dest class path dir which will be used as destination
	 */
	public function as3(context:MethodContext):Bool
	{
		if (!context.hasArg("target") || !context.hasArg("dest"))
			throw "target and dest needed";
			
		var target:String = context.getArg("target");
		var dest:String = context.getArg("dest");
		var useRttiInfos:String = context.hasArg("usertti")?" -D use_rtti_doc":"";
		var cmdContext:MethodContext = new MethodContext(context);
		cmdContext.setArg("target", dest);
		if (!cmdContext.callModuleMethod("org.dassista.modules.proxy.Dir", "create", context))
			throw "can not create dir " + target;
		
		cmdContext.setArg("root", "");
		cmdContext.setArg("cmd",  "haxe -as3 " +context.getRealPath(dest) + " " + target + useRttiInfos);
		var result:Dynamic = context.callModuleMethod("org.dassista.modules.proxy.Cmd", "execute", context);
		return result == 0;
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
		var sourceEntry:String = context.getRealPath(src)+"\\"+main.split(".").join("\\");
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
		var sourceFiles:Array<String> = context.getRealPathTreeList(context.getArg("src")+"."+context.getArg("main"),"hx");
		var dest:String = context.getRealPath(context.getArg("dest"));
		var src:String = context.getRealPath(context.getArg("src"));
		for(source in sourceFiles)
		{
			var dest:String = source.split(src).join(dest);
			var main:String = context.getClassPath(Path.withoutExtension(source.split(src)[1]));
			context.setArg("dest", dest);
			context.setArg("main", main);
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
				var result:Dynamic = context.callModuleMethod("haxe.org.dassista.tools.proxy.Cmd", "execute", cmdContext);
				return result.length == 0;
			};
			case "neko":
			{

				var target:String = context.getArg("target");
				var useRttiInfos:String = context.hasArg("usertti")?" -D use_rtti_doc":"";
				var cmdContext:MethodContext = new MethodContext(context);
				cmdContext.setArg("root", context.getRealPath(context.getArg("src")));
				var cmd:String = "haxe -neko " + context.getRealPath(context.getArg("dest")) + ".n -main " + context.getArg("main") + useRttiInfos;
				cmdContext.setArg("cmd",  cmd);
				var result:Dynamic = context.callModuleMethod("org.dassista.modules.proxy.Cmd", "execute", cmdContext);
				return result.length == 0;
			};
		}
		
		throw "not recognized platform " + context.getArg("platform");
	}
}