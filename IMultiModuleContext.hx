package haxe.org.dassista;

interface IMultiModuleContext implements Dynamic
{
	public function clone():IMultiModuleContext;
	public function output(value:Dynamic):Void;
	public function clearModulesCache(context:IMultiModuleContext):Bool;
	public function describe(instance:IMultiModule, ?field:String):Xml;
	public function executeTargetModule(target:String, targetContext:IMultiModuleContext):Dynamic;
	public function createTargetModule(target:String):IMultiModule;
	public function compileTargetModule(target:String):Bool;
	public function callTargetModuleMethod(target:String, methodName:String, methodContext:IMultiModuleContext):Dynamic;
	public function getRealPath(target:String):String;
	public function getClassPath(target:String):String;
	public function get(key:String):Dynamic;
	public function set(key:String, value:Dynamic):Void;
	public function keys():Iterator<String>;
	public function has(key:String):Bool;
}
