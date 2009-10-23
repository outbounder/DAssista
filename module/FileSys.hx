package haxe.org.dassista.module;

import haxe.org.multicore.IMultiModule;
import haxe.org.multicore.IMultiModuleContext;
import haxe.xml.Fast;
import neko.Sys;
import neko.io.Path;

class FileSys implements IMultiModule
{
	public static function main():IMultiModule
	{
		return new FileSys();
	}
	
	public function new()
	{
		// TODO this should be made to support not only windows platforms...
		
	}
	
	public function execute(context:IMultiModuleContext):Bool
	{
		var pdml:Fast = context.getPdml();
		if(pdml.has.tools)
			Sys.putEnv("PATH", Sys.getEnv("PATH") + ";" + context.getRealPath(pdml.att.tools)+"\\");
		var target:String = context.getRootFolder();
		if (pdml.has.target)
			target = context.getRealPath(pdml.att.target);
		var args:String = pdml.att.args;
		return this.cmd(target, args);
	}
	
	public function copy(context:IMultiModuleContext):Bool
	{
		var pdml:Fast = context.getPdml();
		
		var src:String = context.getRealPath(pdml.att.src);
		src = StringTools.replace(src, "/", "\\");
		var dest:String = context.getRealPath(pdml.att.dest);
		dest = StringTools.replace(dest, "/", "\\");
		
		var exclude:String = "";
		if (pdml.has.exclude)
		{
			exclude = context.getRealPath(pdml.att.exclude)+".txt";
			exclude = "/EXCLUDE:"+StringTools.replace(exclude, "/" , "\\");
		}
		
		this.cmd(context.getRootFolder(), 'mkdir "' + dest +'"');
		if(Path.extension(src) == "") // copy full directory
			return this.cmd(context.getRootFolder(), 'xcopy "' + src + '" "' + dest + '" /i /e /q /y' + exclude);
		else
			return this.cmd(context.getRootFolder(), 'xcopy "' + src + '" "' + dest + '" /i /q /y' + exclude);
	}
	
	public function clean(context:IMultiModuleContext):Bool
	{
		var pdml:Fast = context.getPdml();
		var fullPath:String = context.getRealPath(pdml.att.target);
		this.cmd(context.getRootFolder(), 'rmdir "' + fullPath + '" /s /q');
		return this.cmd(context.getRootFolder(), 'mkdir "' + fullPath +'"');
	}
	
	private function cmd(root:String, value:String):Bool
	{
		var oldCwd:String = Sys.getCwd();
        Sys.setCwd(root);
        var result:Int = Sys.command(value);
        Sys.setCwd(oldCwd);
		return result  == 0;
	}
}