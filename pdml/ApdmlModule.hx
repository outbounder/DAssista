package haxe.org.dassista.pdml;

import haxe.org.dassista.pdml.IApdmlModule;

import neko.vm.Module;


class ApdmlModule implements IApdmlModule
{
	private var name:Dynamic;
	private var nekoModule:Module;
	private var apdmlModuleInstane:IApdmlModule;
	
	public function new(module:Module,name:Dynamic)
	{
		this.nekoModule = module;
		this.name = name;
	}
	
	public function execute(context:Dynamic):Dynamic
	{
		//var classes : Dynamic = this.nekoModule.exportsTable().__classes;
		trace(Type.resolveClass("haxe.org.dassista.action.Build"));
    	//this.apdmlModuleInstane = cast(Type.createInstance(, []), IApdmlModule);
    	
		return this.apdmlModuleInstane.execute(context);
	}
}