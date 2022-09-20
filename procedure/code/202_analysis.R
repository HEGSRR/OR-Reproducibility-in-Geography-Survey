library(here)
library(tidyverse)

#--------------------------------#
#-                              -#
#- PERFORM DESCRIPTIVE ANALYSIS -#
#-                              -#
#--------------------------------#
survey_resp <- read.csv(here("data","derived","public","hegsrr_analysis_reprod.csv"))

#- Define variable lists -#
demo <- c("Q1", "Q2", "Q3","Q4","Q5", "Q18", "Q19", "Q20", "Q21", "Q22")

practice <- c("Q7a","Q7a_1","Q7a_3", 
              "Q7b","Q7b_1",
              "Q7c","Q7c_1","Q7c_2","Q7c_3",
              "Q7d","Q7d_1","Q7d_2",
              "Q7e","Q7e_1",
              "Q9_1", "Q9_2", "Q9_3", "Q9_4",
              "Q9_5", "Q9_6", "Q9_7",
              "Q11_1", "Q11_2", "Q11_3",
              "Q12_1", "Q12_2", "Q12_3", "Q12_4")

importance <- c("Q8_1", "Q8_2", "Q8_3", 
                "Q8_4", "Q8_5", "Q8_6",
                "Q17_1", "Q17_2", "Q17_3", "Q17_4",
                "Q17_5", "Q17_6", "Q17_7", "Q17_8",
                "Q17_9", "Q17_10")

barriers <- c("Q14_1", "Q14_2", "Q14_3", "Q14_4", 
              "Q14_5", "Q14_6", "Q14_7", "Q14_8",
              "Q14_9", "Q14_10", "Q14_11", "Q14_12",
              "Q16", "Q19_9_TEXT", "Q20_5_TEXT", "Q21_7_TEXT")

numeric_vars <- c(demo, practice, importance, barriers)


char_vars <- c("Q3_5_TEXT", "Q6", "Q7a_2", "Q12a", 
               "Q13_1_1", "Q13_2_1", "Q15", "Q16_5_TEXT",
               "Q17a")

all_vars <- c(numeric_vars, char_vars)

#-----------------#  
#-- Frequencies --#
#-----------------#
for (i in all_vars){
  Frequency <-  (table(raw_filtered[[i]]))
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
  mytable <- table(raw_filtered[[i]],raw_filtered$Q3)
  xtab <-  round(prop.table(mytable, margin = 2) * 100,2) 
  write.csv(xtab, here("results","tables","Field",paste0("Q4_Xtab_",i, ".csv", sep = "")))
}

#-Q4-#
for (i in numeric_vars){
  mytable <- table(raw_filtered[[i]],raw_filtered$Q4)
  xtab <-  round(prop.table(mytable, margin = 2) * 100,2) 
  write.csv(xtab, here("results","tables","Method",paste0("Q4_Xtab_",i, ".csv", sep = "")))
}

#-Q5-#
for (i in numeric_vars){
  mytable <- table(raw_filtered[[i]],raw_filtered$Q5)
  xtab <-  round(prop.table(mytable, margin = 2) * 100,2) 
  write.csv(xtab, here("results","tables","Familiarity",paste0("Q5_Xtab_",i, ".csv", sep = "")))
}


#-Age-#
for (i in numeric_vars){
  mytable <- table(raw_filtered[[i]],raw_filtered$Q1)
  xtab <-  round(prop.table(mytable, margin = 2) * 100,2) 
  write.csv(xtab, here("results","tables","Age",paste0("Age_Xtab_",i, ".csv", sep = "")))
}

ftable(data = survey_resp, Q3 ~ Q5)

ftable(data = survey_resp, Q4 ~ Q5)

# how did folks define "reproducibility" ?
survey_resp %>% select(Q3, Q4, Q5, Q6) %>%
  filter(Q5 != "Not at all") %>%
  arrange(Q5, Q4) %>%
  write.csv(here("results", "tables", "definitions.csv"))

# convert extent questions into factors
extent <- c("To a great extent", "Somewhat", "Very little", "Not at all", "")
extentQs <- c("Q5", "Q7a","Q7b", "Q7c", "Q7d", "Q7e")
survey_resp[extentQs] <- lapply(survey_resp[extentQs], factor, levels=extent, ordered = TRUE)

# convert agree questions into factors
agree <- c("Strongly disagree", "Disagree", "Agree", "Strongly agree", "")
agreeQs <- c()



