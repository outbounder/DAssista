package haxe.org.dassista.pdml;

interface IApdmlModule
{
	function execute(context:IApdmlModuleContext):Dynamic;
	function getContext():IApdmlModuleContext;
}
