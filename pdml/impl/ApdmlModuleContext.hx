package haxe.org.dassista.pdml.impl;

import haxe.org.dassista.pdml.IApdmlModule;
import haxe.org.dassista.pdml.IApdmlModuleContext;
import haxe.xml.Fast;

class ApdmlModuleContext implements IApdmlModuleContext
{
	public var caller:IApdmlModule;
	public var pdml:Fast;
	public var repo:Repo;
	
	public function new(caller:IApdmlModule, pdml:Fast, repo:Repo)
	{
		this.caller = caller;
		this.pdml = pdml;
		this.repo = repo;
	}
	
	public function getCaller():IApdmlModule
	{
		return this.caller;
	}
	
	public function getPdml():Fast
	{
		return this.pdml;
	}
	
	public function getRepo():Repo
	{
		return this.repo;
	}
}