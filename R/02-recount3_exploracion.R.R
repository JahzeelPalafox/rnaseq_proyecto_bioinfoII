##-------------------------------------------------------------------------
## Script: 02-datos.R
##
## Objetivo (Exploración):
## Descargar el estudio SRP091957 desde recount3 y explorar los metadatos
## para identificar los grupos experimentales disponibles y sus réplicas.
##-------------------------------------------------------------------------

library(recount3)

## ------------------------------------------------------------------------
## Obtener catálogo de estudios en humano
## ------------------------------------------------------------------------

human_projects <- available_projects()

## ------------------------------------------------------------------------
##  Seleccionar el estudio SRP091957
## ------------------------------------------------------------------------

proj_info <- subset(
  human_projects,
  project == "SRP091957" & project_type == "data_sources"
)

## ------------------------------------------------------------------------
## Crear objeto RSE
## ------------------------------------------------------------------------

rse_gene_SRP091957 <- create_rse(proj_info)

## Estructura general del objeto
rse_gene_SRP091957

## ------------------------------------------------------------------------
##  Convertir a read counts
## ------------------------------------------------------------------------

assay(rse_gene_SRP091957, "counts") <-
  compute_read_counts(rse_gene_SRP091957)

## ------------------------------------------------------------------------
## Expandir metadatos experimentales
## ------------------------------------------------------------------------

rse_gene_SRP091957 <- expand_sra_attributes(rse_gene_SRP091957)

## Visualizar columnas experimentales
colData(rse_gene_SRP091957)[
  ,
  grepl("^sra_attribute", colnames(colData(rse_gene_SRP091957)))
]

## ------------------------------------------------------------------------
## Exploración de los grupos biológicos
## ------------------------------------------------------------------------

# Extraemos la variable clave del estudio
stage <- rse_gene_SRP091957$sra_attribute.reprogramming_stage

# Revisamos los niveles disponibles
levels(factor(stage))

# Número de muestras por estadio
table(stage)

