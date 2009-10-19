package haxe.org.dassista.multicore;

import neko.FileSystem;
import neko.io.Path;
import neko.Sys;

class ModuleCompiler
{
    private var root:String;
    private var moduleEntryPoint:String;
  
  public function new(root:String,moduleEntryPoint:String)
  {
    this.root = root;
    this.moduleEntryPoint = moduleEntryPoint;
  }

  public function compile():Int
  {
    if(FileSystem.exists(root+this.moduleEntryPoint))
	{
      var workingDir:String = Path.directory(root+this.moduleEntryPoint);
      var moduleName:String = Path.withoutExtension(Path.withoutDirectory(this.moduleEntryPoint));
      var moduleClassName:String = Path.withoutExtension(this.moduleEntryPoint).split("/").join(".");
      var oldCwd:String = Sys.getCwd();
      Sys.setCwd(workingDir);
      var cmd:String = "haxe -cp "+root+" -neko " + moduleName + ".n -main " + moduleClassName;
      var result:Int = Sys.command(cmd);
      Sys.setCwd(oldCwd);
      return result;
	}
	else
		throw "can not find source code at " + this.moduleEntryPoint;
  }
}
