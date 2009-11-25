package org.dassista.api.rest.as3;

interface IRestServiceContext
{
	public function getValue(key:String):String;
	public function setValue(key:String, value:String):Void;
	public function clone():IRestServiceContext;
	public function load(onResultDataEventHandler:Dynamic->Void):Void;
	public function loadModuleResult(context:IRestServiceContext, onResultDataEventHandler:Dynamic->Void):Void;
	public function getPropertiesAsUrlArgs():String;
}