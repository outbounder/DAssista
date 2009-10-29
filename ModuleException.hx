package haxe.org.dassista;

class ModuleException
{
	private var msg:String;
	private var module:IMultiModule;
	private var method:String;
	
	public function new(message:String,module:IMultiModule,method:String)
	{
		this.msg = message;
		this.module = module;
		this.method = method;
	}
	
	public function getMethod():String
	{
		return this.method;
	}
	
	public function getModule():IMultiModule
	{
		return this.module;
	}
	
	public function getMessage():String
	{
		return this.msg;
	}
}