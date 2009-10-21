package haxe.org.dassista.module;

import haxe.xml.Fast;
import neko.Sys;
import neko.FileSystem;
import haxe.org.multicore.IMultiModule;
import haxe.org.multicore.IMultiModuleContext;

class GitBash implements IMultiModule
{
    public function new()
    {
        
    }
    public static function main():IMultiModule
    {
        return new GitBash();
    }

    public function execute(context:IMultiModuleContext):Bool
    {
		var pdml:Fast = context.get("pdml");
		return this.git(context, pdml.att.args);
    }
	
	private function getFullDir(context:IMultiModuleContext):String
	{
		var pdml:Fast = context.get("pdml");
		var target:String = pdml.att.target;
		target = target.split(".").join("/");
		return context.getRootFolder() + target;
	}
	
	private function git(context:IMultiModuleContext, args:String):Bool
	{
		var oldCwd:String = Sys.getCwd();
        Sys.setCwd(this.getFullDir(context));
        var cmd:String = "git "+args;
        var result:Int = Sys.command(cmd);
        Sys.setCwd(oldCwd);
        return result == 0;
	}
}
