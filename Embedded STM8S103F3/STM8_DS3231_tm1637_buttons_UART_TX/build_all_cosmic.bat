@echo off
:: ==========================================
:: Build script for STM8 project using COSMIC
:: Author       : Denys Navrotskyi <navrotskyi@kai.edu.ua>
:: Description  : Compiles all .c files and links them into .sm8 firmware.
::                Also manages build folder and moves .o files to /build.
:: Tools        : COSMIC CXSTM8 compiler, CLNK linker
:: Target MCU   : STM8S103F3
:: Created      : 2025
:: ==========================================

set COMPILE=cxstm8 +debug -iinc -l -noopt
::set COMPILE=cxstm8 -pp +mods0 -iinc 

:: очистка і створення папки build
echo Cleaning build folder...
@if exist build rmdir /s /q build
@mkdir build

echo Building project...
echo Building .o and .ls files...
%COMPILE% main.c
%COMPILE% stm8_interrupt_vector.c

%COMPILE% src\button.c
%COMPILE% src\ds3231Time.c
%COMPILE% src\tm1637.c
%COMPILE% src\uartTX.c

move *.o build\
move src\*.o build\

move *.ls build\
move src\*.ls build\

echo Building main.sm8 file...
copy main.lkf build\
:: створити main.sm8 та main.map по правилам прописаним в main.lkf:
clnk -o build\main.sm8 -m build\main.map build\main.lkf

echo Building main.hex file...
:: Створення файлу прошивки hex (у форматі Intel HEX) з файлу sm8:
chex -fi -o build/main.hex build/main.sm8

echo Building main.ihx file...
:: Створення файлу прошивки ihx з файлу sm8:
chex -o build/main.ihx build/main.sm8

echo Building main.elf file...
:: Створили файлу main.elf з файлу sm8:
cvdwarf.exe -o build/main.elf -v build/main.sm8

echo Done!

