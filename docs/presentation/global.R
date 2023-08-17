# Packages ####
library(shiny)
library(plotly)
library(stringr)
library(tidyverse)
library(wordcloud2)
library(shinycssloaders)

# theme to match HTML
thematic::thematic_shiny(font = "auto")

# About page
about <- readr::read_file("about-page.md")

# colors for likert
pal <- c("#DF4949", "#E27A3F", "#BEBEBE", "#45B29D", "#334D5C")

# continuous colors
pal3 <- c("#EF5645", "#D9D9D9", "#7F7F7F")
pal5 <- c("#CD2311", "#EF5645", "#D9D9D9", "#F2F2F2", "#7F7F7F")

# plot height as CSS
plot_height <- "60vh"
plot_full_height <- "80vh"

# text width for axis labels
width <- 20
width_long <- 32

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
gen <- readRDS("data/generated.rds")
