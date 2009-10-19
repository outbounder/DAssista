package haxe.org.dassista.pdml.impl;

import haxe.org.dassista.pdml.IApdmlModule;
import haxe.org.dassista.pdml.IApdmlModuleContext;

import neko.vm.Module;


class ApdmlModuleInstance implements IApdmlModule
{
	private var nekoModule:Module;
	private var apdmlModuleInstane:IApdmlModule;
	private var context:IApdmlModuleContext;
	
	public function new(module:Module)
	{
		this.nekoModule = module;
	}
	
	public function execute(context:IApdmlModuleContext):Dynamic
	{
		this.context = context;
		this.apdmlModuleInstane = this.nekoModule.execute();
		return this.apdmlModuleInstane.execute(context);
	}
	
	public function getContext():IApdmlModuleContext
	{
		return this.context;
	}
}
