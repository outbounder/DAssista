package haxe.org.dassista.api.rest.as3;

import flash.events.DataEvent;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.EventDispatcher;
import flash.net.URLLoader;
import flash.net.URLRequest;

import haxe.org.dassista.api.rest.as3.IRestServiceContext;

class RestService extends EventDispatcher, implements IRestServiceContext
{
	private var endpoint:String;
	private var _properties:Hash<Dynamic>;
	
	public function new(?endpoint:String)
	{
		super();
		if(endpoint != null)
			this.endpoint = endpoint;
		else
			this.endpoint = "http://localhost:2000";
		this._properties = new Hash();
	}
	
	public function getValue(key:String):String
	{
		return this._properties.get(key);
	}
	
	public function setValue(key:String, value:String):Void
	{
		this._properties.set(key, value);
	}
	
	public function clone():IRestServiceContext
	{
		return new RestService(this.endpoint);
	}
	
	public function load( onResultDataEventHandler:Dynamic->Void):Void
	{
		var module:String = this.getValue("module");
		var method:String = this.getValue("method");
		
		var loader:RestServiceLoader = new RestServiceLoader(onResultDataEventHandler);
		var urlArgs:String = this.getPropertiesAsUrlArgs();
		var urlRequest:URLRequest = new URLRequest(this.endpoint + "/haxe/org/dassista/RestService.n?" + (urlArgs != null?urlArgs:""));
		loader.load(urlRequest);
	}
		
	public function loadModuleResult(context:IRestServiceContext, onResultDataEventHandler:Dynamic->Void):Void
	{
		var module:String = context.getValue("module");
		var method:String = context.getValue("method");
		
		var loader:RestServiceLoader = new RestServiceLoader(onResultDataEventHandler);
		var urlArgs:String = context.getPropertiesAsUrlArgs();
		var urlRequest:URLRequest = new URLRequest(this.endpoint + "/haxe/org/dassista/RestService.n?" + (urlArgs != null?urlArgs:""));
		loader.load(urlRequest);
	}
	
	public function getPropertiesAsUrlArgs():String
	{
		var result  = [];
		for (prop in this._properties.keys())
			result.push(prop + "=" + this._properties.get(prop));
		return result.join("&");
	}
}

private class RestServiceLoader extends URLLoader
{
	public function new(onResultDataEventHandler:Dynamic->Void)
	{
		super(null);
		this.addEventListener(Event.COMPLETE, onLoadComplete);
		this.addEventListener(DataEvent.DATA, onResultDataEventHandler);
		this.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
	}
	
	private function onIOError(e:IOErrorEvent):Void
	{
		var event:DataEvent = new DataEvent(DataEvent.DATA);
		event.data = "<ioerror>" + e.toString() + "</ioerror>";
		this.dispatchEvent(event);
	}
	
	private function onLoadComplete(e:Event):Void
	{
		var event:DataEvent = new DataEvent(DataEvent.DATA);
		event.data = cast(e.target, URLLoader).data;
		this.dispatchEvent(event);
	}
}