library(here)
library(tidyverse)
library(janitor)

#-----------------------------------#

#- Merge survey data back to frame -#

#-----------------------------------#
#- Read in data files -#
survey_resp <- read.csv(here("data","raw","public","hegsrr_raw_reprod.csv"))
survey_samp <- read.csv(here("data","raw","private","analysis","Survey-Response-Tracking_qualtrics_update_v4.csv"))

#- Merge files -#
raw <- right_join(survey_resp, survey_samp,by = c("ResponseId" = "Response.ID"))
table(raw$disposition_final)

# Filter out partial completes and underage respondent
raw_filtered <- raw %>% filter(disposition_final %in% c("1.1","1.2") & Q1 != "Under 18")


#-----------------------------------#

#- Clean up variable formats -#

#-----------------------------------#

#Convert character variables with fewer than 6 unique responses to factor
col_names <- sapply(raw_filtered, function(col) length(unique(col)) < 6)
raw_filtered[ , col_names] <- lapply(raw_filtered[ , col_names] , factor)
raw_filtered <- raw_filtered[c(1:98)]
             
write.csv(raw_filtered, here("data","derived","private","hegsrr_analysis_reprod.csv"))





