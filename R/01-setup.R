##-------------------------------------------------------------------------
## Proyecto: rnaseq_proyecto_bioinfoII
## Script: 01-setup.R
## Propósito: Configurar la estructura de carpetas del proyecto y el entorno
## Autor: Jahzeel
## Fecha: 2026-02-16
##-------------------------------------------------------------------------
## 1. Cargar librerías necesarias
## 'here' es vital para la reproducibilidad ya que gestiona rutas relativas
library("here")
## 2. Definir y crear la estructura de directorios
## Estas carpetas siguen el estándar de organización del curso
# Datos crudos
dir.create(here::here("data"), showWarnings = FALSE)
# Resultados intermedios
dir.create(here::here("processed-data"), showWarnings = FALSE)
# Gráficas generadas
dir.create(here::here("figuras"), showWarnings = FALSE)
# Reportes en HTML,postcards y más
dir.create(here::here("docs"), showWarnings = FALSE)

## 3. Mensajes de confirmación y verificación de ruta
## Esto ayuda a verificar si el proyecto se abrió en el lugar correcto
message("¡Estructura de carpetas creada exitosamente!")
print(paste("La raíz del proyecto es:", here::here()))

