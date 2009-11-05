package haxe.org.dassista.tools.proxy;

import haxe.org.dassista.IMultiModule;
import haxe.org.dassista.IMultiModuleContext;
import haxe.org.dassista.ModuleException;
import haxe.rtti.Infos;

import neko.io.File;
import neko.io.Path;
import neko.FileSystem;

class Move implements IMultiModule, implements Infos
{
	public function new() { }
	public static function main() { return new Move(); }
	
	/**
	 * @src src class path to be moved to dest
	 * @dest dest class path where src will be moved
	 * @return Bool
	 */
	public function execute(context:IMultiModuleContext):Dynamic
	{
		if (!context.has("src") || !context.has("dest"))
			throw "target and dest are needed";
		if (FileSystem.isDirectory(context.getRealPath(context.get("src"))))
			throw "not implemented";
		var srcFileRealPath:String = context.getRealPath(context.get("src"));
		var destFileRealPath:String = context.getRealPath(context.get("dest")) + "//" + Path.withoutDirectory(srcFileRealPath);
		File.copy(srcFileRealPath, destFileRealPath);
		FileSystem.deleteFile(srcFileRealPath);
		return true;
	}	
}