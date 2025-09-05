#!/bin/bash
# Script para explorar variables de entorno

echo "=== Variables de Entorno ==="
echo "Usuario: $USER"
echo "Directorio home: $HOME"
echo "Shell actual: $SHELL"
echo "PATH: $PATH"
echo ""

# Crear variable de entorno personalizada
export MI_VARIABLE="Laboratorio DevOps"
echo "Variable personalizada: $MI_VARIABLE"

# Mostrar todas las variables de entorno
echo ""
echo "=== Primeras 10 variables de entorno ==="
env | head -10