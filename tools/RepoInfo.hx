package haxe.org.dassista.tools;

import haxe.org.dassista.IMultiModule;
import haxe.org.dassista.IMultiModuleContext;
import haxe.org.dassista.ModuleException;

import haxe.rtti.Infos;
import neko.FileSystem;
import neko.io.Path;

/**
 * @description module for gathering all available information about given repo
 */
class RepoInfo implements IMultiModule, implements Infos
{
	public function new() { }
	public static function main() { return new RepoInfo(); }
	
	public function execute(context:IMultiModuleContext):Dynamic
	{
		throw new ModuleException("not implemented", this, "execute");
	}
	
	/**
	 * @desc requires noting
	 * @return Bool
	 */
	public function getRootFolderRealPath(context:IMultiModuleContext):Dynamic
	{
		context.output(context.getRealPath(""));
		return true;
	}
	
	/**
	 * @target the target file/directory which class path will be outputed
	 * @return Bool
	 */
	public function getClassPath(context:IMultiModuleContext):Dynamic
	{
		if (!context.has("target"))
			throw new ModuleException("target needed", this, "getClassPath");
		context.output(context.getClassPath(context.get("target")));
		return true;
	}
}