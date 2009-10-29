package haxe.org.dassista.contexts;

import haxe.org.dassista.IMultiModuleContext;
import haxe.org.dassista.IMultiModule;
import haxe.org.dassista.contexts.MultiModuleContext;


class ShellContext extends MultiModuleContext
{
	public static function main():Dynamic 
	{
		return new ShellContext();
	}
	
	public override function output(value:Dynamic):Void
	{
		var rendererContext:IMultiModuleContext = this.clone();
		rendererContext.set("value", value);
		if (!this.executeTargetModule("haxe.org.dassista.contexts.renderers.ShellRenderer", rendererContext))
			throw "can not render output " + value + " using Shell renderer";
	}
}