#!/bin/bash
# Script de automatización para Galaxy Marketplace

# Configuración
REPO_URL="https://github.com/wils0n/Galaxy-Marketplace-Example-App.git"
PROJECT_NAME="Galaxy-Marketplace-Example-App"
ENV_SOURCE="../environments/.env"

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para mostrar mensajes con colores
mostrar_mensaje() {
    local tipo=$1
    local mensaje=$2

    case $tipo in
        "info")
            echo -e "${BLUE}[INFO]${NC} $mensaje"
            ;;
        "success")
            echo -e "${GREEN}[SUCCESS]${NC} $mensaje"
            ;;
        "warning")
            echo -e "${YELLOW}[WARNING]${NC} $mensaje"
            ;;
        "error")
            echo -e "${RED}[ERROR]${NC} $mensaje"
            ;;
    esac
}

# Función para verificar si un comando existe
verificar_comando() {
    local comando=$1
    if ! command -v $comando &> /dev/null; then
        mostrar_mensaje "error" "El comando '$comando' no está instalado"
        return 1
    fi
    return 0
}

# Función para verificar dependencias
verificar_dependencias() {
    mostrar_mensaje "info" "Verificando dependencias..."

    local dependencias=("git" "node" "npm")
    local faltan=()

    for dep in "${dependencias[@]}"; do
        if ! verificar_comando $dep; then
            faltan+=($dep)
        fi
    done

    if [ ${#faltan[@]} -ne 0 ]; then
        mostrar_mensaje "error" "Faltan las siguientes dependencias: ${faltan[*]}"
        mostrar_mensaje "info" "Por favor instala las dependencias faltantes:"
        for dep in "${faltan[@]}"; do
            case $dep in
                "git")
                    echo "  - Git: https://git-scm.com/downloads"
                    ;;
                "node"|"npm")
                    echo "  - Node.js (incluye npm): https://nodejs.org/"
                    ;;
            esac
        done
        return 1
    fi

    mostrar_mensaje "success" "Todas las dependencias están instaladas"
    return 0
}

# Función para clonar el repositorio
clonar_repositorio() {
    mostrar_mensaje "info" "Clonando repositorio Galaxy Marketplace..."

    # Verificar si el directorio ya existe
    if [ -d "$PROJECT_NAME" ]; then
        mostrar_mensaje "warning" "El directorio '$PROJECT_NAME' ya existe"
        read -p "¿Deseas eliminarlo y clonar de nuevo? (y/N): " respuesta
        case $respuesta in
            [Yy]*)
                rm -rf "$PROJECT_NAME"
                mostrar_mensaje "info" "Directorio eliminado"
                ;;
            *)
                mostrar_mensaje "info" "Usando directorio existente"
                return 0
                ;;
        esac
    fi

    # Clonar el repositorio
    if git clone "$REPO_URL"; then
        mostrar_mensaje "success" "Repositorio clonado exitosamente"
        return 0
    else
        mostrar_mensaje "error" "Error al clonar el repositorio"
        return 1
    fi
}

# Función para instalar dependencias npm
instalar_dependencias_npm() {
    mostrar_mensaje "info" "Instalando dependencias de Node.js..."

    if [ ! -d "$PROJECT_NAME" ]; then
        mostrar_mensaje "error" "Directorio del proyecto no encontrado"
        return 1
    fi

    cd "$PROJECT_NAME"

    if [ ! -f "package.json" ]; then
        mostrar_mensaje "error" "archivo package.json no encontrado"
        return 1
    fi

    if npm install; then
        mostrar_mensaje "success" "Dependencias instaladas exitosamente"
        cd ..
        return 0
    else
        mostrar_mensaje "error" "Error al instalar dependencias"
        cd ..
        return 1
    fi
}

