package haxe.org.dassista.multicore;

import haxe.org.dassista.multicore.IMultiModule;
import haxe.org.dassista.multicore.IMultiModuleContext;

import neko.FileSystem;
import neko.Lib;
import neko.Sys;
import neko.vm.Module;
import neko.vm.Loader;
import haxe.xml.Fast;

class MultiModuleFactory
{
    private var rootPath:String;
    private var cache:Hash<Dynamic>;
    private var compile:Bool;
    
    public function new(rootPath:String, compile:Bool)
    {
        this.cache = new Hash();
        this.rootPath = rootPath;
        this.compile = compile;
    }
    
    public function createMultiModule(moduleClassPath:String):IMultiModule
    {
        if(this.cache.exists(moduleClassPath))
            return this.cache.get(moduleClassPath).execute();
            
        // ensure that the module is up-to-date
        if(this.compile)
        {
            var compiler:ModuleCompiler = new ModuleCompiler(this.rootPath, this.getMultiModuleHaxePath(moduleClassPath));
            // compile to the module's class path folder
            var result:Int = compiler.compile();
            if(result != 0)
              throw "error found during compile of "+moduleClassPath;
        }
        
        // load the module & return its instance
        var moduleCompiledPath:String = this.rootPath+this.getMultiModuleNekoPath(moduleClassPath);
        var nekoModule:Module = Loader.local().loadModule(moduleCompiledPath);
        this.cache.set(moduleClassPath, nekoModule);
        
        var multiModuleInstance:Dynamic = nekoModule.execute();
        return multiModuleInstance;
    }

    
    private function getMultiModuleHaxePath(module:String):String
    {
        return module.split(".").join("/") + ".hx";
    }
    
    private function getMultiModuleNekoPath(module:String):String
    {
        return module.split(".").join("/") + ".n";
    }
}
