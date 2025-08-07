# Este script realiza los siguientes pasos:
# 1. Busca si algún proceso está utilizando el puerto 8090 mediante netstat y findstr.
netstat -ano | findstr :8090

# 2. Asigna manualmente el PID del proceso encontrado al valor de $processId.
$processId = 1234

# 3. Busca el nombre del servicio asociado al PID utilizando Get-CimInstance.
Get-CimInstance -ClassName Win32_Service | Where-Object {$_.ProcessId -eq $processId}

# 4. Detiene el servicio encontrado usando Stop-Service y el nombre del servicio.
Stop-Service -Name "NombreDelServicio"