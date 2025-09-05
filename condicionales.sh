#!/bin/bash
# Script para practicar condicionales

# Función para verificar archivos
verificar_archivo() {
    local archivo=$1

    echo "Verificando: $archivo"

    if [ -e "$archivo" ]; then
        echo "  ✓ El archivo existe"

        if [ -f "$archivo" ]; then
            echo "  ✓ Es un archivo regular"

            if [ -r "$archivo" ]; then
                echo "  ✓ Es legible"
            else
                echo "  ✗ No es legible"
            fi

            if [ -w "$archivo" ]; then
                echo "  ✓ Es escribible"
            else
                echo "  ✗ No es escribible"
            fi

            if [ -x "$archivo" ]; then
                echo "  ✓ Es ejecutable"
            else
                echo "  ✗ No es ejecutable"
            fi

        elif [ -d "$archivo" ]; then
            echo "  ✓ Es un directorio"
        fi

    else
        echo "  ✗ El archivo no existe"
    fi
    echo ""
}

# Función para evaluar números
evaluar_numero() {
    local num=$1

    echo "Evaluando número: $num"

    if [[ ! "$num" =~ ^[0-9]+$ ]]; then
        echo "  ✗ No es un número válido"
        return 1
    fi

    if [ $num -eq 0 ]; then
        echo "  = El número es cero"
    elif [ $num -gt 0 ]; then
        echo "  + El número es positivo"

        if [ $num -gt 100 ]; then
            echo "  ! El número es mayor a 100"
        fi

    else
        echo "  - El número es negativo"
    fi

    # Verificar si es par o impar
    if [ $((num % 2)) -eq 0 ]; then
        echo "  ⚹ El número es par"
    else
        echo "  ⚹ El número es impar"
    fi
    echo ""
}

# Función principal
echo "=== Script de Condicionales ==="
echo ""

# Verificar archivos del sistema
verificar_archivo "/etc/passwd"
verificar_archivo "/tmp"
verificar_archivo "./hello.sh"
verificar_archivo "/archivo_inexistente"

# Evaluar números
evaluar_numero "42"
evaluar_numero "0"
evaluar_numero "101"
evaluar_numero "-5"
evaluar_numero "abc"

# Ejemplo con case
echo "=== Ejemplo con Case ==="
for dia in lunes martes miércoles jueves viernes sábado domingo; do
    case $dia in
        lunes|martes|miércoles|jueves|viernes)
            echo "$dia: Día de trabajo 💼"
            ;;
        sábado|domingo)
            echo "$dia: Fin de semana 🎉"
            ;;
        *)
            echo "$dia: Día desconocido ❓"
            ;;
    esac
done