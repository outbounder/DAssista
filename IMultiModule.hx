package haxe.org.dassista;

interface IMultiModule implements Dynamic 
{
	public function execute(context:IMultiModuleContext):Bool;
}
