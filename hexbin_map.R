
# Hexbin Map -------------------------------------------------------------------------------------------------------------------------------
# Autora do script: Jeanne Franco ----------------------------------------------------------------------------------------------------------
# Data: 01/10/23 ---------------------------------------------------------------------------------------------------------------------------
# Referência: https://r-graph-gallery.com/hexbin-map.html ----------------------------------------------------------------------------------

# Introdução -------------------------------------------------------------------------------------------------------------------------------

### Um mapa hexbin apresenta dois diferentes conceitos.Ele pode estar baseado em um
### objeto geoespacial onde todas as regiões do mapa são representadas como hexagonos.
### Ou ele pode se referir a um gráfico de densidade bidimensional (2D). Esta seção 
### da galeria fornece vários exemplos com explicações passo a passo.

# Mapa hexbin de um objeto geoespacial -----------------------------------------------------------------------------------------------------

### Nesse caso, a técnica é muito próxima do mapa choropleth. Na verdade, é exatamente
### o mesmo, exceto que a entrada geoJson são contornos hexagonais ao invés de regionais.

# Mapa Hexbin: um exemplo com estados dos US -----------------------------------------------------------------------------------------------

### Esse poste drescreve como construir um mapa hexbin.Ele é baseado em um arquivo geojson
### que promove os limites dos estados dos Estados Unidos como hexagonos.

# Basic hexbin map -------------------------------------------------------------------------------------------------------------------------

### Você deve fazer o download do arquivo em formato geojson e carregar ele no R com a
### função geojson_read().

### Carregar pacotes:

library(tidyverse)
library(geojsonio)
library(RColorBrewer)
library(rgdal)

### Download the Hexagones boundaries at geojson format here: 
### https://team.carto.com/u/andrew/tables/andrew.us_states_hexgrid/public/map.

spdf <- geojson_read("us_states_hexgrid.geojson",  what = "sp")
view(spdf)

### Reformatação

spdf@data = spdf@data %>%
  mutate(google_name = gsub(" \\(United States\\)", "", google_name))
view(spdf@data)
