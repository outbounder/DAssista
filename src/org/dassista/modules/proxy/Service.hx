package haxe.org.dassista.tools.proxy;

import haxe.org.dassista.IMultiModule;
import haxe.org.dassista.IMultiModuleContext;
import haxe.org.dassista.ModuleException;
import haxe.rtti.Infos;

import neko.io.Path;

class Service implements IMultiModule, implements Infos
{
	public function new() { }
	public static function main() { return new Service(); }
	
	/**
	 * @name name of the service to be created
	 * @root the root class path
	 * @cmd the command with args to be applied at root
	 * @return Bool
	 */
	public function create(context:IMultiModuleContext):Bool
	{
		var cmdContext:IMultiModuleContext = context.clone();
		cmdContext.set("root", "");
		cmdContext.set("cmd", 'sc create ' + context.get("name") + ' binPath= "' + context.getRealPath(context.get("root")) + "\\" + context.get("cmd") + '"');
		return context.executeTargetModule("haxe.org.dassista.tools.proxy.Cmd", cmdContext) == 0;
	}
	
	/**
	 * @name name of the service to be deleted
	 * @return Bool
	 */
	public function delete(context:IMultiModuleContext):Bool
	{
		var cmdContext:IMultiModuleContext = context.clone();
		cmdContext.set("root", "");
		cmdContext.set("cmd", 'sc delete ' + context.get("name"));
		return context.executeTargetModule("haxe.org.dassista.tools.proxy.Cmd", cmdContext) == 0;
	}
	
	/**
	 * @name of the service to be restarted
	 * @return
	 */
	public function restart(context:IMultiModuleContext):Bool
	{
		var cmdContext:IMultiModuleContext = context.clone();
		cmdContext.set("root", "");
		cmdContext.set("cmd", 'net stop ' + context.get("name"));
		context.executeTargetModule("haxe.org.dassista.tools.proxy.Cmd", cmdContext);
		cmdContext.set("cmd", 'net start ' + context.get("name"));
		return context.executeTargetModule("haxe.org.dassista.tools.proxy.Cmd", cmdContext) == 0;
	}
	
	/**
	 * @name name of the service to be started
	 * @return
	 */
	public function start(context:IMultiModuleContext):Bool
	{
		var cmdContext:IMultiModuleContext = context.clone();
		cmdContext.set("root", "");
		cmdContext.set("cmd", 'net start ' + context.get("name"));
		return context.executeTargetModule("haxe.org.dassista.tools.proxy.Cmd", cmdContext) == 0;
	}
		
	/**
	 * @name of the service to be stopped
	 * @return
	 */
	public function stop(context:IMultiModuleContext):Bool
	{
		var cmdContext:IMultiModuleContext = context.clone();
		cmdContext.set("root", "");
		cmdContext.set("cmd", 'net stop ' + context.get("name"));
		return context.executeTargetModule("haxe.org.dassista.tools.proxy.Cmd", cmdContext) == 0;
	}
	
}