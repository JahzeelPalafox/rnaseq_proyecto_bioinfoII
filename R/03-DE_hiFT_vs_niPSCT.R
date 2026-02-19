###-------------------------------------------------------------------------
## Script: 03-DE_hiFT_vs_niPSCT.R
## Proyecto: Análisis de expresión diferencial – SRP091957 (recount3)
##
## Comparación principal:
##   hiF-T (estado fibroblasto inicial)  vs  niPSC-T (estado pluripotente final)
##   En el modelo, el coeficiente de interés se interpreta como:
##   logFC = (niPSC-T) - (hiF-T)
##-------------------------------------------------------------------------

library(recount3)
library(edgeR)
library(limma)
library(pheatmap)
library(RColorBrewer)

## ------------------------------------------------------------------------
## Descargar y preparar el objeto RSE (mismo flujo del Script 02)
## ------------------------------------------------------------------------

human_projects <- available_projects()

proj_info <- subset(
  human_projects,
  project == "SRP091957" & project_type == "data_sources"
)

rse <- create_rse(proj_info)

## Convertir a read counts (necesario para edgeR/limma)
assay(rse, "counts") <- compute_read_counts(rse)

## Expandir metadatos SRA
rse <- expand_sra_attributes(rse)

## ------------------------------------------------------------------------
## Definir la variable biológica y seleccionar comparación hiF-T vs niPSC-T
## ------------------------------------------------------------------------

stage_all <- rse$sra_attribute.reprogramming_stage

keep_samples <- stage_all %in% c("hiF-T", "niPSC-T")
rse_sub <- rse[, keep_samples]

## Fijamos el orden: logFC = niPSC-T - hiF-T
rse_sub$stage <- factor(
  rse_sub$sra_attribute.reprogramming_stage,
  levels = c("hiF-T", "niPSC-T")
)

## Verificación rápida: debe ser 2 y 2
table(rse_sub$stage)

## ------------------------------------------------------------------------
## Filtrado simple de genes con muy baja expresión
## ------------------------------------------------------------------------

rse_sub_unfiltered <- rse_sub

gene_means <- rowMeans(assay(rse_sub, "counts"))
summary(gene_means)

rse_sub <- rse_sub[gene_means > 0.1, ]

dim(rse_sub)
round(nrow(rse_sub) / nrow(rse_sub_unfiltered) * 100, 2)

## ------------------------------------------------------------------------
## Normalización con edgeR (TMM)
## ------------------------------------------------------------------------

dge <- DGEList(
  counts = assay(rse_sub, "counts"),
  genes  = rowData(rse_sub)
)

dge <- calcNormFactors(dge)

## ------------------------------------------------------------------------
## Modelo estadístico
## ------------------------------------------------------------------------

design <- model.matrix(~ stage, data = colData(rse_sub))
colnames(design)
## Esperado:
## "(Intercept)" "stageniPSC-T"

## ------------------------------------------------------------------------
## limma-voom + eBayes (Expresión diferencial)
## ------------------------------------------------------------------------

png("plots/voom_mean_variance.png", width = 1200, height = 1000)
vGene <- voom(dge, design, plot = TRUE)
dev.off()

fit <- lmFit(vGene, design)
fit <- eBayes(fit)

de_results <- topTable(
  fit,
  coef = "stageniPSC-T",
  number = nrow(rse_sub),
  sort.by = "P"
)

write.csv(de_results, "results/DE_hiFT_vs_niPSCT.csv")

table(de_results$adj.P.Val < 0.05)

## ------------------------------------------------------------------------
## Visualización de resultados
## ------------------------------------------------------------------------

## MA plot
png("plots/MA_hiFT_vs_niPSCT.png", width = 1200, height = 1000)
plotMA(fit, coef = "stageniPSC-T")
dev.off()

## Volcano plot (limma::volcanoplot, usado en clase)
png("plots/Volcano_hiFT_vs_niPSCT.png", width = 1200, height = 1000)
volcanoplot(
  fit,
  coef = "stageniPSC-T",
  highlight = 5,
  names = de_results$gene_name
)
dev.off()

## Heatmap Top 50 genes (por FDR)
exprs_heatmap <- vGene$E[rank(de_results$adj.P.Val) <= 50, ]

annot <- data.frame(Stage = rse_sub$stage)
rownames(annot) <- colnames(exprs_heatmap)

png("plots/Heatmap_Top50_hiFT_vs_niPSCT.png", width = 1200, height = 1000)
pheatmap(
  exprs_heatmap,
  cluster_rows = TRUE,
  cluster_cols = TRUE,
  show_rownames = FALSE,
  show_colnames = FALSE,
  annotation_col = annot
)
dev.off()

## MDS (limma) con colores por grupo
col.group <- annot$Stage
levels(col.group) <- brewer.pal(2, "Set1")
col.group <- as.character(col.group)

png("plots/MDS_hiFT_vs_niPSCT.png", width = 1200, height = 1000)
plotMDS(vGene$E, labels = annot$Stage, col = col.group)
dev.off()

