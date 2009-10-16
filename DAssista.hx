package haxe.org.dassista;

import haxe.org.dassista.pdml.ApdmlModuleFactory;
import haxe.org.dassista.pdml.ApdmlModule;

import haxe.Log;
import neko.Sys;
import neko.vm.Loader;
import neko.vm.Module;


class DAssista
{
	public static function main()
	{
		trace(Sys.args());
		var factory:ApdmlModuleFactory = new ApdmlModuleFactory("D:/pd-repo/");
		var module:ApdmlModule = factory.createApdmlModule("haxe.org.dassista.action.Build");
		trace(module.execute("test"));
	}
}