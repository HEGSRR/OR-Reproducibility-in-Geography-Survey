library(here)
library(tidyverse)


#--------------------------------#
#-                              -#
#- PERFORM DESCRIPTIVE ANALYSIS -#
#-                              -#
#--------------------------------#
survey_resp <- readRDS(here("data","derived","public","analysis_hegs_rpr.rds"))

#- Define variable lists -#
demo <- c("Q1", "Q2", "Q3_recoded","Q4","Q5", "Q18", "Q19", "Q20")

practice <- c("Q7a","Q7a_1", "Q7a_3", 
              "Q7b","Q7b_1",
              "Q7c","Q7c_1","Q7c_2","Q7c_3",
              "Q7d","Q7d_1","Q7d_2",
              "Q7e","Q7e_1")

importance <- c("Q13_1", "Q13_2",
                "Q17_1", "Q17_2", "Q17_3", "Q17_4",
                "Q17_5", "Q17_6", "Q17_7", "Q17_8",
                "Q17_9", "Q17_10")

barriers <- c("Q14_1", "Q14_2", "Q14_3", "Q14_4", 
              "Q14_5", "Q14_6", "Q14_7", "Q14_8",
              "Q14_9", "Q14_10", "Q14_11", "Q14_12",
              "Q16", "Q19_9_TEXT", "Q20_5_TEXT", "Q21_7_TEXT")

numeric_vars <- c(demo, practice, importance)


char_vars <- c("Q6", "Q7a_2", "Q12a", 
               "Q13_1_1", "Q13_2_1", "Q15", "Q16_5_TEXT",
               "Q17a")

all_vars <- c(numeric_vars, char_vars)

#-----------------#  
#-- Frequencies --#
#-----------------#
for (i in all_vars){
  Frequency <-  (table(survey_resp[[i]]))
  Percentage <- prop.table(Frequency) * 100 
  table_all <- rbind(Frequency, Percentage)
  print(table_all)
  write.csv(table_all, here("results","tables","Freqs",paste0("Freq_",i, ".csv", sep = "")))
}

#-----------------------#
#-- Cross tabulations --#
#-----------------------#
#-Q3-#
for (i in numeric_vars){
  mytable <- table(survey_resp[[i]],survey_resp$Q3_recoded)
  xtab <-  round(prop.table(mytable, margin = 2) * 100,2) 
  write.csv(xtab, here("results","tables","Field",paste0("Q3_Xtab_",i, ".csv", sep = "")))
}

#-Q4-#
for (i in numeric_vars){
  mytable <- table(survey_resp[[i]],survey_resp$Q4)
  xtab <-  round(prop.table(mytable, margin = 2) * 100,2) 
  write.csv(xtab, here("results","tables","Method",paste0("Q4_Xtab_",i, ".csv", sep = "")))
}

#-Q5-#
for (i in numeric_vars){
  mytable <- table(survey_resp[[i]],survey_resp$Q5)
  xtab <-  round(prop.table(mytable, margin = 2) * 100,2) 
  write.csv(xtab, here("results","tables","Familiarity",paste0("Q5_Xtab_",i, ".csv", sep = "")))
}





#PRETTY SURE WE CAN DELETE ALL CODE AFTER THIS POINT, BUT NEED TO DOUBLE CHECK#



#-Age-#
for (i in numeric_vars){
  mytable <- table(survey_resp[[i]],survey_resp$Q1)
  xtab <-  round(prop.table(mytable, margin = 2) * 100,2) 
  write.csv(xtab, here("results","tables","Age",paste0("Age_Xtab_",i, ".csv", sep = "")))
}


##### FACTOR MANAGEMENT #####
# if anyone can compress all of this into a function that uses a table of 
# questions & ordered responses, by all means...

# Simplify sub-field labels
values <- c("Human geography",
            "Physical geography, earth and environmental sciences",
            "Nature and society",
            "Geographic methods, GIS, spatial statistics")
survey_resp$Q3 <- factor(survey_resp$Q3, levels=values)
values <- c("Human", "Physical", "Nature/Society", "Methods")
levels(survey_resp$Q3) <- values

