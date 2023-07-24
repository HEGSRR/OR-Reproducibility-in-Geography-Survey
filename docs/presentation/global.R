# Packages ####
library(shiny)
library(plotly)
library(tidyverse)
library(wordcloud2)

# theme to match HTML
thematic::thematic_shiny(font = "auto")

source("data/constants.R")

# load data ####
analysis <- readRDS("data/analysis.rds")

clouds <- readRDS("data/clouds.rds")
clouds_q6 <- readRDS("data/clouds_q6.rds")
