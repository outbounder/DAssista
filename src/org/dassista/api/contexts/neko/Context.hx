package org.dassista.api.contexts.neko;

class Context implements IContext
{
	private var _hash:Hash<Dynamic>;
	
	public function new()
	{
		this._hash = new Hash();
	}
	
	private function has(key:String):Bool
	{
		return this._hash.exists(key);
	}
	
	private function set(key:String, value:Dynamic):Void
	{
		this._hash.set(key,value);
	}
	
	private function get(key:String):Dynamic
	{
		return this._hash.get(key);
	}
	
	public function getProperties():Hash<Dynamic>
	{
		return this._hash;
	}
	
	public function setProperties(value:Hash<Dynamic>):Void
	{
		this._hash = value;
	}
	
	public function clone():Dynamic
	{
		var clone:Dynamic = Type.createInstance(Type.getClass(this),[]);
		clone.setProperties(this.getProperties());
		return clone;
	}
}