package haxe.org.dassista.tools.proxy;

import haxe.org.dassista.IMultiModule;
import haxe.org.dassista.IMultiModuleContext;
import haxe.org.dassista.ModuleException;

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
class Dir implements IMultiModule, implements Infos
{
	public function new() { }
	public static function main() { return new Dir(); }
	
	public function execute(context:IMultiModuleContext):Dynamic
	{
		return false;
	}
	
	/**
	 * @target class path which will be created fully
	 * @return Bool
	 */
	public function create(context:IMultiModuleContext):Dynamic
	{
		if (context.get("target") == null)
			throw new ModuleException("target is required for create", this, "create");
			
		var target:String = context.getRealPath(context.get("target"));
		if (!FileSystem.exists(target))
		{
			var cmdContext:Dynamic = context.clone();
			cmdContext.set("root", "");
			cmdContext.set("cmd", 'mkdir '+target);
			return context.executeTargetModule("haxe.org.dassista.tools.proxy.Cmd", cmdContext) == 0;
		}
		
		return true;
	}
	
	/**
	 * @desc Deletes all that is found at the provided target including itself
	 * @target class path which will be cleaned, leaving the class path empty
	 * @return Bool
	 */
	public function clean(context:IMultiModuleContext):Dynamic
	{
		if (context.get("target") == null)
			throw new ModuleException("target is required for clean", this, "clean");
		var target:String = context.getRealPath(context.get("target"));
		if (FileSystem.exists(target))
		{
			var cmdContext:Dynamic = context.clone();
			cmdContext.set("root", "");
			cmdContext.set("cmd", 'rmdir /s /q '+target);
			var result:Dynamic = context.executeTargetModule("haxe.org.dassista.tools.proxy.Cmd", cmdContext);
			return result == 0;
		}
		return true;
	}
}