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
		trace("TODO implement generic FileSys.execute");
		return true;
	}
	
	public function copy(context:IMultiModuleContext):Bool
	{
		var pdml:Fast = context.get("pdml");
		var destination:String = this.getRealpath(context,pdml.att.dest);
		var oldCwd:String = Sys.getCwd();
        Sys.setCwd(destination);
        var cmd:String = 'xcopy "' + this.getRealpath(context,pdml.att.target) + '" /e';
        var result:Int = Sys.command(cmd);
        Sys.setCwd(oldCwd);
        return true;
	}
	
	public function del(context:IMultiModuleContext):Bool
	{
		trace("TODO implement delete");
		return true;
	}
	
	private function getRealpath(context:IMultiModuleContext, target:String):String
	{
		target = target.split(".").join("/");
		return context.getRootFolder() + target;
	}
}