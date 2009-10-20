package haxe.org.dassista.module;

import haxe.xml.Fast;
import haxe.org.dassista.module.ActionPdml;
import haxe.org.multicore.neko.IMultiModule;
import haxe.org.multicore.neko.IMultiModuleContext;

class Git extends ActionPdml
{
    public static function main():IMultiModule
    {
        return new Git();
    }

    public function new()
    {
        super();
    }

    public function update(context:IMultiModuleContext):Bool
    {
       var pdml:Fast = context.get("pdml");
       
       var modulePdmlParser:IMultiModule = context.getModuleFactory().createMultiModuleByClassPath("haxe.org.dassista.module.PdmlFactory");
       if(modulePdmlParser.loadModulePdmlFast(pdml.att.target+".module",context))
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
