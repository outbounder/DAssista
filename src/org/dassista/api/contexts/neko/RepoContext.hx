package org.dassista.api.contexts.neko;

import neko.io.Path;
import neko.FileSystem;

class RepoContext extends Context
{
	public function new()
	{
		super();
	}
	
	public function setRootFolder(value:String):Void
	{
		this.set("rootFolder", value);
	}	
	
	public function getRootFolder():String
	{
		return this.get("rootFolder");
	}
	
	public function getRealPathTreeList(target:String, extension:String):Array<String>
	{
		target = this.getRealPath(target);
		var result:Array<String> = new Array();
		var entries:Array<String> = FileSystem.readDirectory(target);
		for (entry in entries)
		{
			if (FileSystem.kind(target+"\\"+entry) == FileKind.kdir)
			{
				var files:Array<String> = this.getRealPathTreeList(target + "\\" + entry, extension);
				for(file in files)
					result.push(file);
			}
			else if(Path.extension(entry) == extension)
			{
				result.push(target + "\\" + entry);
			}
		}
		return result;
	}
	
	public function getRealPath(target:String):String
	{
		if (target.indexOf(":") != -1)
			return target; // it is full path
			
		if (target.indexOf("/") == -1)
			target = target.split(".").join("/");  // it is class name path style, convert to file system.
		if (target.indexOf("./") == 0)
			target = target.substr(2); // remove the relative prefix
		var result:String = this.getRootFolder() + target;
		result = result.split("/").join("\\"); // workaround slashes
		// remove last slash
		if (result.charAt(result.length - 1) == "\\") // to be changed
			return result.substr(0, result.length - 1);
		else
			return result;
	}
	
	public function getClassPath(target:String):String
	{
		// full/relative path with extension is not permitted for class paths.
		if(target.indexOf(".") != -1 && (target.indexOf(":") != -1 || target.indexOf("./") != -1)) 
			target = Path.withoutExtension(target);
		if (target.indexOf("./") == 0)
			target = target.substr(3, target.length - 2);
		target = target.split("/").join("\\"); // workaround slashes
		if (target.indexOf(this.getRootFolder()) != -1)
			target = target.split(this.getRootFolder())[1]; // remove the root folder
		if (target.indexOf("\\") == 0)
			target = target.substr(1); // remove starting repo root slash
		if (target.indexOf(":") != -1)
			throw "can not convert full path outside of repo to classpath " + target+" at repo "+this.getRootFolder();
		return target.split("\\").join(".");
	}
}