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



# how did folks define "reproducibility" ?
survey_resp %>% select(Q3, Q4, Q5, Q6) %>%
  filter(Q5 != "Not at all") %>%
  arrange(Q5, Q4) %>%
  write.csv(here("results", "tables", "definitions.csv"))

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

# save revised survey data
saveRDS(survey_resp, here("data", "derived", "public", "survey_resp.RDS"))

# optionally, load revised survey data
survey_resp <- readRDS(here("data", "derived", "public", "survey_resp.RDS"))


##### SUMMARIZING RESULTS #####

# Summarize the survey data
summary(survey_resp)



# need to convert:
# Q7a_2 into four binary variables
# Q13_1_! and Q13_2_1 into numeric
# consider coding Q7 frequency questions as "never" if they skipped the question because
# of no familiarity

# crosstab sub-fields and methods
ftable(data = survey_resp, Q4 ~ Q3)

# crosstab familiarity with sub-fields and methods
ftable(data = survey_resp, Q5 ~ Q3 + Q4)

# calculate familiarity with reproducible practices
survey_resp <- survey_resp %>% mutate(familiar = as.numeric(Q7a) + 
                                        as.numeric(Q7b) + as.numeric(Q7c) +
                                        as.numeric(Q7d) + as.numeric(Q7e))

# summarize and ANOVA familiarity with practices by subfield
group_by(survey_resp, Q3) %>%
  summarise(
    count = n(),
    mean = mean(familiar, na.rm = TRUE),
    sd = sd(familiar, na.rm = TRUE)
  )

aov(familiar ~ Q3, data=survey_resp) %>% summary()
# there are significant differences between sub-fields, with Methods / Spatial
# analysis and Phsycial geography both more familiar than nature/society or
# human geography

# calculate use of reproducible practices
# not meaningful until we replace NA with 0 for respondents that skipped Q
# due to lack of familiarity

#### Summarize reproducible research practices ####
# there must be a prettier option for a crosstabulation with marginal sums!

summary(survey_resp$Q7a)
summary(survey_resp$Q7a_1)
ftable(data = survey_resp, Q7a_1 ~ Q7a)
summary(survey_resp$Q7a_3)
ftable(data = survey_resp, Q7a_3 ~ Q7a)
# FAMILIARITY with open source software outstrips USE of open source software
# and of documenting the computational environment
# low percentage of researchers "always" share information about computational environment

summary(survey_resp$Q7b)
summary(survey_resp$Q7b_1)
ftable(data = survey_resp, Q7b_1 ~ Q7b)
# FAMILIARITY with notebooks also outstrips their USE 
# less than 17% of researchers always use notebooks (lab, field, or computational)
# less than 40% use them most of the time

summary(survey_resp$Q7c)
summary(survey_resp$Q7c_1)
ftable(data = survey_resp, Q7c_1 ~ Q7c)
summary(survey_resp$Q7c_2)
ftable(data = survey_resp, Q7c_2 ~ Q7c)
summary(survey_resp$Q7c_3)
ftable(data = survey_resp, Q7c_3 ~ Q7c)
# most researchers are familiar with sharing/archiving data, but still only 16%
# report always doing so
# use of DOIs is inconsistent and use of metadata is rare

summary(survey_resp$Q7d)
summary(survey_resp$Q7d_1)
ftable(data = survey_resp, Q7d_1 ~ Q7d)
summary(survey_resp$Q7d_2)
ftable(data = survey_resp, Q7d_2 ~ Q7d)
# most researchers are at least somewhat familiar with sharing code or scripts
# but less than 40% actually do so all or most of the time
# and only 14% use version control software some or most of the time

summary(survey_resp$Q7e)
summary(survey_resp$Q7e_1)
ftable(data = survey_resp, Q7e_1 ~ Q7e)
# familiarity with pre-analysis plan registration is rare:
# 48% of respondents have no familiarity
# only 6 respondents reported using pre-analysis registrations all or most of the time

# In Sum, most geographers are at least somewhat familiar with open source software,
# data sharing, and code sharing.
# there are large gaps in implementation across all practices
# some practices are practically unknown in geography, including metadata, 
# version control software, and pre-analysis plan registration.


##### Summarize Beliefs #####

survey_resp %>% select(starts_with("Q8")) %>% summary()

# calculate familiarity with reproducible practices
survey_resp <- survey_resp %>% mutate(belief = as.numeric(Q8_1) + 
                                        (4 - as.numeric(Q8_2)) + 
                                        as.numeric(Q8_3) +
                                        as.numeric(Q8_4) + 
                                        as.numeric(Q8_5) +
                                        (4 - as.numeric(Q8_6))
                                      )
# a majority of geographers believe a failed reproduction does not disprove
# the original study, and geographers are split on whether it detracts from
# the original study's validity
# the most agreement is for students attempting reproductions as part of training

survey_resp %>% select(starts_with("Q8")) %>% lapply(as.numeric) %>% lapply(summary, na.rm=TRUE)
# we can see that in aggregate, geographers do not tend to strongly agree or disagree
# with beliefs about reproducibility
# most in favor of students conducting replications, and reproducibility contributing
# to credibility, and even some degree of compatibility with epistemology in the field
# however geographers are, on average, neutral about loss of validity for failed reproductions
# or loss of trust for studies without available data. 
# we disagree with a failed reproduction falsifying the original study.


# summarize and ANOVA beliefs with practices by subfield
group_by(survey_resp, Q3) %>%
  summarise(
    count = n(),
    mean = mean(belief, na.rm = TRUE),
    sd = sd(belief, na.rm = TRUE)
  )

aov(belief ~ Q3, data=survey_resp) %>% summary()
# again, significant differences in aggregate beliefs about the role of 
# reproducibility in subfields, with physical holding strongest affirmative
# beliefs, then methods, nature/society, and human geography
