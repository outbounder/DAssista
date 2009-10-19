package haxe.org.dassista.multicore;

import haxe.org.dassista.multicore.IMultiModule;
import haxe.org.dassista.multicore.IMultiModuleContext;

class MultiModuleContextFactory
{
    private var caller:IMultiModule;
    private var context:IMultiModuleContext;
    
    public function new(caller:IMultiModule)
    {   
        this.caller = caller;
    }

    public function generate():IMultiModuleContext
    {
        return new MultiModuleContextImpl(this.caller);
    }

    public function getContext():IMultiModuleContext
    {
        if(this.context == null)
            this.generate();
        return this.context;
    }

}

private class MultiModuleContextImpl implements IMultiModuleContext
{
    public var caller:IMultiModule;
    private var hash:Hash<Dynamic>;
    private var vector:Array<Dynamic>;
    
    public function new(caller:IMultiModule, ?hash:Hash<Dynamic>, ?vector:Array<Dynamic>)
    {
        this.caller = caller;
        if(hash == null)
            this.hash = new Hash();
        else
            this.hash = hash;
        if(vector == null)
            this.vector = new Array();
        else
            this.vector = vector; 
    }

    public function setCaller(value:IMultiModule):Void
    {
        this.caller = value;
    }

    public function getCaller():IMultiModule
    {
        return this.caller;
    }
    
    public function hashView(?key:String,?value:Dynamic):Dynamic
    {
        if(key == null && value == null)
            return this.getHashView();
        else
        if(value == null)
            return this.getHashView().get(key);
        else
            return this.getHashView().set(key,value);
    }
    
    public function getHashView():Hash<Dynamic>
    {
        return this.hash;
    }

    public function getVectorView():Array<Dynamic>
    {
        return this.vector;
    }
}