package org.dassista.app;

import org.dassista.api.contexts.neko.AppContext;
import neko.io.File;

class ShellContext extends AppContext
{
	private var _moduleName:String;
	private var _methodName:String;
	
	public function new()
	{
		super();
		this.setOuputHandler(this.handleOutput);
	}
	
	public function setArgsHash(args:Hash<String>):Void
	{
		for(key in args.keys())
		{
			if(key == "moduleName")
				this._moduleName = args.get(key);
			else
			if(key == "methodName")
				this._methodName = args.get(key);
			else
				this.set(key, args.get(key));
		}
	}
	
	public function setArgsArray(args:Array<String>):Void
	{
		for(arg in args)
		{
			var parts:Array<String> = arg.split('=');
			if(parts[0] == "moduleName")
				this._moduleName = parts[1];
			else
			if(parts[0] == "methodName")
				this._methodName = parts[1];
			else
				this.set(parts[0],parts[1]);
		}
	}
		
	public function getModuleName():String
	{
		return this._moduleName;
	}
	
	public function getMethodName():String
	{
		return this._methodName;
	}
	
	private function handleOutput(value:Dynamic):Void
	{
		File.stdout().writeString(value+"\n");
	}
}