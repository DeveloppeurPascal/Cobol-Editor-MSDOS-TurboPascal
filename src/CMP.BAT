@echo off
set code=edco
del *.tpu
tpc ed_cobol 
lha a c:\olf_soft\lzh\%code% ed_cobol.doc ed_cobol.exe
set code=
echo on
