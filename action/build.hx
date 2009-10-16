package haxe.org.dassista.action;

import haxe.org.dassista.pdml.IApdmlModule;

class Build implements IApdmlModule
{
	public function execute(context:Dynamic):Dynamic
	{
		trace(context+" - tested");
	}
}