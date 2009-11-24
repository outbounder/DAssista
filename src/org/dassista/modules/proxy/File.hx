package org.dassista.modules.proxy;

import org.dassista.api.contexts.neko.MethodContext;

import haxe.rtti.Infos;
import neko.io.FileOutput;

class File implements Infos
{
	public function new() { }
	public static function main() { return new File(); }
	
	/**
	 * @desc creates a file with provided content, if not creates empty file
	 * @content to be put in the file
	 * @root folder upon which current file will be created
	 * @name name of the file with extension to be created
	 * @return
	 */
	public function createFile(context:MethodContext):Bool
	{
		context.setArg('dontclose', context.hasArg("content"));
		if (!this.createEmptyFile(context))
			return false;
		if (context.hasArg("content"))
		{
			var output:FileOutput = context.getArg('output');
			output.writeString(context.getArg('content'));
			output.close();
		}
		return true;
	}
	
	/**
	 * @desc creates empty file
	 * @root folder upon which current file will be created
	 * @name name of the file with extension to be created
	 * @return Bool
	 */
	public function createEmptyFile(context:MethodContext):Bool
	{
		if (!context.hasArg("root") || !context.hasArg("name"))
			throw "root and name are needed";
		var root:String = context.getRealPath(context.getArg("root"));
		var name:String = context.getArg("name");
		
		var output:FileOutput = neko.io.File.write(root + "//" + name, true);
		if (context.getArg('dontclose') != true)
			output.close();
		else
			context.setArg('output', output);
		return true;
	}
	
	/**
	 * @src dir where file resides
	 * @name name of the file with extension
	 * @newname new name of the file with extension
	 * @return Bool
	 */
	public function renameFile(context:MethodContext):Bool
	{
		if (!context.hasArg("src") || !context.hasArg("name") || !context.hasArg("newname"))
			throw "src, name & newname are needed";
		var src:String = context.getRealPath(context.getArg("src"))+"//";
		var name:String = context.getArg("name");
		var newname:String = context.getArg("newname");

		neko.FileSystem.rename(src + name, src + newname);
		return true;
	}
	
	/**
	 * @src dir where file resides
	 * @name name of the file with extension to be deleted
	 * @return Bool
	 */
	public function deleteFile(context:MethodContext):Bool
	{
		if (!context.hasArg("src") || !context.hasArg("name"))
			throw "src and name are needed";
		var src:String = context.getRealPath(context.getArg("src"))+"//";
		var name:String = context.getArg("name");

		if(neko.FileSystem.exists(src + name))
			neko.FileSystem.deleteFile(src + name);
		return true;
	}
}