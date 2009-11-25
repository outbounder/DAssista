package org.dassista.api.contexts.neko;

class MethodContext extends AppContext
{
	private var _args:Hash<Dynamic>;
	private var _output:Dynamic;
	
	public function new(appContext:AppContext)
	{
		super();
		this._args = new Hash();
		this.setProperties(appContext.getProperties());
		this._outputHandler = appContext.getOutputHandler();
	}
	
	public function setArgs(value:Hash<Dynamic>):Void
	{
		this._args = value;
	}
	
	public function getArgs():Hash<Dynamic>
	{
		return this._args;
	}
	
	public function hasArg(key:String):Bool
	{
		return this._args.exists(key) || this.has(key);
	}
	
	public function setArg(key:String,value:Dynamic):Void
	{
		this._args.set(key,value);
	}
	
	public function getArg(key:String):Dynamic
	{
		if(this._args.exists(key))
			return this._args.get(key);
		else
		if(this.has(key))
			return this.get(key);
		else
			throw "key not found:"+key;
	}
	
	public function setOutput(value:Dynamic):Void
	{
		this._output = value;
	}
	
	public function getOutput():Dynamic
	{
		return this._output;
	}
}