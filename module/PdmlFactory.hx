package haxe.org.dassista.module;

import neko.io.File;
import haxe.xml.Fast;

import haxe.org.multicore.IMultiModule;
import haxe.org.multicore.IMultiModuleContext;

class PdmlFactory implements IMultiModule
{
    public function new()
    {
        
    }
    
    public static function main():IMultiModule
    {
        return new PdmlFactory();
    }

    public function parsePdmlClass(moduleClassPath:String,context:IMultiModuleContext)
    {
        return this.parsePdmlFile(context.getRootFolder()+moduleClassPath.split(".").join("/")+".pdml",context);
    }

    public function parsePdmlFile(fullPath:String,context:IMultiModuleContext):Bool
    {
        // retrieve the pdml data
        var pdmlContent:String = File.getContent(fullPath);
        var xml:Xml = Xml.parse(pdmlContent);
        var pdml:Fast = new Fast(xml.firstElement());
        
        var parser:IMultiModule = context.createNekoModule(pdml.att.parser);
        context.put("pdml",pdml);
        return parser.execute(context);
    }

    public function execute(context:IMultiModuleContext):Bool
    {       
        var pdmlFullPath:String = context.get("pdml");
        if(pdmlFullPath.indexOf("\\")!=-1)
            return this.parsePdmlFile(pdmlFullPath,context);
        else
            return this.parsePdmlClass(pdmlFullPath,context);
        return false;
    }
}