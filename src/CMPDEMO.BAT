@echo off
set code=demoedco
del *.tpu
tpc ed_cobol /ddemo_vers
lha a c:\olf_soft\lzh\%code% ed_cobol.doc ed_cobol.exe
set code=
echo on
