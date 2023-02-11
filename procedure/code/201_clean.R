# list of required packages
packages = c("here","tidyverse","table1","officer")

# load and install required packages
package.check <- lapply(
  packages,
  FUN = function(x) {
    if (!require(x, character.only = TRUE)) {
      install.packages(x, dependencies = TRUE)
      library(x, character.only = TRUE)
    }
  }
)

# save the R processing environment to r_environment.txt
writeLines(capture.output(sessionInfo()),here("procedure","environment","r_environment.txt"))

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
hum_list  <- c("ECONOMIC GEOGRAPHY","POLITICAL GEOGRAPHY", "POLITICAL SCIENCE", "SOCIO-ANTHROPOLOGY", "MOBILITIES",
              "SOCIOLOGY","TRANSPORT GEOGRAPHY","TRANSPORTATION","TRANSPORTATION ENGINEERING", "URBAN GEOGRAPHY")

phys_list <- c("BIOGEOGRAPHY","PALEOBOTANY","PALEOCLIMATOLOGY")

nat_list  <- c("CITY PLANNING, SUSTAINABILITY TRANSFORMATIONS","ENVIRONMENTAL ARCHAEOLOGY","ARCHAEOLOGY")

gis_list  <- c("GEOSPATIAL INFORMATION SCIENCE", "SPATIAL ECONOMETRICS", "CARTOGRAPHY","REMOTE SENSING",
              "REMOTE SENSING OF ENVIRONMENT")

int_hegs_rpr <- int_hegs_rpr %>% 
                  mutate(Q3_recoded = as.factor(ifelse(toupper(Q3_5_TEXT) %in% hum_list, 1, 
                                        ifelse(toupper(Q3_5_TEXT) %in% phys_list, 2, 
                                            ifelse(toupper(Q3_5_TEXT) %in% nat_list, 3, 
                                                   ifelse(toupper(Q3_5_TEXT) %in% gis_list, 4, Q3))))))
levels(int_hegs_rpr$Q3_recoded) <- c("Human", 
                                     "Physical",
                                     "Nature/society", 
                                     "Methods",
                                     "Other",
                                     "NA")

table(int_hegs_rpr$Q3_recoded,int_hegs_rpr$Q3)
## Note: 2 respondents skipped Q3 and 1 respondent who indicated "other" did not specify what their subfield is


#---------------------------------------------------------------------------------------------------------------------------

res_scientist <- c("Government scientist (applied)","Project Scientist","Researcher (policy)",
                   "Senior Research Fellow", "Senior Consultant and external lecturer")

int_hegs_rpr <- int_hegs_rpr %>% 
  mutate(Q19_recoded = as.factor(ifelse(Q19 %in% res_scientist, 5, 
                                       ifelse(Q19 == "Lecturer/teacher at a university of applied sciences.", 2, Q19))))

levels(int_hegs_rpr$Q19_recoded) <- c("Full professor/lecturer",
                                      "Associate professor/lecturer",
                                      "Assistant professor/lecturer",
                                      "Laboratory director/head",
                                      "Research scientist",
                                      "Post-doctoral fellow",
                                      "Graduate student (PhD, masters)",
                                      "Technician/research assistant",
                                      "Other (specify)",
                                      "NA")

table(int_hegs_rpr$Q19_recoded,toupper(int_hegs_rpr$Q19))


#---------------------------------------------------------------------------------------------------------------------------

int_hegs_rpr %>% filter(!is.na(Q16_5)) %>% select(c(Q16_1,Q16_2,Q16_3,Q16_4,Q16_5_TEXT)) 
int_hegs_rpr %>% filter(!is.na(Q16_5_TEXT)) %>% select(c(Q16_5_TEXT)) 

int_hegs_rpr %>% filter(!is.na(Q16_5_TEXT)) %>% select(c(Q16_1,Q16_2,Q16_3,Q16_4,Q16_5, Q16_5_TEXT)) 
Q16_all_coauths <- c("all co-authors on a publication","All researchers on the team",
                 "Students and first authors", "co-investigators",
                 "Researchers (scientist, students, post doc, Principle investigator, etc)  who are producing the data should be ethical enough to produce  reproducible data")