# convert extent questions into ordered factors
values <- c("Not at all", "Very little", "Somewhat", "To a great extent")
questions <- c("Q5", "Q7a","Q7b", "Q7c", "Q7d", "Q7e")
survey_resp[questions] <- lapply(survey_resp[questions], 
                                 factor, 
                                 levels=values,
                                 ordered = TRUE,
                                 exclude="")

# convert frequency questions into ordered factors
values <- c("Never", "Rarely", "Some of the time", "Most of the time", "Always")
questions <- c("Q7a_1", "Q7a_3", "Q7b_1", "Q7c_1", "Q7c_2", "Q7c_3", "Q7d_1", "Q7d_2", "Q7e_1")
survey_resp[questions] <- lapply(survey_resp[questions], 
                                 factor, 
                                 levels=values,
                                 ordered = TRUE,
                                 exclude="")

# convert agree questions into ordered factors
values <- c("Strongly disagree", "Disagree", "Agree", "Strongly agree")
questions <- c("Q8_1", "Q8_2", "Q8_3", "Q8_4","Q8_5", "Q8_6")
survey_resp[questions] <- lapply(survey_resp[questions], 
                                 factor, 
                                 levels=values,
                                 ordered = TRUE,
                                 exclude=c("", "Don't Know"))

# convert yes/no questions into ordered factors
values <- c("Yes", "No", "Don't Know")
questions <- c("Q9_1", "Q9_2", "Q9_3", "Q9_4", "Q9_5", "Q9_6", "Q9_7")
survey_resp[questions] <- lapply(survey_resp[questions], 
                                 factor, 
                                 levels=values,
                                 ordered = TRUE,
                                 exclude="")

# convert proportion questions into ordered factors
values <- c("All", "Some", "None", "Don't Know")
questions <- c("Q11_1", "Q11_2", "Q11_3")
survey_resp[questions] <- lapply(survey_resp[questions], 
                                 factor, 
                                 levels=values,
                                 ordered = TRUE,
                                 exclude="")

# convert yes/no proportion questions into ordered factors
values <- c("Yes, all", "Yes, some", "No", "Did not attempt")
questions <- c("Q12_1", "Q12_2", "Q12_3", "Q12_4")
survey_resp[questions] <- lapply(survey_resp[questions], 
                                 factor, 
                                 levels=values,
                                 ordered = TRUE,
                                 exclude="")

# convert frequency questions into ordered factors
values <- c("Frequently", "Occasionally", "Rarely", "Never")
questions <- c("Q14_1", "Q14_2", "Q14_3", "Q14_4", "Q14_5", "Q14_6", "Q14_7", "Q14_8", "Q14_9", "Q14_10", "Q14_11", "Q14_12")
survey_resp[questions] <- lapply(survey_resp[questions], 
                                 factor, 
                                 levels=values,
                                 ordered = TRUE,
                                 exclude="")

# convert importance questions into ordered factors
values <- c("Very important", "Somewhat important", "Somewhat not important", "Not important")
questions <- c("Q17_1", "Q17_2", "Q17_3", "Q17_4", "Q17_5", "Q17_6", "Q17_7", "Q17_8", "Q17_9", "Q17_10")
survey_resp[questions] <- lapply(survey_resp[questions], 
                                 factor, 
                                 levels=values,
                                 ordered = TRUE,
                                 exclude="")

# check data types for the full survey
sapply(survey_resp, class)

##### Calculate Aggregate Indicators #####

# familiarity with reproducible practices
survey_resp <- survey_resp %>% mutate(familiar = as.numeric(Q7a) + 
                                        as.numeric(Q7b) + as.numeric(Q7c) +
                                        as.numeric(Q7d) + as.numeric(Q7e))

# beliefs about role of reproducibility in scholarship
survey_resp <- survey_resp %>% mutate(belief = as.numeric(Q8_1) + 
                                        (4 - as.numeric(Q8_2)) + 
                                        as.numeric(Q8_3) +
                                        as.numeric(Q8_4) + 
                                        as.numeric(Q8_5) +
                                        (4 - as.numeric(Q8_6))
)



# save derived pre-processed survey data
saveRDS(survey_resp, here("data", "derived", "public", "survey_resp.RDS"))

# need to convert:
# Q7a_2 into four binary variables
# Q13_1_! and Q13_2_1 into numeric
# consider coding Q7 frequency questions as "never" if they skipped the question because
# of no familiarity