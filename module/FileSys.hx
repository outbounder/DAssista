package haxe.org.dassista.module;

import haxe.org.multicore.IMultiModule;
import haxe.org.multicore.IMultiModuleContext;
import haxe.xml.Fast;
import neko.Sys;

class FileSys implements IMultiModule
{
	public static function main():IMultiModule
	{
		return new FileSys();
	}
	
	public function new()
	{
		
	}
	
	public function execute(context:IMultiModuleContext):Bool
	{
		var pdml:Fast = context.get("pdml");
		var target:String = context.getRealPath(context,pdml.att.target);
		var oldCwd:String = Sys.getCwd();
        Sys.setCwd(target);
        var result:Int = Sys.command(pdml.att.cmd);
        Sys.setCwd(oldCwd);
        return result == 0;
	}
	
	public function copy(context:IMultiModuleContext):Bool
	{
		var pdml:Fast = context.get("pdml");
		var destination:String = context.getRealPath(pdml.att.dest);
		var src:String = context.getRealPath(pdml.att.src);
		var oldCwd:String = Sys.getCwd();
        Sys.setCwd(destination);
        var cmd:String = 'xcopy "' + src + '" /e';
        var result:Int = Sys.command(cmd);
        Sys.setCwd(oldCwd);
        return result == 0;
	}
	
	public function del(context:IMultiModuleContext):Bool
	{
		var pdml:Fast = context.get("pdml");
		var target:String = context.getRealPath(pdml.att.target);
		var oldCwd:String = Sys.getCwd();
        Sys.setCwd(target);
        var result:Int = Sys.command('rmdir "' + target + '" /S');
        Sys.setCwd(oldCwd);
        return result == 0;
	}
}