# Función para configurar variables de entorno
configurar_env() {
    mostrar_mensaje "info" "Configurando variables de entorno..."

    cd "$PROJECT_NAME"

    # Verificar si existe .env.example
    if [ ! -f ".env.example" ]; then
        mostrar_mensaje "error" "Archivo .env.example no encontrado"
        cd ..
        return 1
    fi

    # Copiar archivo de ejemplo
    if cp .env.example .env; then
        mostrar_mensaje "success" "Archivo .env creado desde .env.example"
    else
        mostrar_mensaje "error" "Error al crear archivo .env"
        cd ..
        return 1
    fi

    # Verificar si existe archivo de entorno en directorio padre
    if [ -f "$ENV_SOURCE" ]; then
        mostrar_mensaje "info" "Encontrado archivo de entorno en $ENV_SOURCE"
        read -p "¿Deseas usar este archivo de entorno? (Y/n): " usar_env
        case $usar_env in
            [Nn]*)
                mostrar_mensaje "info" "Usando archivo .env por defecto"
                ;;
            *)
                if cp "$ENV_SOURCE" .env; then
                    mostrar_mensaje "success" "Variables de entorno copiadas desde $ENV_SOURCE"
                else
                    mostrar_mensaje "warning" "Error al copiar variables de entorno, usando .env por defecto"
                fi
                ;;
        esac
    else
        mostrar_mensaje "warning" "Archivo de entorno no encontrado en $ENV_SOURCE"
        mostrar_mensaje "info" "Necesitarás configurar manualmente las variables en .env:"
        echo "  - LD_SDK_KEY=sdk-xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
        echo "  - LD_EVENT_KEY=tbd-lab"
    fi

    cd ..
    return 0
}

# Función para mostrar el estado del archivo .env
mostrar_env_status() {
    mostrar_mensaje "info" "Estado del archivo .env:"

    cd "$PROJECT_NAME"

    if [ -f ".env" ]; then
        echo "Contenido actual del archivo .env:"
        echo "=================================="
        cat .env
        echo "=================================="

        # Verificar si las variables críticas están configuradas
        if grep -q "LD_SDK_KEY=sdk-" .env && grep -q "LD_EVENT_KEY=" .env; then
            mostrar_mensaje "success" "Variables de entorno configuradas correctamente"
        else
            mostrar_mensaje "warning" "Algunas variables importantes pueden no estar configuradas"
        fi
    else
        mostrar_mensaje "error" "Archivo .env no encontrado"
    fi

    cd ..
}

# Función para iniciar la aplicación
iniciar_aplicacion() {
    mostrar_mensaje "info" "Iniciando la aplicación Galaxy Marketplace..."

    cd "$PROJECT_NAME"

    # Verificar que package.json tiene el script dev
    if ! grep -q '"dev"' package.json; then
        mostrar_mensaje "error" "Script 'dev' no encontrado en package.json"
        cd ..
        return 1
    fi

    mostrar_mensaje "info" "Ejecutando 'npm run dev'..."
    mostrar_mensaje "warning" "La aplicación se iniciará. Usa Ctrl+C para detenerla."
    mostrar_mensaje "info" "Una vez iniciada, probablemente estará disponible en http://localhost:3000"

    # Dar tiempo al usuario para leer los mensajes
    sleep 3

    # Ejecutar el comando
    npm run dev

    cd ..
}

# Función de ayuda
mostrar_ayuda() {
    echo "Script de automatización para Galaxy Marketplace"
    echo ""
    echo "Uso: $0 [OPCIONES]"
    echo ""
    echo "OPCIONES:"
    echo "  -h, --help       Mostrar esta ayuda"
    echo "  -c, --clone      Solo clonar repositorio"
    echo "  -i, --install    Solo instalar dependencias"
    echo "  -e, --env        Solo configurar variables de entorno"
    echo "  -s, --start      Solo iniciar aplicación"
    echo "  --status         Mostrar estado del proyecto"
    echo "  --full          Ejecutar configuración completa (por defecto)"
    echo ""
    echo "Ejemplos:"
    echo "  $0               # Configuración completa automática"
    echo "  $0 --clone       # Solo clonar el repositorio"
    echo "  $0 --install     # Solo instalar dependencias"
    echo "  $0 --status      # Mostrar estado actual"
}

