# scripts deben ejecutarse de forma secuencial despues de terminar uno se puede ejecutar el siguiente
# Previo a ejecutar script verificar si existe winget activo
winget

# busco la versiones de python disponibles
winget search python

#selecciono la versión a instalar
winget install Python 3.12 -e

#comprobar si esta instalado
python --version
pip --version