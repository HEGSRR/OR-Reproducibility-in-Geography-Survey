# Packages ####
library(shiny)
library(plotly)
library(stringr)
library(tidyverse)
library(wordcloud2)
library(shinycssloaders)

# theme to match HTML
thematic::thematic_shiny(font = "auto")

# colors for likert
pal <- c("#DF4949", "#E27A3F", "#BEBEBE", "#45B29D", "#334D5C")

# plot height as CSS
plot_height <- "60vh"

# text width for axis labels
width <- 20

# spinner
spin <- function(plt) {
  shinycssloaders::withSpinner(
    plt,
    type = 4,
    color = "#1D5B79",
    size = 2,
    hide.ui = FALSE
  )
}

source("data/constants.R")

# load data ####
analysis <- readRDS("data/analysis.rds")

clouds_q6 <- readRDS("data/clouds_q6.rds")
clouds_q10 <- readRDS("data/clouds_q10.rds")
q8 <- readRDS("data/q8.rds")
