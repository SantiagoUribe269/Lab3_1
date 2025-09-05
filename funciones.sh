#!/bin/bash
# Script con funciones

# Función para mostrar información del sistema
mostrar_sistema() {
    echo "=== Información del Sistema ==="
    echo "Fecha: $(date)"
    echo "Uptime: $(uptime -p 2>/dev/null || uptime)"
    echo "Usuarios conectados: $(who | wc -l)"
    echo "Uso de disco:"
    df -h | head -5
}

# Función con parámetros
saludar() {
    local nombre=$1
    local edad=$2

    if [ -z "$nombre" ]; then
        nombre="Usuario"
    fi

    echo "¡Hola $nombre!"
    if [ ! -z "$edad" ]; then
        echo "Tienes $edad años"
    fi
}

# Función para calcular
calcular() {
    local num1=$1
    local operacion=$2
    local num2=$3

    case $operacion in
        "+")
            resultado=$((num1 + num2))
            ;;
        "-")
            resultado=$((num1 - num2))
            ;;
        "*")
            resultado=$((num1 * num2))
            ;;
        "/")
            if [ $num2 -ne 0 ]; then
                resultado=$((num1 / num2))
            else
                echo "Error: División por cero"
                return 1
            fi
            ;;
        *)
            echo "Operación no válida: $operacion"
            return 1
            ;;
    esac

    echo "Resultado: $num1 $operacion $num2 = $resultado"
}

# Ejecutar funciones
mostrar_sistema
echo ""
saludar "Ana" "25"
echo ""
saludar "Carlos"
echo ""
calcular 10 "+" 5
calcular 20 "*" 3
calcular 15 "/" 3