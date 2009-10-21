package haxe.org.dassista.module;

import haxe.xml.Fast;
import neko.Sys;
import haxe.org.multicore.IMultiModule;
import haxe.org.multicore.IMultiModuleContext;

class Git implements IMultiModule
{
    public function new()
    {
        
    }
    public static function main():IMultiModule
    {
        return new Git();
    }

    public function execute(context:IMultiModuleContext):Bool
    {
        var oldCwd:String = Sys.getCwd();
        Sys.setCwd(context.getRootFolder());
        var cmd:String = "git";
        var result:Int = Sys.command(cmd);
        Sys.setCwd(oldCwd);
        return result != 0;
    }

    public function update(context:IMultiModuleContext):Bool
    {
       var pdml:Fast = context.get("pdml");
       var modulePdmlParser:IMultiModule = context.createNekoModule("haxe.org.dassista.module.PdmlFactory");
       if(modulePdmlParser.parsePdmlClass(pdml.att.target+".module",context))
       {         
         trace(context.get("gitClone"));
         trace(context.get("version"));
         context.put("result","OK");
         trace(context.get("result"));
       }
       else
       {
         trace("load failed");
         context.put("result", "FAILED");
         trace(context.get("result"));
       }
       return true;
    }
}
