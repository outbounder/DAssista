package haxe.org.dassista.multicore;

import neko.FileSystem;
import neko.io.Path;

class ModuleCompiler
{
  private var moduleEntryPoint;
  private var root:String;
  
  public function new(root:String, moduleEntryPoint:String)
  {
    this.root = root;
    this.moduleEntryPoint = moduleEntryPoint;
  }

  public function compile():String
  {
    if(FileSystem.exists(this.moduleEntryPoint))
		{
		  var workingDir:String = Path.directory(this.moduleEntryPoint);
      var moduleName =  Path.withoutExtension(Path.withoutDirectory(this.moduleEntryPoint));
			var oldCwd:String = Sys.getCwd();
			Sys.setCwd(workingDir);
			var cmd:String = "haxe -cp " + this.root + " -neko " + moduleName + ".n -main " + moduleName;
			Sys.command(cmd);
			Sys.setCwd(oldCwd);
		}
		else
			throw "can not find source code at " + this.moduleEntryPoint;
  }
}
