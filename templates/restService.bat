@echo off
cd .\haxe\org\dassista\
haxe -cp ..\..\..\ -main haxe.org.dassista.RestServiceContext -neko RestServiceContext.n
cd ..\..\..\
nekotools server -p 2000 -h localhost -d .\
