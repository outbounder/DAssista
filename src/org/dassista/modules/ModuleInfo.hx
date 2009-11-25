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
			return this.infoThisDir(context);
		else
			return this.info(context);
	}
	
	/**
	 * @target directory class path
	 * @return Bool
	 */
	public function infoThisDir(context:MethodContext):Dynamic
	{
		var target:String = context.getArg("target");
		var fullTarget:String = context.getRealPath(target);
		if (fullTarget.lastIndexOf("\\") != fullTarget.length - 1)
			fullTarget += "\\";
			
		// compile all
		var binaryFiles:Array < String > = context.getRealPathTreeList(target, "n");
		for(binaryModule in binaryFiles)
		{
			var targetModule:String = Path.withoutExtension(binaryModule).split(fullTarget)[1].split("\\").join(".");
			context.setArg("target", targetModule);
			this.info(context);
		}
		
		return true;
	}
	
	/**
	 * @target file class path
	 * @return Bool
	 */
	public function info(context:MethodContext):Dynamic
	{
		try
		{
			var target:Dynamic = context.getModule(context.getArg("target"));
			var method:Dynamic;
			if(context.hasArg("m"))
				method = context.getArg("m");
			else
				method = null;
			context.output("<module name='" + context.getArg("target") + "'>\n" + Attributes.of(Type.getClass(target), method).toXml() +"\n</module>");
			return true;
		}
		catch (e:Dynamic)
		{
			throw "can not get info over" + context.getArg("target") + " reason:" + e;
		}
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