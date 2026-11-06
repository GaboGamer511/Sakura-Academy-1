@echo off
setlocal EnableExtensions EnableDelayedExpansion
chcp 65001 >nul
title Sakura Academy - Instalador de modelos 3D

cd /d "%~dp0"
if not exist "models" mkdir "models"
if not exist "_descargas" mkdir "_descargas"

echo.
echo ================================================
echo       SAKURA ACADEMY - RECURSOS 3D
echo ================================================
echo.
echo Este instalador NO crea modelos ni escenarios.
echo Extrae archivos ZIP que hayas descargado y revisado.
echo Usa modelos 3D reales compatibles con Godot 3.6.3.
echo.

set "FOUND=0"
for %%Z in ("_descargas\*.zip") do (
    if exist "%%~fZ" (
        set "FOUND=1"
        echo Extrayendo: %%~nxZ
        powershell -NoProfile -ExecutionPolicy Bypass -Command "Expand-Archive -LiteralPath '%%~fZ' -DestinationPath 'models\%%~nZ' -Force"
        if errorlevel 1 (
            echo ERROR al extraer %%~nxZ
        ) else (
            echo Listo: models\%%~nZ
        )
        echo.
    )
)

if "!FOUND!"=="0" (
    echo No se encontraron ZIP en _descargas.
    echo.
    echo Descarga paquetes 3D con licencia compatible y coloca
    echo sus archivos ZIP en esta carpeta antes de ejecutar el BAT.
)

echo.
echo Modelos GLB/GLTF encontrados tras la extraccion:
for /r "models" %%F in (*.glb *.gltf) do echo %%F
echo.
echo IMPORTANTE:
echo - No descargues ni instales modelos low poly como estilo artistico.
echo - Revisa la calidad, licencia, formato y tamano de cada paquete.
echo - El cerezo de Innerscene anterior fue descartado.
echo - No se han incluido modelos automaticamente en el repositorio.
echo.
echo Abre project.godot con Godot 3.6.3 para importar los recursos.
echo Revisa DESCARGA_MODELOS.md para fuentes, nombres y reconocimiento automatico.
echo Revisa AMBIENTE_VISUAL.md y SAKURA_ASSETS.md.
echo.
pause
endlocal
