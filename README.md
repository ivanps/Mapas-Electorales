# Elecciones Gubernamentales 2016

## Voto por región

Para visualizar el voto ciudadano usando un shapefile como el que se muestra ejecuta los comandos que se muestran abajo de la imagen desde la plataforma de R.

![Shapefile Zacatecas.](shapeZac.png)
```R
library(shiny)
runGitHub("elec_gob", "ivanps", subdir = "shape_voto_region")
```
