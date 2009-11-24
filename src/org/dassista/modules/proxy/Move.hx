package org.dassista.modules.proxy;

import org.dassista.api.contexts.neko.MethodContext;

import haxe.rtti.Infos;
import neko.io.File;
import neko.io.Path;
import neko.FileSystem;

class Move implements Infos
{
	public function new() { }
	public static function main() { return new Move(); }
	
	/**
	 * @src src class path to be moved to dest
	 * @dest dest class path where src will be moved
	 * @return Bool
	 */
	public function execute(context:MethodContext):Dynamic
	{
		if (!context.hasArg("src") || !context.hasArg("dest"))
			throw "target and dest are needed";
		if (FileSystem.isDirectory(context.getRealPath(context.getArg("src"))))
			throw "not implemented";
		var srcFileRealPath:String = context.getRealPath(context.getArg("src"));
		var destFileRealPath:String = context.getRealPath(context.getArg("dest")) + "//" + Path.withoutDirectory(srcFileRealPath);
		File.copy(srcFileRealPath, destFileRealPath);
		FileSystem.deleteFile(srcFileRealPath);
		return true;
	}	
}