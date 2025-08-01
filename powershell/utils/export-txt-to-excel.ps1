# Variable donde debe indicar el archivo de entrada y el archivo de salida
$inputFile = "C:\Files\apps-VMS-FC-P014.txt"
$outputFile = "C:\Files\apps-VMS-FC-P014.xlsx"

# Leer el archivo delimitado por '|'
$data = Import-Csv -Path $inputFile -Delimiter '|'

# Exportar a Excel (requiere módulo ImportExcel)
$data | Export-Excel -Path $outputFile -AutoSize
