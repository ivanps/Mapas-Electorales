# Elecciones Gubernamentales 2016

## Voto por región

Para visualizar el voto ciudadano usando un shapefile como el que se muestra ejecuta los comandos que se muestran abajo de la imagen desde la plataforma de R.

![Shapefile Zacatecas.](shapeZac.png)
```R
library(shiny)
runGitHub("Mapas_Electorales", "ivanps", subdir = "shape_voto")
```

## Voto por región usando ggmap

Para visualizar el voto ciudadano usando ggmap como el que se muestra ejecuta los comandos que se muestran abajo de la imagen desde la plataforma de R.

![ggmap Zacatecas.](ggmapZac.png)
```R
library(shiny)
runGitHub("Mapas_Electorales", "ivanps", subdir = "ggmap_voto")
```

## Voto por partido

Para visualizar el voto ciudadano usando un shapefile como el que se muestra ejecuta los comandos que se muestran abajo de la imagen desde la plataforma de R.

![ggmap Partidos.](ggmapPartidos.png)
```R
library(shiny)
runGitHub("Mapas_Electorales", "ivanps", subdir = "ggmap_partidos")
```
