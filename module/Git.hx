package haxe.org.dassista.module;

import haxe.xml.Fast;
import haxe.org.dassista.module.ActionPdml;
import haxe.org.dassista.multicore.IMultiModule;
import haxe.org.dassista.multicore.IMultiModuleContext;

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
       var pdml:Fast = context.hashView("pdml");
       
       var metaDataModule:IMultiModule = context.getModuleFactory().createMultiModule("haxe.org.dassista.module.MetadataPdml");
       var metaDataContext:IMultiModuleContext = context.getModuleContextFactory().clone(context);
       metaDataContext.hashView("module", pdml.att.target);
       metaDataModule.execute(metaDataContext);
       
       var gitClone:String = metaDataModule.getContext().hashView("gitClone");
       trace(gitClone);
       trace(metaDataModule.getContext().hashView("version"));
       context.hashView("result","OK");
       return true;
    }
}
