# Análisis de expresión diferencial – SRP091957

Proyecto de RNA-seq para la clase de **Análisis de sencuenciación masiva**, utilizando datos procesados con recount3.

## 📚 Descripción del estudio

Se analizaron datos del estudio **SRP091957**, correspondiente a un experimento de reprogramación celular humana.

Se realizó una comparación entre:

-   **hiF-T** → fibroblastos humanos iniciales
-   **niPSC-T** → células pluripotentes inducidas

El objetivo fue identificar genes diferencialmente expresados entre el estado inicial y el estado reprogramado.

------------------------------------------------------------------------

## 🔬 Flujo de análisis

1.Descarga del estudio desde recount3 2.Conversión a read counts 3.Expansión de metadatos SRA 4.Selección de muestras hiF‑T vs niPSC‑T 5.Filtrado de genes de baja expresión 6.Normalización TMM (edgeR) 7.Modelado lineal con limma‑voom 8.Identificación de genes diferencialmente expresados

------------------------------------------------------------------------

## 🧪 Modelo estadístico

Se utilizó el modelo:

**\~ stage**

donde el coeficiente evaluado corresponde a:}

**logFC = (niPSC-T) - (hiF-T)**

------------------------------------------------------------------------

## 📊 Resultados principales

-   Genes analizados: 32,368
-   Genes diferencialmente expresados (FDR \< 0.05): 18,065 (\~56%)

Este número indica una reorganización transcriptómica masiva compatible con un cambio de identidad celular completo.

## Validación biológica interna

Genes activados en iPSC (pluripotencia): UTF1, LIN28A, DNMT3L, TRIM71, FGF4

Genes reprimidos en iPSC (fibroblasto/ECM): COL1A2, COL6A3, TNC, THBS2, TGFBI

Esto confirma que el análisis detecta correctamente la transición fibroblasto → pluripotente.

------------------------------------------------------------------------

## Interpretación global

Los resultados apoyan el modelo de identidad celular como un estado estable del transcriptoma. La reprogramación no consiste en modificar genes individuales sino en transicionar entre redes regulatorias completas: se apaga el programa mesenquimal y se activa el circuito de pluripotencia.

------------------------------------------------------------------------

## 📦 Paquetes utilizados (vistos en clase)

-   recount3
-   edgeR
-   limma
-   pheatmap
-   RColorBrewer

------------------------------------------------------------------------

## 📁 Estructura del repositorio

```         
rnaseq_proyecto_bioinfoII/
│
├── README.md
│
├── R/
│   ├── 01-setup.R
│   ├── 02-recount3_exploracion.R
│   └── 03-DE_hiFT_vs_niPSCT.R
│
├── results/
│   └── DE_hiFT_vs_niPSCT.csv
│
├── plots/
│   ├── voom_mean_variance.png
│   ├── MA_hiFT_vs_niPSCT.png
│   ├── Volcano_hiFT_vs_niPSCT.png
│   ├── Heatmap_Top50_hiFT_vs_niPSCT.png
│   └── MDS_hiFT_vs_niPSCT.png
│
└── docs/
    └── informe_resultados.md
```

------------------------------------------------------------------------

## Creditos

Datos: proyecto SRP091957

Curso : Análisis de sencuenciación masiva impartido por el Dr. Leonardo Collado Torres.
