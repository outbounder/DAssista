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

    public function merge(contextA:IMultiModuleContext, contextB:IMultiModuleContext):IMultiModuleContext
    {
        var newHash:Hash<Dynamic> = new Hash();
        var oldHashKeys:Iterator<String> = contextA.getHashView().keys();
        for(oldKey in oldHashKeys)
            newHash.set(oldKey, contextA.getHashView().get(oldKey));
        oldHashKeys = contextB.getHashView().keys();
        for(oldKey in oldHashKeys)
            newHash.set(oldKey, contextB.getHashView().get(oldKey));
        return new MultiModuleContextImpl(this.caller,
            contextA.getModuleFactory(), contextA.getModuleContextFactory(), 
            newHash, contextB.getVectorView().copy());
    }

    public function clone(context:IMultiModuleContext):IMultiModuleContext
    {
        var newHash:Hash<Dynamic> = new Hash();
        var oldHashKeys:Iterator<String> = context.getHashView().keys();
        for(oldKey in oldHashKeys)
            newHash.set(oldKey, context.getHashView().get(oldKey));
        return new MultiModuleContextImpl(this.caller,
            context.getModuleFactory(), context.getModuleContextFactory(), 
            newHash, context.getVectorView().copy());
    }

    public function generate(moduleFactory:MultiModuleFactory):IMultiModuleContext
    {
        return new MultiModuleContextImpl(this.caller,
            moduleFactory, 
            this);
    }

    public function getContext(moduleFactory:MultiModuleFactory):IMultiModuleContext
    {
        if(this.context == null)
            this.context = this.generate(moduleFactory);
        return this.context;
    }

}

private class MultiModuleContextImpl implements IMultiModuleContext
{
    public var caller:IMultiModule;
    private var hash:Hash<Dynamic>;
    private var vector:Array<Dynamic>;
    private var moduleFactory:MultiModuleFactory;
    private var moduleContextFactory:MultiModuleContextFactory;
    
    public function new(caller:IMultiModule, moduleFactory:MultiModuleFactory, moduleContextFactory:MultiModuleContextFactory,
        ?hash:Hash<Dynamic>, ?vector:Array<Dynamic>)
    {
        this.caller = caller;
        this.moduleFactory = moduleFactory;
        this.moduleContextFactory = moduleContextFactory;
        
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

    public function getModuleFactory():MultiModuleFactory
    {
        return this.moduleFactory;
    }

    public function getModuleContextFactory():MultiModuleContextFactory
    {
        return this.moduleContextFactory;
    }
}
