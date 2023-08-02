# Packages ####
library(shiny)
library(plotly)
library(stringr)
library(tidyverse)
library(wordcloud2)

# theme to match HTML
thematic::thematic_shiny(font = "auto")

# colors for 4 levels
# continuous
mako4 <- viridisLite::plasma(4, begin = 0.3, end = 0.7)
# discrete
pal4 <- viridisLite::viridis(4, begin = 0.1, end = 0.9)
pal5 <- viridisLite::viridis(5, begin = 0.1, end = 0.9)
# discrete: alternate choices
# https://stackoverflow.com/a/40181166
# pal4 <- scales::hue_pal()(4)
# pal5 <- scales::hue_pal()(5)
# https://rdrr.io/cran/ggthemes/man/palette_pander.html
#pal4 <- ggthemes::palette_pander(8)
#pal5 <- pal4

# plot height as CSS
plot_full_height <- "80vh"
plot_height <- "60vh"

source("data/constants.R")

# load data ####
analysis <- readRDS("data/analysis.rds")

clouds <- readRDS("data/clouds.rds")
clouds_q6 <- readRDS("data/clouds_q6.rds")
