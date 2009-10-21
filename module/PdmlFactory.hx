package haxe.org.dassista.module;

import neko.io.File;
import haxe.xml.Fast;

import haxe.org.multicore.neko.AbstractMultiModule;
import haxe.org.multicore.neko.IMultiModule;
import haxe.org.multicore.neko.IMultiModuleContext;

class PdmlFactory extends AbstractMultiModule
{
    public static function main():Dynamic
    {
        return new PdmlFactory();
    }

    public function loadModulePdmlFast(moduleClassPath:String,context:IMultiModuleContext)
    {
        return this.loadPdmlFast(context.get("root")+moduleClassPath.split(".").join("/")+".pdml",context);
    }

    public function loadPdmlFast(fullPath:String,context:IMultiModuleContext):Bool
    {
        this.context = context;
        
        // retrieve the pdml data
        var pdmlContent:String = File.getContent(fullPath);
        var xml:Xml = Xml.parse(pdmlContent);
        var pdml:Fast = new Fast(xml.firstElement());
        
        var parser:IMultiModule = this.context.getModuleFactory().createMultiModuleByClassPath(pdml.att.parser);
        context.put("pdml",pdml);
        return parser.execute(context);
    }

    public override function execute(context:IMultiModuleContext):Bool
    {
        super.execute(context);
        
        var pdmlFullPath:String = context.get("pdml");
        trace(pdmlFullPath);
        if(pdmlFullPath.indexOf("\\")!=-1)
            return this.loadPdmlFast(pdmlFullPath,context);
        else
            return this.loadModulePdmlFast(pdmlFullPath,context);
        return false;
    }
}