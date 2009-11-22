package org.dassista.modules;

import org.dassista.api.contexts.neko.MethodContext;

import haxe.rtti.Infos;
import neko.FileSystem;
import neko.io.Path;

/**
 * @description module for gathering all available information about given module
 */
class ModuleInfo  implements Infos
{
	public function new() { }
	public static function main() { return new ModuleInfo(); }
	
	/**
	 * @target directory or source file class path
	 * @return Bool
	 */
	public function execute(context:MethodContext):Dynamic
	{
		if (!context.hasArg("target"))
			throw "target needed";
			
		var target:String = context.getArg("target");
		if (FileSystem.exists(context.getRealPath(target)))
		{
			// target is existing directory
			return this.infoThisDir(context);
		}
		if (FileSystem.exists(context.getRealPath(target) + ".hx"))
		{
			return this.info(context);
		}
		throw "target is not either source .hx or directory";
	}
	
	/**
	 * @target directory class path
	 * @return Bool
	 */
	public function infoThisDir(context:MethodContext):Dynamic
	{
		var target:String = context.getArg("target");
		var dirFullPath:String = context.getRealPath(target);
		
		// compile all
		var entries:Array<String> = FileSystem.readDirectory(dirFullPath);
		for (entry in entries)
		{
			if (FileSystem.kind(dirFullPath+"\\"+entry) == FileKind.kdir)
			{
				context.setArg("target", target + "." + entry);
				if (!this.infoThisDir(context))
					return false;
			}
			else if(Path.extension(entry) == "hx")
			{
				context.setArg("target", target + "." + Path.withoutExtension(entry));
				if (!this.info(context))
					return false;
			}
		}
		
		return true;
	}
	
	/**
	 * @target file class path
	 * @return Bool
	 */
	public function info(context:MethodContext):Dynamic
	{
		var target:Dynamic = context.getModule(context.getArg("target"));
		var method:Dynamic;
		if(context.hasArg("m"))
			method = context.getArg("m");
		else
			method = null;
		context.output("<module name='"+context.getArg("target")+"'>\n"+Attributes.of(Type.getClass(target), method).toString()+"\n</module>");
		return true;
	}
	
	/**
	 * @target module class path upon which all public methods will be returned
	 * @return Bool
	 */
	public function listMethods(context:MethodContext):Dynamic
	{
		var target:Dynamic = context.getModule(context.getArg("target"));
		
		for (field in Type.getInstanceFields(Type.getClass(target)))
		{
			if (Reflect.isFunction(Reflect.field(target, field)))
			{
				context.output("<method classname='"+context.getArg("target")+"'>" + field + "</method>");
			}
		}
		return true;
	}
}