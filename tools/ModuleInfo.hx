package haxe.org.dassista.tools;

import haxe.org.dassista.IMultiModule;
import haxe.org.dassista.IMultiModuleContext;
import haxe.org.dassista.ModuleException;

import haxe.rtti.Infos;
import neko.FileSystem;
import neko.io.Path;

/**
 * @description module for gathering all available information about given module
 */
class ModuleInfo implements IMultiModule, implements Infos
{
	public function new() { }
	public static function main() { return new ModuleInfo(); }
	
	/**
	 * @target directory or source file class path
	 * @return Bool
	 */
	public function execute(context:IMultiModuleContext):Dynamic
	{
		if (!context.has("target"))
			throw new ModuleException("target needed", this, "execute");
			
		var target:String = context.get("target");
		if (FileSystem.exists(context.getRealPath(target)))
		{
			// target is existing directory
			return this.infoThisDir(context);
		}
		if (FileSystem.exists(context.getRealPath(target) + ".hx"))
		{
			return this.info(context);
		}
		throw new ModuleException("target is not either source .hx or directory", this, "execute");
		return false;
	}
	
	/**
	 * @target directory class path
	 * @return Bool
	 */
	public function infoThisDir(context:IMultiModuleContext):Dynamic
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
				if (!this.infoThisDir(context))
					return false;
			}
			else if(Path.extension(entry) == "hx")
			{
				context.set("target", target + "." + Path.withoutExtension(entry));
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
	public function info(context:IMultiModuleContext):Dynamic
	{
		var target:IMultiModule = context.createTargetModule(context.get("target"));
		var method:Dynamic = context.get("m");
		context.output("<module name='"+context.get("target")+"'>\n"+context.describe(target,method)+"\n</module>");
		return true;
	}
	
	/**
	 * @target module class path upon which all public methods will be returned
	 * @return Bool
	 */
	public function listMethods(context:IMultiModuleContext):Dynamic
	{
		var target:IMultiModule = context.createTargetModule(context.get("target"));
		
		for (field in Type.getInstanceFields(Type.getClass(target)))
		{
			if (Reflect.isFunction(Reflect.field(target, field)))
			{
				context.output("<method classname='"+context.get("target")+"'>" + field + "</method>");
			}
		}
		return true;
	}
}