# Función principal de configuración completa
configuracion_completa() {
    mostrar_mensaje "info" "Iniciando configuración completa de Galaxy Marketplace"
    echo ""

    # Paso 1: Verificar dependencias
    if ! verificar_dependencias; then
        return 1
    fi
    echo ""

    # Paso 2: Clonar repositorio
    if ! clonar_repositorio; then
        return 1
    fi
    echo ""

    # Paso 3: Instalar dependencias
    if ! instalar_dependencias_npm; then
        return 1
    fi
    echo ""

    # Paso 4: Configurar variables de entorno
    if ! configurar_env; then
        return 1
    fi
    echo ""

    # Paso 5: Mostrar estado
    mostrar_env_status
    echo ""

    mostrar_mensaje "success" "¡Configuración completa exitosa!"
    mostrar_mensaje "info" "Para iniciar la aplicación ejecuta:"
    echo "  cd $PROJECT_NAME"
    echo "  npm run dev"
    echo ""

    read -p "¿Deseas iniciar la aplicación ahora? (Y/n): " iniciar_now
    case $iniciar_now in
        [Nn]*)
            mostrar_mensaje "info" "Aplicación lista para iniciar manualmente"
            ;;
        *)
            iniciar_aplicacion
            ;;
    esac
}

# Función para mostrar estado del proyecto
mostrar_estado() {
    mostrar_mensaje "info" "Estado del proyecto Galaxy Marketplace:"
    echo ""

    # Verificar si existe el directorio
    if [ -d "$PROJECT_NAME" ]; then
        mostrar_mensaje "success" "Directorio del proyecto: ✓ Existe"

        cd "$PROJECT_NAME"

        # Verificar node_modules
        if [ -d "node_modules" ]; then
            mostrar_mensaje "success" "Dependencias: ✓ Instaladas"
        else
            mostrar_mensaje "warning" "Dependencias: ✗ No instaladas"
        fi

        # Verificar .env
        if [ -f ".env" ]; then
            mostrar_mensaje "success" "Archivo .env: ✓ Existe"
            mostrar_env_status
        else
            mostrar_mensaje "warning" "Archivo .env: ✗ No existe"
        fi

        cd ..
    else
        mostrar_mensaje "warning" "Directorio del proyecto: ✗ No existe"
    fi
}

# Variables de control
SOLO_CLONAR=false
SOLO_INSTALAR=false
SOLO_ENV=false
SOLO_INICIAR=false
MOSTRAR_ESTADO=false
CONFIGURACION_COMPLETA=true

# Procesar argumentos
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            mostrar_ayuda
            exit 0
            ;;
        -c|--clone)
            CONFIGURACION_COMPLETA=false
            SOLO_CLONAR=true
            shift
            ;;
        -i|--install)
            CONFIGURACION_COMPLETA=false
            SOLO_INSTALAR=true
            shift
            ;;
        -e|--env)
            CONFIGURACION_COMPLETA=false
            SOLO_ENV=true
            shift
            ;;
        -s|--start)
            CONFIGURACION_COMPLETA=false
            SOLO_INICIAR=true
            shift
            ;;
        --status)
            CONFIGURACION_COMPLETA=false
            MOSTRAR_ESTADO=true
            shift
            ;;
        --full)
            CONFIGURACION_COMPLETA=true
            shift
            ;;
        *)
            mostrar_mensaje "error" "Opción desconocida: $1"
            mostrar_ayuda
            exit 1
            ;;
    esac
done

# Ejecutar según parámetros
if [ "$MOSTRAR_ESTADO" = true ]; then
    mostrar_estado
elif [ "$SOLO_CLONAR" = true ]; then
    verificar_dependencias && clonar_repositorio
elif [ "$SOLO_INSTALAR" = true ]; then
    instalar_dependencias_npm
elif [ "$SOLO_ENV" = true ]; then
    configurar_env
elif [ "$SOLO_INICIAR" = true ]; then
    iniciar_aplicacion
elif [ "$CONFIGURACION_COMPLETA" = true ]; then
    configuracion_completa
fi