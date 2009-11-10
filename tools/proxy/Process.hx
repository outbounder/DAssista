package haxe.org.dassista.tools.proxy;

import haxe.org.dassista.IMultiModule;
import haxe.org.dassista.IMultiModuleContext;
import haxe.org.dassista.ModuleException;
import haxe.rtti.Infos;

import neko.io.Path;
import neko.io.Process;

class Process implements IMultiModule, implements Infos
{
	public function new() { }
	public static function main() { return new Process(); }
	
	/**
	 * @return Bool
	 */
	public function execute(context:IMultiModuleContext):Dynamic
	{
		var prc:neko.io.Process = new neko.io.Process(context.getRealPath(context.get("root")) + "\\" + context.get("cmd"), context.get('args'));
		return true;
	}
	
}