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
			return this.git(context, "clone " + this.getGitURL(context));
		return true;
    }
	
	public function isGit(context:IMultiModuleContext):Bool
	{
		var dir:String = this.getFullDir(context);
		return FileSystem.kind(dir+"/.git") == FileKind.kdir;
	}
	
	private function getGitURL(context:IMultiModuleContext):String
	{
		var pdml:Fast = context.get("pdml");
		context.getPdmlFactory().parsePdmlClass(pdml.att.target + ".module", context);
		return context.get("gitURL");
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
