package haxe.org.dassista;

import haxe.rtti.Infos;

interface IMultiModule implements Dynamic, implements Infos
{
	public function execute(context:IMultiModuleContext):Dynamic;
}
