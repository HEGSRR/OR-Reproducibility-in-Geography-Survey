library(here)
library(tidyverse)
library(janitor)

#--------------------------------------------#

#- Read in and limit data file to completes -#

#--------------------------------------------#
raw_hegs_rpr <- readRDS(here("data","raw","public","raw_hegs_rpr.rds"))
int_hegs_rpr <- raw_hegs_rpr %>% filter(Progress > 70 & Q1 != "Under 18")
  summary(int_hegs_rpr$Progress)

#------------------------------------#

#- Backcode other specify responses -#

#------------------------------------#
table(toupper(int_hegs_rpr$Q3_5_TEXT))

#-Open response areas of specialization to recode-#
hum_list  <- c("ECONOMIC GEOGRAPHY","POLITICAL GEOGRAPHY", "POLITICAL SCIENCE", "SOCIO-ANTHROPOLOGY",
              "SOCIOLOGY","TRANSPORT GEOGRAPHY","TRANSPORTATION","TRANSPORTATION ENGINEERING", "URBAN GEOGRAPHY")

phys_list <- c("PALEOBOTANY","PALEOCLIMATOLOGY")

nat_list  <- c("BIOGEOGRAPHY","CITY PLANNING, SUSTAINABILITY TRANSFORMATIONS","ENVIRONMENTAL ARCHAEOLOGY","ARCHAEOLOGY",
              "MOBILITIES")

gis_list  <- c("GEOSPATIAL INFORMATION SCIENCE", "SPATIAL ECONOMETRICS", "CARTOGRAPHY","REMOTE SENSING",
              "REMOTE SENSING OF ENVIRONMENT")

int_hegs_rpr <- int_hegs_rpr %>% 
                  mutate(Q3_recoded = as.factor(ifelse(toupper(Q3_5_TEXT) %in% hum_list, 1, 
                                        ifelse(toupper(Q3_5_TEXT) %in% phys_list, 2, 
                                            ifelse(toupper(Q3_5_TEXT) %in% nat_list, 3, 
                                                   ifelse(toupper(Q3_5_TEXT) %in% gis_list, 4, Q3))))))
levels(int_hegs_rpr$Q3_recoded) <- c("Human geography", 
                                     "Physical geography, earth and environmental sciences",
                                     "Nature and society", 
                                     "Geographic methods, GIS, spatial statistics",
                                     "Other",
                                     "NA")

table(int_hegs_rpr$Q3_recoded,int_hegs_rpr$Q3)
## Note: 2 respondents skipped Q3 and 1 respondent who indicated "other" did not specify what their subfield is

##Unsure how to backcode these variables yet
table(toupper(int_hegs_rpr$Q16_5_TEXT))
table(int_hegs_rpr$Q19,toupper(int_hegs_rpr$Q19_9_TEXT))


#----------------------------------------------------------#

#- Update NAs with valid values to reflect question logic -#

#----------------------------------------------------------#



#----------------------------------------------------------#

#- Clean up Q13 series of questions that should be numeric-#

#----------------------------------------------------------#

#-Cleaning Q13 series of variables-#
int_hegs_rpr <- int_hegs_rpr %>% mutate(Q13_1 = as.numeric(recode(Q13_1_1, 
                                                                  "?" = "NA",
                                                                  ">50%" = "50",
                                                                  "5%" = "5",
                                                                  "60%" = "60",
                                                                  "Hard to say" = "NA",
                                                                  "na" = "NA")),
                                        Q13_2 = as.numeric(recode(Q13_2_1, 
                                                                  "?" = "NA",
                                                                  ">50%" = "50",
                                                                  "3%" = "3",
                                                                  "5%" = "5",
                                                                  "70%" = "70",
                                                                  "Hard to say" = "NA",
                                                                  "na" = "NA",
                                                                  "GIS" = "NA",
                                                                  "Human Geography" = "NA")))

table(int_hegs_rpr$Q13_1_1,int_hegs_rpr$Q13_1, useNA = "always")
table(int_hegs_rpr$Q13_2_1, int_hegs_rpr$Q13_2, useNA = "always")

summary(int_hegs_rpr$Q13_1)
summary(int_hegs_rpr$Q13_2)

#--------------------------------#

#- Save permanent analysis file -#

#--------------------------------#

saveRDS(int_hegs_rpr, here("data","derived","public","analysis_hegs_rpr.rds"))





