package haxe.org.dassista.contexts;

import haxe.org.dassista.contexts.MultiModuleContext;
import haxe.org.dassista.IMultiModuleContext;
import haxe.org.dassista.IMultiModule;

class RestServiceContext extends MultiModuleContext
{
	public static function main():Dynamic 
	{
		return new RestServiceContext();
	}
	
	public override function output(value:Dynamic):Void
	{
		var rendererContext:IMultiModuleContext = this.clone();
		rendererContext.set("value", value);
		if (!this.executeTargetModule("haxe.org.dassista.contexts.renderers.RestRenderer", rendererContext))
			throw "can not render output " + value + " using Rest renderer";
	}
}