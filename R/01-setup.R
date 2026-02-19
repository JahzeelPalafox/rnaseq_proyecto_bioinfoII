##-------------------------------------------------------------------------
## Proyecto: rnaseq_proyecto_bioinfoII
## Script: 01-setup.R
## Propósito: Configurar la estructura de carpetas del proyecto
## Autor: Jahzeel
## Fecha: 2026-02-16
##-------------------------------------------------------------------------
## 1. Cargar librerías necesarias
## 'here' es vital para la reproducibilidad ya que gestiona rutas relativas
library("here")
## 2. Definir y crear la estructura de directorios
## Estas carpetas siguen el estándar de organización del curso
# Plots generados
dir.create(here::here("plots"), showWarnings = FALSE)
# Resultados y tablas generadas
dir.create(here::here("results"), showWarnings = FALSE)

## 3. Mensajes de confirmación y verificación de ruta
## Esto ayuda a verificar si el proyecto se abrió en el lugar correcto
message("¡Estructura de carpetas creada exitosamente!")
print(paste("La raíz del proyecto es:", here::here()))

