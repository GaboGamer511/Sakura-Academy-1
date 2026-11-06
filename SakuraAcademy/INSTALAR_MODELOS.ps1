$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$Project = Split-Path -Parent $MyInvocation.MyCommand.Path
$Models = Join-Path $Project "models"
$Characters = Join-Path $Models "characters"
New-Item -ItemType Directory -Force -Path $Models, $Characters | Out-Null

function Download-VerifiedFile([string]$Url, [string]$Destination, [string]$Magic) {
    if (Test-Path $Destination) {
        $existing = [System.IO.File]::ReadAllBytes($Destination)
        if ($existing.Length -gt 4096 -and [System.Text.Encoding]::ASCII.GetString($existing, 0, 4) -eq $Magic) {
            Write-Host "Ya existe y parece válido: $([IO.Path]::GetFileName($Destination))" -ForegroundColor Green
            return
        }
    }
    $temp = "$Destination.download"
    Write-Host "Descargando $([IO.Path]::GetFileName($Destination)) ..."
    Invoke-WebRequest -Uri $Url -OutFile $temp -UseBasicParsing -TimeoutSec 180
    $bytes = [System.IO.File]::ReadAllBytes($temp)
    if ($bytes.Length -lt 4096 -or [System.Text.Encoding]::ASCII.GetString($bytes, 0, 4) -ne $Magic) {
        Remove-Item $temp -Force -ErrorAction SilentlyContinue
        throw "El archivo descargado no pasó la comprobación de formato: $Destination"
    }
    Move-Item $temp $Destination -Force
}

try {
    # Pack de arquitectura japonesa modular: GLB real con 46 modelos colocados en una escena inicial.
    Download-VerifiedFile `
      "https://cdn.3dassets.dev/assets/30098/v1/model.glb" `
      (Join-Path $Models "japanese_school_campus.glb") "glTF"

    # Paquete CC0 de personajes humanos articulados, con clips Idle/Walk/Run y otros.
    $Zip = Join-Path $env:TEMP "gobkit-human001-pack.zip"
    Write-Host "Descargando paquete de personajes articulados ..."
    Invoke-WebRequest -Uri "https://gobkit.com/freebies/human001/gobkit-human001-pack.zip" -OutFile $Zip -UseBasicParsing -TimeoutSec 180
    $Extract = Join-Path $env:TEMP ("gobkit-human001-" + [Guid]::NewGuid().ToString("N"))
    New-Item -ItemType Directory -Force -Path $Extract | Out-Null
    Expand-Archive -Path $Zip -DestinationPath $Extract -Force
    $Glbs = Get-ChildItem -Path $Extract -Filter "*.glb" -Recurse
    if (-not ($Glbs | Where-Object { $_.BaseName -eq "Schoolkid" })) {
        throw "El paquete humano no contiene Schoolkid.glb. Se canceló la instalación."
    }
    foreach ($File in $Glbs) {
        Copy-Item $File.FullName (Join-Path $Characters $File.Name) -Force
    }
    Remove-Item $Zip -Force -ErrorAction SilentlyContinue
    Remove-Item $Extract -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "Modelos instalados: campus GLB + $($Glbs.Count) personajes articulados." -ForegroundColor Green
    Write-Host "Ahora abre SakuraAcademy/project.godot en Godot 3.6.3 y espera la importación." -ForegroundColor Green
} catch {
    Write-Host "No se pudieron instalar todos los modelos: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Comprueba tu conexión a Internet y vuelve a ejecutar INSTALAR_MODELOS.bat."
    exit 1
}
