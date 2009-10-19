package haxe.org.dassista.multicore;

import haxe.org.dassista.multicore.IMultiModule;
import haxe.xml.Fast;

interface IMultiModuleContext
{
	public function getCaller():IMultiModule;
	public function getHashView():Hash<Dynamic>;
    public function getVectorView():Array<Dynamic>;
    public function hashView(?key:String,?value:Dynamic):Dynamic;
}
