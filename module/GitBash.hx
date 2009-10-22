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
		var target:String = context.getRealPath(pdml.att.target);
		var args:String = context.get("args").att.args;
		
		return this.git(target, args);
    }
	
	public function clone(context:IMultiModuleContext):Bool
	{
		var pdml:Fast = context.get("pdml");
		var target:String = pdml.att.target;
		var dest:String = "";
		if(pdml.has.dest)
			dest = pdml.att.dest;
		
		if (context.parsePdmlClass(target + ".module"))
		{
			var gitCloneURL:String = context.get("gitCloneURL");
			if (gitCloneURL == null)
				throw "git clone not defined in " + target + ".module";
			this.git(context.getRealPath(target), "clone " + gitCloneURL + " " + dest);
			return true;
		}
		else
			return false;
	}
	
	private function git(target:String, args:String):Bool
	{
		var oldCwd:String = Sys.getCwd();
        Sys.setCwd(target);
        var cmd:String = "git "+args;
        var result:Int = Sys.command(cmd);
        Sys.setCwd(oldCwd);
        return result == 0;
	}
}
