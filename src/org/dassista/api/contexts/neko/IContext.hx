package org.dassista.api.contexts.neko;

interface IContext 
{
	public function getProperties():Hash<Dynamic>;
	public function setProperties(value:Hash<Dynamic>):Void;
}