Q16_none <- c("Nobody?","Noone","Question assumes that reproducibility should be enforced - dont agree")
Q16_dk   <- c("don't know","see earlier comment.")
Q16_all  <- "All of the above, especially the PI, but also researchers who attempt to reproduce. They must adapt models, methods and other elements for research to be reproducible in diverse contexts. This is paradoxical but mostly true."

int_hegs_rpr <- int_hegs_rpr %>% 
                    mutate(Q16_6 = as.numeric(Q16_5_TEXT %in% Q16_all_coauths),
                           Q16_7 = as.numeric(Q16_5_TEXT %in% Q16_none),
                           Q16_5 = ifelse(Q16_5_TEXT %in% Q16_all_coauths | Q16_5_TEXT %in% Q16_none | Q16_5_TEXT %in% Q16_dk
                                         | Q16_5_TEXT %in% Q16_all, NA, Q16_5),
                           Q16_1 = ifelse(!is.na(Q16_1),1,0),
                           Q16_2 = ifelse(!is.na(Q16_2),1,0),
                           Q16_3 = ifelse(!is.na(Q16_3),1,0),
                           Q16_4 = ifelse(!is.na(Q16_4),1,0),
                           Q16_5 = ifelse(!is.na(Q16_5),1,0)) %>%
                    mutate_at(c("Q16_1", "Q16_2", "Q16_3", "Q16_4"),
                              ~ ifelse(Q16_5_TEXT %in% Q16_all, 1, .))

int_hegs_rpr %>% filter(!is.na(Q16_5_TEXT)) %>% select(c(Q16_1,Q16_2,Q16_3,Q16_4,Q16_5,Q16_6,Q16_7, Q16_5_TEXT)) 

#----------------------------------------------------------#

#- Update NAs with valid values to reflect question logic -#

#----------------------------------------------------------#

#- Recode NA values due to skip logic in Q7a_2 series to never

                                        #- if any of the Q7a_2 series is not missing, then recode each variable to 0 
int_hegs_rpr <- int_hegs_rpr %>% mutate(Q7a_2_1 = ifelse(is.na(Q7a_2_1) & (!is.na(Q7a_2_2) | !is.na(Q7a_2_3) | !is.na(Q7a_2_4)), 0, Q7a_2_1),
                                        Q7a_2_2 = ifelse(is.na(Q7a_2_2) & (!is.na(Q7a_2_1) | !is.na(Q7a_2_3) | !is.na(Q7a_2_4)), 0, Q7a_2_2),
                                        Q7a_2_3 = ifelse(is.na(Q7a_2_3) & (!is.na(Q7a_2_2) | !is.na(Q7a_2_1) | !is.na(Q7a_2_4)), 0, Q7a_2_3),
                                        Q7a_2_4 = ifelse(is.na(Q7a_2_4) & (!is.na(Q7a_2_2) | !is.na(Q7a_2_3) | !is.na(Q7a_2_1)), 0, Q7a_2_4),

                                        #- if Q7a == 4 or Q7a_1 == 5, then recode each variable to 0                                         
                                        Q7a_2_1 = ifelse(as.numeric(Q7a) == 4 | as.numeric(Q7a_1) == 5,0,Q7a_2_1),
                                        Q7a_2_2 = ifelse(as.numeric(Q7a) == 4 | as.numeric(Q7a_1) == 5,0,Q7a_2_2),
                                        Q7a_2_3 = ifelse(as.numeric(Q7a) == 4 | as.numeric(Q7a_1) == 5,0,Q7a_2_3),
                                        Q7a_2_4 = ifelse(as.numeric(Q7a) == 4 | as.numeric(Q7a_1) == 5,0,Q7a_2_4))

int_hegs_rpr %>% select(c(Q7a, Q7a_1, Q7a_2_1, Q7a_2_2, Q7a_2_3, Q7a_2_4)) 
int_hegs_rpr %>% select(c(Q7a, Q7a_1, Q7a_2_1, Q7a_2_2, Q7a_2_3, Q7a_2_4)) %>% filter(is.na(Q7a_2_1))
#in 6 cases, respondents indicated that they use open source software 
#but did NOT specify in which parts of the research process they use open source software


