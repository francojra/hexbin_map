
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

### Apresentação do mapa

plot(spdf)

# Mapa ggplot2 com nome dos estados --------------------------------------------------------------------------------------------------------

### É totalmente possível usar o plot geoespacial usando ggplot2 com a função
### geom_polygon(), mas primeiro necessitamos fortificá-lo usando o pacote broom.
### Além disso, o pacote rgeos é usado para calcular o centróide de cada região
### com a função gCentroid.

### Fortificar os dados para ser capaz de mostrar ele com ggplot2 
### (necessita de formato data frame)

library(broom)
library(pryr)

class(spdf)

pryr::otype(spdf)

spdf_fortified <- broom::tidy(spdf)
view(spdf_fortified)

### Calcular o centróide de cada hexagono para adicionar o rótulo

library(rgeos)

centers <- cbind.data.frame(data.frame(gCentroid(spdf, byid = TRUE), 
                                       id = spdf@data$iso3166_2))
view(centers)

### Gráfico

ggplot() +
  geom_polygon(data = spdf_fortified , aes(x = long, y = lat, group = group), 
               fill = "skyblue", color = "white") +
  geom_text(data = centers, aes(x = x, y = y, label = id)) +
  theme_void() +
  coord_map()

# Básico choropleth ------------------------------------------------------------------------------------------------------------------------

### Agora, você provavelmente quer ajustar a cor de cada hexagono, de acordo
### com o valor de uma específica variável (nós chamamos de mapa coroplético).

### Nesta postagem, eu sugiro representar o número de casamentos a cada mil
### pessoas. Vamos começar carregando essa informação e representando a 
### distribuição dela:

### Carregando os dados

data <- read.table("https://raw.githubusercontent.com/holtzy/R-graph-gallery/master/DATA/State_mariage_rate.csv", 
                   header = T, 
                   sep = ",", 
                   na.strings = "---")
view(data)

### Distribuição da taxa de casamentos

data %>% 
  ggplot( aes(x = y_2015)) + 
    geom_histogram(bins = 20, fill = '#69b3a2', color = 'white') + 
    scale_x_continuous(breaks = seq(1,30))

### A maioria dos estados apresentam entre 5 e 10 casamentos a cada 1000
### habitantes, mas existem dois outliers com altos valores (16 e 32).

### Vamos representar essas informações no mapa. Nós temos uma coluna com
### a identidade dos estados em geoespacial e numéricos conjuntos de dados.
### Então, nós podemos unir ambas as informações e plotar elas no mapa.








