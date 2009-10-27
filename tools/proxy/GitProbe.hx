package haxe.org.dassista.tools.proxy;

import haxe.org.dassista.IMultiModule;
import haxe.org.dassista.IMultiModuleContext;
import neko.FileSystem;

class GitProbe implements IMultiModule
{
	private static var gitInstallLocation:String = "haxe.org.dassista.tools.install.cache.gitInstall";
	public function new() {} 
	public static function main():Dynamic { return new GitProbe(); }
	
	public function execute(context:IMultiModuleContext):Bool
	{
		throw "not implemneted";
		return false;
	}
	
	public function probe(context:IMultiModuleContext):Bool
	{		
		if (!this.gitAvailable(context))
		{
			if (!this.gitDownloaded(context))
			{
				var wgetContext:IMultiModuleContext = context.clone();
				wgetContext.set("src", context.get("src"));
				wgetContext.set("dest", GitProbe.gitInstallLocation);
				if (!context.callTargetModuleMethod("haxe.org.dassista.tools.proxy.Wget", "download", wgetContext))
					return false;
			}
			
			var cmdContext:IMultiModuleContext = context.clone();
			cmdContext.set("exec", GitProbe.gitInstallLocation);
			return context.executeTargetModule("haxe.org.dassista.tools.proxy.Cmd", cmdContext);
		}
		else
			return true;
	}
	
	private function gitDownloaded(context:IMultiModuleContext):Bool
	{
		return FileSystem.exists(context.getRealPath(GitProbe.gitInstallLocation));
	}
	
	private function gitAvailable(context:IMultiModuleContext):Bool
	{
		var cmdContext:IMultiModuleContext = context.clone();
		cmdContext.set("root", context.getRealPath(""));
		cmdContext.set("cmd", "git version");
		return context.executeTargetModule("haxe.org.dassista.tools.proxy.Cmd", cmdContext);
	}
}