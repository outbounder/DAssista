@echo off
REM remove this dependency
haxe -cp E:/pd-repo/ -main haxe.org.dassista.DAssista -neko DAssista.n 
nekotools boot DAssista.n
DAssista.exe %*
