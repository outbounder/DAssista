package haxe.org.dassista.context.ext;

import haxe.org.multicore.IMultiModuleContext;
import neko.FileSystem;
import neko.io.Path;

class ModuleCompiler
{
	public function new()
	{
		
	}
	
	public function compileTarget(target:String, context:IMultiModuleContext):Bool
	{
		if (target.indexOf("*") == target.length - 1)
		{
			// compile all found under target & its subtargets
			return this.compileDir(target.split("*")[0], context);
		}
		else
		{
			// compile exactly target
			return this.compileModule(target, context);
		}
	}
	
	private function compileDir(target:String,context:IMultiModuleContext):Bool
	{
		var dirFullPath:String = context.getRealPath(target);
		
		// clear all compiled modules
		var entries:Array<String> = FileSystem.readDirectory(dirFullPath);
		for (entry in entries)
		{
			if (Path.extension(dirFullPath + entry) == "n")
			{
				FileSystem.deleteFile(dirFullPath + entry);
				continue;
			}
		}
		
		// compile all
		var entries:Array<String> = FileSystem.readDirectory(dirFullPath);
		for (entry in entries)
		{
			if (FileSystem.kind(dirFullPath+entry) == FileKind.kdir)
			{
				if (!this.compileDir(dirFullPath+entry, context))
					return false;
			}
			else
			{
				if (!this.compileModule(dirFullPath+entry, context))
					return false;
			}
		}
		return true;
	}
	
	private function compileModule(target:String, context:IMultiModuleContext):Bool
	{
		var fileFullPath:String = context.getRealPath(target);	
		return context.compileMultiModule(context.getClassPath(fileFullPath));
	}
}