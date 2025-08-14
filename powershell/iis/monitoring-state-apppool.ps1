# Nombre del sitio y del Application Pool
$siteName = "nombresitio"
$appPoolName = "poolname"
$logPath = "C:\Logs\monitoring_log.txt"  # Cambia la ruta si lo necesitas

# Crear carpeta si no existe
$logFolder = Split-Path $logPath
if (!(Test-Path $logFolder)) {
    New-Item -ItemType Directory -Path $logFolder | Out-Null
}

# Obtener estado del sitio
$site = Get-Website -Name $siteName
$siteState = $site.State

# Obtener estado del Application Pool
$appPool = Get-WebAppPoolState -Name $appPoolName
$appPoolState = $appPool.Value

# Obtener uso de recursos del proceso w3wp
$w3wp = Get-Process w3wp -ErrorAction SilentlyContinue
if ($w3wp) {
    $cpu = ($w3wp | Measure-Object CPU -Sum).Sum
    $mem = ($w3wp | Measure-Object WorkingSet -Sum).Sum / 1MB
} else {
    $cpu = "No activo"
    $mem = "No activo"
}

# Obtener eventos recientes de reciclaje
$events = Get-WinEvent -LogName "System" | Where-Object {
    $_.ProviderName -eq "Microsoft-Windows-WAS" -and $_.Message -like "*$appPoolName*"
} | Select-Object -First 5

# Construir contenido del log
$log = @()
$log += "Fecha de monitoreo: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
$log += "Estado del sitio '$siteName': $siteState"
$log += "Estado del Application Pool '$appPoolName': $appPoolState"
$log += "Uso total de CPU por w3wp: $cpu segundos"
$log += "Uso total de memoria por w3wp: $mem MB"
$log += "`nEventos recientes de reciclaje del App Pool:"
foreach ($evento in $events) {
    $log += "$($evento.TimeCreated) - $($evento.Message)"
}

# Escribir en archivo
$log | Out-File -FilePath $logPath -Encoding UTF8 -Append
