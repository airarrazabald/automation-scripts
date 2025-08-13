$destinationRoot = "E:\Destino"  # Cambia esto por la ruta donde se crearán las carpetas

$pathsToSearch = @(

    "E:\websites\apitest"
)

# Recorrer cada ruta para buscar y copiar los archivos de configuración
foreach ($path in $pathsToSearch) {
    # Validar que la ruta de origen exista
    if (-not (Test-Path -Path $path -PathType Container)) {
        Write-Warning "La ruta '$path' no existe o no es una carpeta. Se omitirá."
        continue
    }

    # Buscar los archivos de configuración en la ruta actual
    $files = Get-ChildItem -Path $path -Recurse -Include "appsettings.json", "web.config" -File -ErrorAction SilentlyContinue

    if ($files.Count -eq 0) {
        Write-Host "No se encontraron archivos de configuración en '$path'."
        continue
    }

    # Usar el nombre de la carpeta raíz de búsqueda como nombre para la carpeta de destino
    $parentFolderName = (Split-Path -Path $path -Leaf)
    $destinationFolder = Join-Path -Path $destinationRoot -ChildPath $parentFolderName

    # Crear carpeta de destino si no existe
    if (-not (Test-Path -Path $destinationFolder)) {
        New-Item -Path $destinationFolder -ItemType Directory -Force | Out-Null
    }

    # Copiar cada archivo encontrado a la carpeta de destino
    foreach ($file in $files) {
        Write-Host "Copiando '$($file.FullName)' a '$destinationFolder'..."
        Copy-Item -Path $file.FullName -Destination $destinationFolder -Force
        Write-Host "Copiado exitosamente en '$destinationFolder'."
    }
}
