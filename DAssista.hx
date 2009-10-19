package haxe.org.dassista;

import haxe.org.dassista.pdml.APDMLProcessor;
import haxe.org.dassista.pdml.ApdmlModuleFactory;
import haxe.org.dassista.pdml.IApdmlModule;
import haxe.org.dassista.pdml.IApdmlModuleContext;


import haxe.Log;
import neko.Sys;
import neko.vm.Loader;
import neko.vm.Module;


class DAssista implements IApdmlModule
{
	private var moduleFactory:ApdmlModuleFactory;
	
	public function new()
	{
		this.moduleFactory = new ApdmlModuleFactory(this.getRootPath());
	}
	
	public static function main()
	{
		var instance:DAssista = new DAssista();
		instance.execute(null);
	}
	
	public function execute(context:IApdmlModuleContext):Dynamic
	{
		if(this.hasPdmlPath())
		{
			var apdmlProcessor:APDMLProcessor = new APDMLProcessor(this.getPdmlPath(),this.getRootPath());
			try
			{
				trace("EXECUTE FINISHED:"+apdmlProcessor.execute(this.moduleFactory.createApdmlModuleContext(this,null)));
			}
			catch(error:Dynamic)
			{
				trace("ERROR");
				trace(error);
			}
		}
		else
			trace("use -pdml %file% switch to execute pdml script");
	}
	
	public function getContext():IApdmlModuleContext
	{
		return null;
	}
	
	private function hasPdmlPath():Bool
	{
		if(Sys.args()[0] == "-pdml")
			return true;
		else
			return false;
	}
	
	private function getPdmlPath():String
	{
		return Sys.args()[1];
	}
	
	private function hasRootPath():Bool
	{
		if(Sys.args()[2] == "-root")
			return true;
		else
			return false;
	}
	
	private function getRootPath():String
	{
		return this.hasRootPath()?Sys.args()[3]:"./";
	}
}
