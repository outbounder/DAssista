package haxe.org.dassista.modules.outbounder;

import haxe.Http;
import haxe.org.multicore.IMultiModule;
import haxe.org.multicore.IMultiModuleContext;
import haxe.xml.Fast;

class GitInit implements IMultiModule
{
	public static function main():Dynamic
	{
		return new GitInit();
	}
	
	public function loadKey(context:IMultiModuleContext):Bool
	{
		var pdml:Fast = context.get("pdml");
		return Sys.command("pageant " + pdml.innerData);
	}
	
	public function installUrl(context:IMultiModuleContext):Bool
	{
		var pdml:Fast = context.get("pdml");
		var http:Http = new Http(pdml.innerData);
	}
}