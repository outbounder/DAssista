package haxe.org.dassista;

interface IMultiModuleContext implements Dynamic
{
	public function clone():IMultiModuleContext;
	public function describe(instance:IMultiModule, ?field:String):String;
	public function executeTargetModule(target:String, targetContext:IMultiModuleContext):Dynamic;
	public function createTargetModule(target:String):IMultiModule;
	public function compileTargetModule(target:String):Bool;
	public function getRealPath(target:String):String;
	public function getClassPath(target:String):String;
	public function get(key:String):Dynamic;
	public function set(key:String, value:Dynamic):Void;
	public function keys():Iterator<String>;
	public function has(key:String):Bool;
}
