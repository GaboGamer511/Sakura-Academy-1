@echo off
chcp 65001 >nul
setlocal
cd /d "%~dp0"

echo ==========================================
echo   Descarga de assets libres (CC0)
echo ==========================================
echo.

if not exist models mkdir models
if not exist _descargas mkdir _descargas

rem Compatibilidad con la version anterior del script
if exist "models\muebles" if not exist "models\kenney_furniturePack" ren "models\muebles" "kenney_furniturePack"

rem Uso: call :bajar  archivo.zip  URL_directa  carpeta_destino  pagina_de_respaldo
call :bajar "kenney_furniturePack.zip" "https://opengameart.org/sites/default/files/kenney_furniturePack.zip" "models\kenney_furniturePack" "https://opengameart.org/content/furniture-kit"

echo.
echo ------------------------------------------
echo Descomprimiendo todo .zip de _descargas que aun no este en models\ ...
echo ------------------------------------------
powershell -NoProfile -Command "Get-ChildItem -LiteralPath '_descargas' -Filter *.zip | ForEach-Object { $n = ($_.BaseName -replace '[\[\]]',''); $dest = Join-Path 'models' $n; if (-not (Test-Path -LiteralPath $dest)) { Write-Host ('Extrayendo ' + $_.Name); Expand-Archive -LiteralPath $_.FullName -DestinationPath $dest -Force } else { Write-Host ('Ya extraido: ' + $_.Name) } }"

echo.
echo Ajustes para que Godot importe rapido: se ignoran packs que la beta aun no usa...
for /d %%D in (models\kenney_modular*) do if not exist "%%D\.gdignore" type nul > "%%D\.gdignore"
for /d %%D in (models\Universal*Animation*) do if not exist "%%D\.gdignore" type nul > "%%D\.gdignore"
if exist ".import" echo (Godot ya tiene una cache de importacion; solo reimportara lo nuevo)
echo.
echo Si te faltan packs, descargalos de estas paginas, ponlos en _descargas y
echo ejecuta este archivo otra vez:
echo   https://kenney-assets.itch.io/modular-buildings
echo   https://quaternius.com/packs/universalbasecharacters.html
echo   https://quaternius.com/packs/universalanimationlibrary.html
echo.
echo Listo. Abre Godot y deja que reimporte los archivos.
pause
goto :eof

:bajar
if exist "%~3" (
  echo Ya existe %~3, se omite la descarga de %~1
  exit /b
)
echo Descargando %~1 ...
powershell -NoProfile -Command "[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; try { Invoke-WebRequest -Uri '%~2' -OutFile '_descargas\%~1' -UseBasicParsing; if ((Get-Item -LiteralPath '_descargas\%~1').Length -lt 100000) { exit 1 } } catch { exit 1 }"
if errorlevel 1 (
  echo [!] No se pudo descargar %~1 automaticamente. Abriendo la pagina...
  del "_descargas\%~1" >nul 2>&1
  start "" "%~4"
  exit /b
)
powershell -NoProfile -Command "Expand-Archive -LiteralPath '_descargas\%~1' -DestinationPath '%~3' -Force"
echo [OK] %~1 -^> %~3
exit /b
