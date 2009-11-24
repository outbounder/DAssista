package org.dassista.modules.proxy;

import org.dassista.api.contexts.neko.MethodContext;

import haxe.rtti.Infos;
import neko.io.Path;
import neko.io.File;

class Mxmlc implements Infos
{
	public function new() { }
	public static function main() { return new Mxmlc(); }
	
	/**
	 * @target class path of the application to be compiled
	 * @dest class path where the output will be placed
	 * @return Bool
	 */
	public function amxmlc(context:MethodContext):Bool
	{
		if (!context.hasArg("target") || !context.hasArg("dest"))
			throw "target and dest are needed";
			
		var dirContext:MethodContext = new MethodContext(context);
		dirContext.setArg('target', context.getArg("dest"));
		if (!context.callModuleMethod("org.dassista.modules.proxy.Dir", "create", dirContext))
			return false;
		
		var cmdContext:MethodContext = new MethodContext(context);
		cmdContext.setArg('root', context.getRealPath(context.getArg("dest")));
		cmdContext.setArg("cmd", "cmd.exe /c amxmlc " + context.getRealPath(context.getArg('target'))+'.mxml');
		context.callModuleMethod("org.dassista.modules.proxy.Cmd", "execute", cmdContext);
		
		var target:String = context.getArg('target');
		var destRealPath:String = context.getRealPath(context.getArg("dest"));
		var targetRealPath:String = context.getRealPath(target);
		var targetName:String = Path.extension(target);
		
		var fileContext:MethodContext = new MethodContext(context);
		fileContext.setArg("src", targetRealPath + ".swf");
		fileContext.setArg("dest", destRealPath);
		if (!context.callModuleMethod("org.dassista.modules.proxy.Move", "execute", fileContext))
			return false;
			
		File.copy(targetRealPath + "-app.xml", destRealPath + "\\" + targetName + "-app.xml");
		return true;
		
	}
	
	/**
	 * @target directory which will be packaged to air
	 * @dest destination directory
	 * @name name of the application description file without .xml
	 * @keypath class path to the key .p12
	 * @keypass password for the key
	 * @return
	 */
	public function packageair(context:MethodContext):Bool
	{
		if (!context.hasArg("target") || !context.hasArg("dest") || !context.hasArg("name"))
			throw "target and dest are needed";
		
		var cmdContext:MethodContext = new MethodContext(context);
		var dest:String = context.getRealPath(context.getArg("dest"));
		cmdContext.setArg('root', context.getRealPath(context.getArg("target")));
		var cmd:String = "cmd.exe /c adt -package -storetype pkcs12 -keystore " + context.getRealPath(context.getArg("keypath")) + ".p12  -storepass "+context.getArg("keypass")+" "+
			dest + "\\" + context.getArg("name") + ".air " + context.getArg("name") + "-app.xml .";
		
		cmdContext.setArg("cmd", cmd);
		return context.callModuleMethod("org.dassista.modules.proxy.Cmd", "execute", cmdContext).length == 0;
	}
}