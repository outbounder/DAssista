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
class RepoInfo implements IMultiModule, implements Infos
{
	public function new() { }
	public static function main() { return new RepoInfo(); }
	
	public function execute(context:IMultiModuleContext):Dynamic
	{
		throw new ModuleException("not implemented", this, "execute");
	}
	
	/**
	 * @params requires noting
	 * @return String
	 */
	public function getRootFolderRealPath(context:IMultiModuleContext):Dynamic
	{
		context.output(context.getRealPath(""));
		return true;
	}
}