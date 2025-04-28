@echo off

set "COMPILE=cxstm8 +debug -l -noopt"
set "BUILD_OK=1"
set "BUILD_DIR=build"

:: очистка і створення папки build
echo Cleaning build folder...
@if exist build rmdir /s /q build
@mkdir build

:: pause

REM === Create build folder if it doesn't exist ===
if not exist build (
    mkdir build
)

REM === Find and copy all .c and .h files from current folder and all subfolders ===
for /R %%f in (*.c *.h) do (
    copy "%%f" build\
)

echo All .c and .h files have been copied to the build folder.
:: pause

echo Building project...
echo Building .o and .ls files...

for %%f in (build\*.c) do (
    echo Compiling: %%~nxf
    %COMPILE% "%%f" >nul 2>&1
    if errorlevel 1 (
        echo ERROR compiling %%~nxf
        echo Showing detailed output:
        @echo on
        %COMPILE% "%%f"
        @echo off
        set "BUILD_OK=0"
    )
)

if "%BUILD_OK%"=="1" (
    echo.
    echo =========================
    echo Build finished successfully!
    echo =========================
    echo List of generated .o files:
    echo --------------------------------
    dir /b "%BUILD_DIR%\*.o"
    echo --------------------------------
) else (
    echo.
    echo =========================
    echo Build finished with errors!
    echo =========================
    :: pause
    exit /b 1
)

echo Compilation finished.
:: pause

echo Building main.sm8 file...
copy tools\main.lkf build\
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
:: pause

if exist %BUILD_DIR% (
    del /q "%BUILD_DIR%\*.o"
    del /q "%BUILD_DIR%\*.h"
    del /q "%BUILD_DIR%\*.c"
) else (
    echo Folder %BUILD_DIR% not found.
)