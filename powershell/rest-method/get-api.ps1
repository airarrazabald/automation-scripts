
# -Uri = URL del endpoint
# Ejecutar la solicitud GET
# Invoke-RestMethod -Uri $url -Method Get
# Mostrar la respuesta en formato json con una profundidad de 10 hijos del json
# ConvertTo-Json -Depth 10

Invoke-RestMethod -Uri "https://web.tudominio.cl/api/backoffice/appshell/microfront" -Method Get | ConvertTo-Json -Depth 10
