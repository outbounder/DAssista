package haxe.org.dassista.module;

import haxe.xml.Fast;
import neko.io.File;

import haxe.org.dassista.multicore.AbstractModule;
import haxe.org.dassista.multicore.IMultiModule;
import haxe.org.dassista.multicore.IMultiModuleContext;

class MetadataPdml extends AbstractModule
{
    public static function main():IMultiModule
    {
        return new MetadataPdml();
    }
    
    public function new()
    {	
        super();
    }
    
    public override function execute(context:IMultiModuleContext):Bool
    {
        // save the incoming context
        this.context = context;
        
        // read the default context input required field
        var modulePdmlName:String = context.hashView("module");

        // try loading the pdml
        var pdmlContent:String = File.getContent(context.hashView("root")+modulePdmlName.split(".").join("/")+"/module.pdml");
        var xml:Xml = Xml.parse(pdmlContent);
        var pdml:Fast = new Fast(xml.firstElement());
        
        for(entry in pdml.elements)
        {
            this.context.hashView(entry.name, entry.innerData);
        }
            
        return true;
    }
}
