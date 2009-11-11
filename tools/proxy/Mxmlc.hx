package haxe.org.dassista.tools.proxy;

import haxe.org.dassista.IMultiModule;
import haxe.org.dassista.IMultiModuleContext;
import haxe.org.dassista.ModuleException;
import haxe.rtti.Infos;

import neko.io.Path;
import neko.io.File;

class Mxmlc implements IMultiModule, implements Infos
{
	public function new() { }
	public static function main() { return new Mxmlc(); }
	
	/**
	 * @root folder on which git will be executed
	 * @cmd args which will apply to git execution
	 * @return Bool
	 */
	public function execute(context:IMultiModuleContext):Dynamic
	{
		throw "not implemented";
		return false;
	}
	
	/**
	 * @target class path of the application to be compiled
	 * @dest class path where the output will be placed
	 * @return Bool
	 */
	public function amxmlc(context:IMultiModuleContext):Dynamic
	{
		if (!context.has("target") || !context.has("dest"))
			throw new ModuleException("target and dest are needed", this, "amxmlc");
			
		var dirContext:IMultiModuleContext = context.clone();
		dirContext.set('target', context.get("dest"));
		if (!context.callTargetModuleMethod("haxe.org.dassista.tools.proxy.Dir", "create", dirContext))
			return false;
		
		var cmdContext:IMultiModuleContext = context.clone();
		cmdContext.set('root', context.getRealPath(context.get("dest")));
		cmdContext.set("cmd", "amxmlc " + context.getRealPath(context.get('target'))+'.mxml');
		var result:Bool = context.executeTargetModule("haxe.org.dassista.tools.proxy.Cmd", cmdContext) == 0;
		if (result == true)
		{
			var target:String = context.get('target');
			var targetRealPath:String = context.getRealPath(target);
			var targetName:String = Path.extension(target);
			var destRealPath:String = context.getRealPath(context.get("dest"));
			var fileContext:IMultiModuleContext = context.clone();
			fileContext.set("src", targetRealPath + ".swf");
			fileContext.set("dest", destRealPath);
			if (!context.executeTargetModule("haxe.org.dassista.tools.proxy.Move", fileContext))
				return false;
				
			File.copy(targetRealPath + "-app.xml", destRealPath + "\\" + targetName + "-app.xml");
			return true;
		}
		else
			return false;
	}
	
	/**
	 * @target directory which will be packaged to air
	 * @dest destination directory
	 * @name name of the application description file without .xml
	 * @return
	 */
	public function packageair(context:IMultiModuleContext):Dynamic
	{
		if (!context.has("target") || !context.has("dest") || !context.has("name"))
			throw new ModuleException("target and dest are needed", this, "packageair");
		
		var cmdContext:IMultiModuleContext = context.clone();
		var dest:String = context.getRealPath(context.get("dest"));
		cmdContext.set('root', context.getRealPath(context.get("target")));
		cmdContext.set("cmd", "adt –package -storetype pkcs12 -keystore cert.p12 " + dest + "\\" + context.get("name") + ".air " + context.get("name") + "-app.xml .");
		return context.executeTargetModule("haxe.org.dassista.tools.proxy.Cmd", cmdContext) == 0;
	}
}