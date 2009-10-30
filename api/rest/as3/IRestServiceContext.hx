package haxe.org.dassista.api.rest.as3;

interface IRestServiceContext
{
	public function getValue(key:String):String;
	public function setValue(key:String, value:String):Void;
	public function getPropertiesAsUrlArgs():String;
}