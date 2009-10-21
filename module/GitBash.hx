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
		return this.git(context, context.get("params"));
    }
	
	public function rebase(context:IMultiModuleContext):Bool
	{
		return this.git(context, "rebase origin/master");
	}
	
	public function fetch(context:IMultiModuleContext):Bool
	{
		return this.git(context, "fetch");
	}

    public function clone(context:IMultiModuleContext):Bool
    {
		if(!this.isGit(context))
			//return this.git("git clone " + this.getGitURL(context));
			trace("asdasd");
		return true;
    }
	
	private function getTargetClassName(context:IMultiModuleContext):String
	{
		var pdml:Fast = context.get("pdml");
		return pdml.att.target;
	}
	
	private function getGitURL(context:IMultiModuleContext):String
	{
		var pdml:Fast = context.get("pdml");
		context.getPdmlFactory().parsePdmlClass(pdml.att.target + ".module", context);
		return context.get("gitURL");
	}
	
	private function isGit(context:IMultiModuleContext,?target:String):Bool
	{
		var dir:String = this.getFullDir(context, target);
		return FileSystem.kind(dir+"/.git") == FileKind.kdir;
	}
	
	private function getFullDir(context:IMultiModuleContext, target:String):String
	{
		if (target == null)
			target = this.getTargetClassName(context);
		target = target.split(".").join("/");
		return context.getRootFolder() + target;
	}
	
	private function git(context:IMultiModuleContext, args:String,?target:String):Bool
	{
		var oldCwd:String = Sys.getCwd();
        Sys.setCwd(this.getFullDir(context,target));
        var cmd:String = "git "+args;
        var result:Int = Sys.command(cmd);
        Sys.setCwd(oldCwd);
        return result == 0;
	}
}
