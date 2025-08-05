# Mostrar contenido actual del archivo hosts
Write-Host "Contenido actual del archivo hosts:`n"
Get-Content C:\Windows\System32\drivers\etc\hosts

# Solicitar datos al usuario
$ip = "179.0.2.195"
$dns = "login-qa.web.cl"

# Validar entrada
if ([string]::IsNullOrWhiteSpace($ip) -or [string]::IsNullOrWhiteSpace($dns)) {
    Write-Host "IP y nombre DNS son requeridos." -ForegroundColor Red
    exit 1
}

# Verificar si el registro ya existe
$registro = "$ip`t$dns"
$existe = Select-String -Path C:\Windows\System32\drivers\etc\hosts -Pattern "$ip\s+$dns"
if ($existe) {
    Write-Host "El registro ya existe en el archivo hosts." -ForegroundColor Yellow
    exit 0
}

# Agregar el registro
$registro | Out-File -FilePath C:\Windows\System32\drivers\etc\hosts -Encoding ASCII -Append
Write-Host "Registro DNS agregado correctamente." -

##