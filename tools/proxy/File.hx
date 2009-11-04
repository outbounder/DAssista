package haxe.org.dassista.tools.proxy;

import haxe.org.dassista.IMultiModule;
import haxe.org.dassista.IMultiModuleContext;
import haxe.org.dassista.ModuleException;
import haxe.rtti.Infos;

import neko.io.FileOutput;

class File implements IMultiModule, implements Infos
{
	public function new() { }
	public static function main() { return new File(); }
	
	public function execute(context:IMultiModuleContext):Dynamic
	{
		throw "not implemented";
		return false;
	}
	
	/**
	 * @desc creates a file with provided content, if not creates empty file
	 * @content to be put in the file
	 * @root folder upon which current file will be created
	 * @name name of the file with extension to be created
	 * @return
	 */
	public function createFile(context:IMultiModuleContext):Dynamic
	{
		context.set('dontclose', context.has("content"));
		if (!this.createEmptyFile(context))
			return false;
		if (context.has("content"))
		{
			var output:FileOutput = context.get('output');
			output.writeString(context.get('content'));
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
	public function createEmptyFile(context:IMultiModuleContext):Dynamic
	{
		if (context.get("root") == null || context.get("name") == null)
			throw new ModuleException("root and name are needed", this, "execute");
		var root:String = context.getRealPath(context.get("root"));
		var name:String = context.get("name");
		
		var output:FileOutput = neko.io.File.write(root + "//" + name, true);
		if (context.get('dontclose') != true)
			output.close();
		else
			context.set('output', output);
		return true;
	}
}