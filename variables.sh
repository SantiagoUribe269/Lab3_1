#!/bin/bash
# Script para practicar variables

# Variables básicas
nombre="DevOps"
version=1.0
fecha=$(date +%Y-%m-%d)

# Variable de solo lectura
declare -r CURSO="Fundamentos de DevOps"

echo "=== Información del Script ==="
echo "Nombre: $nombre"
echo "Versión: $version"
echo "Fecha: $fecha"
echo "Curso: $CURSO"

# Solicitar entrada del usuario
echo ""
echo "=== Información Personal ==="
read -p "Ingresa tu nombre: " usuario_nombre
read -p "Ingresa tu edad: " usuario_edad

echo ""
echo "Hola $usuario_nombre, tienes $usuario_edad años"
echo "Bienvenido al curso: $CURSO"