package haxe.org.dassista.module;

import haxe.org.multicore.neko.AbstractMultiModuleContext;
import haxe.org.multicore.neko.IMultiModule;
import haxe.org.multicore.neko.IMultiModuleContext;

class PdmlContext extends AbstractMultiModuleContext
{
    private var _hash:Hash<Dynamic>;
    
    public function get(key:String):Dynamic
    {
        if(_hash == null)
            _hash = new Hash();
        return _hash.get(key);  
    }

    public function put(key:String,value:Dynamic):Void
    {
        if(_hash == null)
            _hash = new Hash();
        _hash.set(key,value);
    }
}