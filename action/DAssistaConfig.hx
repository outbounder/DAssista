package haxe.org.dassista.action;

import haxe.org.dassista.module.ScriptedModule;
import haxe.org.dassista.multicore.IMultiModuleContext;
import haxe.xml.Fast;

class DAssistaConfig extends ScriptedModule
{
	public static function main():Dynamic
	{
		return new DAssistaConfig();
	}
	
	public function exec(context:IMultiModuleContext,action:Fast):Dynamic
	{
		trace(action);
	}
}
