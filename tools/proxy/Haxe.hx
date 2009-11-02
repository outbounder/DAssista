package haxe.org.dassista.tools.proxy;

import haxe.org.dassista.IMultiModule;
import haxe.org.dassista.IMultiModuleContext;
import haxe.org.dassista.ModuleException;

import neko.io.Path;
import neko.FileSystem;

/**
 * @author Boris Filipov
 * @version 0.1
 * @name haxe.org.dassista.tools.proxy.Haxe
 * @description proxy for haxe compiler compatible to DAssistA class path, works only within the swarm
 */
class Haxe implements IMultiModule, implements haxe.rtti.Infos
{
	public function new() { }
	public static function main() { return new Haxe(); }
	
	/**
	 * @return Bool
	 * @throws ModuleException
	 * @root class path to root entry
	 * @cmd haxe command arguments
	 */
	public function execute(context:IMultiModuleContext):Dynamic
	{
		if (!context.has("root") || !context.has("cmd"))
			throw new ModuleException("root and cmd needed", this, "execute");
			
		var cmdContext:IMultiModuleContext = context.clone();
		cmdContext.set("root", context.get("root"));
		cmdContext.set("cmd",  "haxe "+context.get("cmd"));
		return context.executeTargetModule("haxe.org.dassista.tools.proxy.Cmd", cmdContext);
	}
	
	/**
	 * @return Bool
	 * @target classname entry point which will be used to generate swc 
	 * @dest class path dir which will be used as destination
	 * @throws ModuleException 
	 */
	public function swc(context:IMultiModuleContext):Dynamic
	{
		if (!context.has("target") || !context.has("dest"))
			throw new ModuleException("target and dest needed", this, "swc");
		var target:String = context.get("target");
		var dest:String = context.get("dest");
		var useRttiInfos:String = context.has("usertti")?"-D use_rtti_doc":"";
		
		var dirContext:IMultiModuleContext = context.clone();
		dirContext.set("target", Path.withoutExtension(dest));
		if (!context.callTargetModuleMethod("haxe.org.dassista.tools.proxy.Dir", "create", dirContext))
			throw new ModuleException("can not create dir " + target, this, "as3");
		
		var cmdContext:IMultiModuleContext = context.clone();
		cmdContext.set("root", "");
		cmdContext.set("cmd",  "haxe -swf9 " +context.getRealPath(dest) + ".swc " + target + " " +useRttiInfos+" --flash-strict -swf-version 10");
		var result:Dynamic = context.executeTargetModule("haxe.org.dassista.tools.proxy.Cmd", cmdContext);
		return result == 0;
	}
	
	/**
	 * @return Bool
	 * @target classname entry point which will be used to generate as3 code 
	 * @dest class path dir which will be used as destination
	 * @throws ModuleException 
	 */
	public function as3(context:IMultiModuleContext):Dynamic
	{
		if (!context.has("target") || !context.has("dest"))
			throw new ModuleException("target and dest needed", this, "as3");
		var target:String = context.get("target");
		var dest:String = context.get("dest");
		var useRttiInfos:String = context.has("usertti")?"-D use_rtti_doc":"";
		
		var dirContext:IMultiModuleContext = context.clone();
		dirContext.set("target", dest);
		if (!context.callTargetModuleMethod("haxe.org.dassista.tools.proxy.Dir", "create", dirContext))
			throw new ModuleException("can not create dir " + target, this, "as3");
		
		var cmdContext:IMultiModuleContext = context.clone();
		cmdContext.set("root", "");
		cmdContext.set("cmd",  "haxe  -as3 " +context.getRealPath(dest) + " " + target + " " +useRttiInfos);
		var result:Dynamic = context.executeTargetModule("haxe.org.dassista.tools.proxy.Cmd", cmdContext);
		return result == 0;
	}
	
	/**
	 * @return Bool
	 * @throws ModuleException
	 * @target class path to entry (dir or file without hx extension)
	 */
	public function neko(context:IMultiModuleContext):Dynamic
	{
		if (!context.has("target"))
			throw new ModuleException("target needed", this, "neko");

		context.set("platform", "neko");
		var target:String = context.get("target");
		if (FileSystem.exists(context.getRealPath(context.get("target"))+".hx")) // check such file exists
		{
			return this.haxe(context);
		}
		else
		{
			context.set("target", target); // execute as target dir
			return this.haxeThisDir(context);
		}
	}
	
	/**
	 * @return Bool
	 * @throws ModuleException
	 * @target class path to main for php project
	 * @dest class path to destination folder
	 */
	public function php(context:IMultiModuleContext):Dynamic
	{
		if (!context.has("target") || !context.has("dest"))
			throw new ModuleException("target and dest needed", this, "php");
			
		context.set("platform", "php");
		return this.haxe(context);
	}
	
	private function haxeThisDir(context:IMultiModuleContext):Dynamic
	{
		var target:String = context.get("target");
		var dirFullPath:String = context.getRealPath(target);
		
		// compile all
		var entries:Array<String> = FileSystem.readDirectory(dirFullPath);
		for (entry in entries)
		{
			if (FileSystem.kind(dirFullPath+"\\"+entry) == FileKind.kdir)
			{
				context.set("target", target + "." + entry);
				if (!this.haxeThisDir(context))
					return false;
			}
			else if(Path.extension(entry) == "hx")
			{
				context.set("target", target + "." + Path.withoutExtension(entry));
				if (!this.haxe(context))
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
	private function haxe(context:IMultiModuleContext):Dynamic
	{
		var cmdContext:IMultiModuleContext = context.clone();
		switch(context.get("platform"))
		{
			case "php":
			{
				var dest:String = context.getRealPath(context.get("dest"));
				// create the target directory
				var dirContext:IMultiModuleContext = context.clone();
				dirContext.set("target", dest);
				if (!context.callTargetModuleMethod("haxe.org.dassista.tools.proxy.Dir", "create", dirContext))
					throw new ModuleException("can not create target dir " + dest, this, "haxe");
				
				cmdContext.set("root", "");
				cmdContext.set("cmd",  "haxe -php " + dest + " --php-front " + context.get("front") + " -main " + context.get("target"));
				var result:Dynamic = context.executeTargetModule("haxe.org.dassista.tools.proxy.Cmd", cmdContext);
				return result == 0;
			};
			case "neko":
			{
				var target:String = context.get("target");
				var moduleDir:String = context.getRealPath(Path.withoutExtension(target)); // only rootFolder + the directory of the module 
				var moduleName:String = Path.extension(target); // only module name
				var useRttiInfos:String = context.has("usertti")?"-D use_rtti_doc":"";
				
				cmdContext.set("root", "");
				cmdContext.set("cmd",  "haxe  -neko " + moduleDir + "\\" + moduleName + ".n -main " + target + " " + useRttiInfos);
				var result:Dynamic = context.executeTargetModule("haxe.org.dassista.tools.proxy.Cmd", cmdContext);
				return result == 0;
			};
		}
		
		throw new ModuleException("not recognized platform " + context.get("platform"), this, "haxe");
		return false;
	}
}