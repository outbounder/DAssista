package haxe.org.dassista.multicore;

import haxe.org.dassista.multicore.IMultiModule;
import haxe.xml.Fast;

interface IMultiModuleContext
{
	function getCaller():IMultiModule;
	function getInputContext():IMultiModuleInput;
	function getOutputContext():IMultiModuleOutput;
}
