package haxe.org.dassista.modules.outbounder;

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
		var cmd:String = pdml.att.cmd;
		
		return this.git(target, cmd);
    }
	
	public function clone(context:IMultiModuleContext):Bool
	{
		var pdml:Fast = context.get("pdml");
		var target:String = pdml.att.target;
		var dest:String = "";
		if(pdml.has.dest)
			dest = pdml.att.dest;
		
		var parserContext:IMultiModuleContext = context.clone(this);
		parserContext.set("target", target + ".module");
		if (context.executeTargetModule("haxe.org.dassista.modules.outbounder.Parser",parserContext))
		{
			var gitCloneURL:String = parserContext.get("gitCloneURL");
			if (gitCloneURL == null)
				throw "git clone not defined in " + target + ".module";
			this.git(context.getRealPath(target), "clone " + gitCloneURL + " " + dest);
			return true;
		}
		else
			return false;
	}
	
	private function git(target:String, cmd:String):Bool
	{
		var oldCwd:String = Sys.getCwd();
        Sys.setCwd(target);
        var result:Int = Sys.command("git "+cmd);
        Sys.setCwd(oldCwd);
        return result == 0;
	}
}