#- Recode NA values due to skip logic in Q7 series to never
int_hegs_rpr <- int_hegs_rpr %>% mutate(Q7a_1 = as.factor(ifelse(as.numeric(Q7a) == 4, 5, Q7a_1)),
                                        Q7a_3 = as.factor(ifelse(as.numeric(Q7a) == 4 | as.numeric(Q7a_1) == 5, 5, Q7a_3)),
                                        Q7b_1 = as.factor(ifelse(as.numeric(Q7b) == 4, 5, Q7b_1)),
                                        Q7c_1 = as.factor(ifelse(as.numeric(Q7c) == 4, 5, Q7c_1)),
                                        Q7c_2 = as.factor(ifelse(as.numeric(Q7c) == 4 | as.numeric(Q7c_1) == 5, 5, Q7c_2)),
                                        Q7c_3 = as.factor(ifelse(as.numeric(Q7c) == 4, 5, Q7c_3)),
                                        Q7d_1 = as.factor(ifelse(as.numeric(Q7d) == 4, 5, Q7d_1)),
                                        Q7d_2 = as.factor(ifelse(as.numeric(Q7d) == 4 | as.numeric(Q7d_1) == 5, 5, Q7d_2)),
                                        Q7e_1 = as.factor(ifelse(as.numeric(Q7e) == 4, 5, Q7e_1)))

#- Apply value labels to recoded Q7 series
q7_varnames <- c("Q7a_1", "Q7a_3", "Q7b_1", "Q7c_1", "Q7c_2", "Q7c_3", "Q7d_1", "Q7d_2", "Q7e_1")
int_hegs_rpr[q7_varnames] <- lapply(int_hegs_rpr[q7_varnames], factor,
                                    levels = c(1, 2, 3, 4, 5, 6),
                                    labels = c("Always",
                                               "Most of the time",
                                               "Some of the time",
                                               "Rarely",
                                               "Never",
                                               "NA"))

#check recoding of values
head(int_hegs_rpr %>% select(c(Q7a,Q7a_1,Q7a_3)))
head(int_hegs_rpr %>% select(c(Q7b,Q7b_1)))
head(int_hegs_rpr %>% select(c(Q7c,Q7c_1,Q7c_2, Q7c_3)))
head(int_hegs_rpr %>% select(c(Q7d,Q7d_1,Q7d_2)))
head(int_hegs_rpr %>% select(c(Q7e,Q7e_1)))

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

#----------------------------------------------------------#

#- Convert character to ordered factors-#

#----------------------------------------------------------#
# convert agree questions into ordered factors
values <- c("Strongly agree", "Agree", "Disagree","Strongly disagree")
questions <- c("Q8_1", "Q8_2", "Q8_3", "Q8_4","Q8_5", "Q8_6")
int_hegs_rpr[questions] <- lapply(int_hegs_rpr[questions], 
                                 factor, 
                                 levels=values,
                                 ordered = TRUE,
                                 exclude=c("", "Don't Know"))

# convert yes/no questions into ordered factors
values <- c("Yes", "No", "Don't Know")
questions <- c("Q9_1", "Q9_2", "Q9_3", "Q9_4", "Q9_5", "Q9_6", "Q9_7")
int_hegs_rpr[questions] <- lapply(int_hegs_rpr[questions], 
                                 factor, 
                                 levels=values,
                                 ordered = TRUE,
                                 exclude="")

# convert proportion questions into ordered factors
values <- c("All", "Some", "None", "Don't Know")
questions <- c("Q11_1", "Q11_2", "Q11_3")
int_hegs_rpr[questions] <- lapply(int_hegs_rpr[questions], 
                                 factor, 
                                 levels=values,
                                 ordered = TRUE,
                                 exclude="")

# convert yes/no proportion questions into ordered factors
values <- c("Yes, all", "Yes, some", "No", "Did not attempt")
questions <- c("Q12_1", "Q12_2", "Q12_3", "Q12_4")
int_hegs_rpr[questions] <- lapply(int_hegs_rpr[questions], 
                                 factor, 
                                 levels=values,
                                 ordered = TRUE,
                                 exclude="")

