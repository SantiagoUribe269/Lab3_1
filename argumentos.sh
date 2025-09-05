#!/bin/bash
# Script que maneja argumentos de línea de comandos

# Función de ayuda
mostrar_ayuda() {
    echo "Uso: $0 [OPCIONES] [ARCHIVOS]"
    echo ""
    echo "OPCIONES:"
    echo "  -h, --help     Mostrar esta ayuda"
    echo "  -v, --version  Mostrar versión"
    echo "  -c, --count    Contar archivos"
    echo "  -l, --list     Listar archivos detalladamente"
    echo ""
    echo "Ejemplos:"
    echo "  $0 -c *.txt"
    echo "  $0 --list /home/user/"
}

# Variables
VERSION="1.0"
CONTAR=false
LISTAR=false

# Procesar argumentos
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            mostrar_ayuda
            exit 0
            ;;
        -v|--version)
            echo "Versión: $VERSION"
            exit 0
            ;;
        -c|--count)
            CONTAR=true
            shift
            ;;
        -l|--list)
            LISTAR=true
            shift
            ;;
        *)
            # Archivo o directorio
            ARCHIVOS+=("$1")
            shift
            ;;
    esac
done

# Lógica principal
echo "=== Script de Análisis de Archivos ==="
echo "Argumentos recibidos: $#"
echo "Archivos a procesar: ${ARCHIVOS[@]}"

if [ ${#ARCHIVOS[@]} -eq 0 ]; then
    echo "No se especificaron archivos. Usando directorio actual."
    ARCHIVOS=(".")
fi

for archivo in "${ARCHIVOS[@]}"; do
    echo ""
    echo "Procesando: $archivo"

    if [ -f "$archivo" ]; then
        echo "  Tipo: Archivo regular"
        echo "  Tamaño: $(stat -c%s "$archivo" 2>/dev/null || stat -f%z "$archivo" 2>/dev/null) bytes"
    elif [ -d "$archivo" ]; then
        echo "  Tipo: Directorio"
        archivo_count=$(ls -1 "$archivo" 2>/dev/null | wc -l)
        echo "  Contenido: $archivo_count elementos"

        if [ "$CONTAR" = true ]; then
            echo "  Conteo detallado:"
            echo "    Archivos: $(find "$archivo" -type f 2>/dev/null | wc -l)"
            echo "    Directorios: $(find "$archivo" -type d 2>/dev/null | wc -l)"
        fi

        if [ "$LISTAR" = true ]; then
            echo "  Listado:"
            ls -la "$archivo" 2>/dev/null | head -10
        fi
    else
        echo "  Error: No existe o no es accesible"
    fi
done