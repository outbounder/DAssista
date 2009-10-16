package org.dassista.pdml;
import haxe.xml.Fast;
import neko.io.File;

class APDMLProcessor
{
	private var pdmlPath:String;
	private var pdmlContent:String;
	private var pdml:Fast;
		
	public function new(pdml:String)
	{
		this.pdml = pdml;	
	}
	
	public function process():Bool
	{
		this.pdmlContent = File.read(this.pdmlPath);
		var xml = Xml.parse(this.pdmlContent);
		this.pdml = new Fast(xml.firstElement());
		
		
	}
}