# convert frequency questions into ordered factors
values <- c("Frequently", "Occasionally", "Rarely", "Never")
questions <- c("Q14_1", "Q14_2", "Q14_3", "Q14_4", "Q14_5", "Q14_6", "Q14_7", "Q14_8", "Q14_9", "Q14_10", "Q14_11", "Q14_12")
int_hegs_rpr[questions] <- lapply(int_hegs_rpr[questions], 
                                 factor, 
                                 levels=values,
                                 ordered = TRUE,
                                 exclude="")

# convert importance questions into ordered factors
values <- c("Very important", "Somewhat important", "Somewhat not important", "Not important")
questions <- c("Q17_1", "Q17_2", "Q17_3", "Q17_4", "Q17_5", "Q17_6", "Q17_7", "Q17_8", "Q17_9", "Q17_10")
int_hegs_rpr[questions] <- lapply(int_hegs_rpr[questions], 
                                 factor, 
                                 levels=values,
                                 ordered = TRUE,
                                 exclude="")


# check data types for the full survey
sapply(int_hegs_rpr, class)

#--------------------------------#

#- Perform Qualitative Coding -#

#--------------------------------#

#-Export open response definitions and reproductions to .csv for further coding
analysis_Q6_coding <- int_hegs_rpr %>% select(c(ResponseId,Q3_recoded,Q4,Q6))
#write.csv(analysis_Q6_coding,here("data","derived","public","analysis_Q6_coding.csv"))

analysis_Q10_coding  <- int_hegs_rpr %>% 
                  filter(Q9_7 == "Yes") %>% 
                  select(c(ResponseId,Q3_recoded,Q4,Q10))
#write.csv(analysis_Q10_coding,here("data","derived","public","analysis_10_coding.csv"))

#-Read in final coding sheets and restrict to variables of interest
q10_coding <- read.csv(here("data","derived","public","final_full_q10_coding.csv"))
q10_coding <- q10_coding  %>% select(ResponseId, consensus, starts_with("X"))

q6_coding <- read.csv(here("data","derived","public","final_full_q6_coding.csv"))
q6_coding <- q6_coding  %>% select(ResponseId, ends_with("_rec"), Rejection, label)

#-Merge qualitative coding back to main analysis file and construct additional variables
survey_resp <- left_join(int_hegs_rpr,q10_coding, by ="ResponseId")
survey_resp <- left_join(survey_resp,q6_coding, by ="ResponseId")

survey_resp <- survey_resp %>% mutate(rp_conservative = ifelse(Q11_1 == "All" | Q11_2 == "All", 1, 0),
                                      rp_liberal = ifelse(rp_conservative == 1 | (Q11_1 == "Some" | Q11_2 == "Some"), 1, 0),
                                      access_some_data = ifelse(Q12_1 %in% c("Yes, all", "Yes, some"), 1, 0),
                                      access_some_code = ifelse(Q12_2 %in% c("Yes, all", "Yes, some"), 1, 0),
                                      access_some_data_code = ifelse(access_some_code == 1 & access_some_data == 1, 1, 0),
                                      access_all_data_code = ifelse(Q12_1 == "Yes, all" & Q12_2 == "Yes, all",1,0),
                                      Q10_recoded = as.factor(consensus),
                                      definition_sum = ifelse(label == "Omit", NA, dat_rec + pro_rec + res_rec + con_rec),
                                      definition_label = label)
levels(survey_resp$Q10_recoded) <- c("Verification/Peer-Review",
                                     "Self-check",
                                     "Replication",
                                     "Teaching/Learning",
                                     "Missing")

table(survey_resp$rp_conservative,survey_resp$rp_liberal)
survey_resp %>% 
  select(Q11_1,Q11_2) %>% 
  filter(survey_resp$rp_conservative == 0 & survey_resp$rp_liberal == 0)

saveRDS(survey_resp, here("data","derived","public","analysis_hegs_rpr.rds"))