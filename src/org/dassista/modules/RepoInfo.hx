package org.dassista.modules;

import org.dassista.api.contexts.neko.MethodContext;

import haxe.rtti.Infos;
import neko.FileSystem;
import neko.io.Path;

/**
 * @description module for gathering all available information about given repo
 */
class RepoInfo implements Infos
{
	private var stack:Array<String>;
	
	public function new() { this.stack = new Array(); }
	public static function main() { return new RepoInfo(); }
	
	/**
	 * @desc requires noting
	 * @return Bool
	 */
	public function getRootFolderRealPath(context:MethodContext):Dynamic
	{
		context.output(context.getRealPath(""));
		return true;
	}
	
	/**
	 * @target the target file/directory which class path will be outputed
	 * @return Bool
	 */
	public function getClassPath(context:MethodContext):Dynamic
	{
		if (!context.hasArg("target"))
			throw "target needed";
		context.output(context.getClassPath(context.getArg("target")));
		return true;
	}
	
	/**
	 * @target the target file which will be added to stack, and its value will be outputed
	 * @return Bool
	 */
	public function stackPdmlFile(context:MethodContext):Dynamic
	{
		if (!context.hasArg("target"))
			throw "target needed";
		
		if (this.getClassPath(context))
		{
			this.stack.push(context.getClassPath(context.getArg("target")));
			return true;
		}
		else
			return false;
	}
	
	/**
	 * @desc requires nothing
	 * @return Bool
	 */
	public function getPdmlStackList(context:MethodContext):Dynamic
	{
		for (pdmlFile in this.stack)
		{
			context.output(pdmlFile);
		}
	}
}