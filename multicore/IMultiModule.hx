package haxe.org.dassista.multicore;

extern interface IMultiModule 
{
	function execute(context:IMultiModuleContext):Dynamic;
}
