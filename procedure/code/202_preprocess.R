library(here)
library(tidyverse)
library(table1)
library(flextable)
library(officer)

#--------------------------------#
#-                              -#
#- PERFORM DESCRIPTIVE ANALYSIS -#
#-                              -#
#--------------------------------#
survey_resp <- readRDS(here("data","derived","public","analysis_hegs_rpr.rds"))

#Define MS Word table layout options
sect_properties <- prop_section(
  page_size = page_size(
    orient = "landscape",
    width = 8.3, height = 11.7
  ),
  type = "continuous",
  page_margins = page_mar()
)

#-----------------------#
#-- Cross tabulations --#
#-----------------------#

#- Table 1) Summary Characteristics of Respondents -#

table1::label(survey_resp$Q3_recoded) <- "Subdiscipline"
table1::label(survey_resp$Q4)         <- "Methods"
table1::label(survey_resp$Q18)        <- "Size of lab"
table1::label(survey_resp$Q19)        <- "Title"
table1::label(survey_resp$Q20)        <- "Gender"
table1::label(survey_resp$Q1)         <- "Age"

Q3_table1 <- table1::table1(~Q4 + Q18 + Q19 + Q20 + Q1  | Q3_recoded, data = survey_resp)
Q4_table1 <- table1::table1(~Q3_recoded + Q18 + Q19 + Q20 + Q1  | Q4, data = survey_resp)

# Output tables using write table and flextable
write.table(Q3_table1 , here("results","tables","Table1_Summary_discipline.csv"), col.names = T, row.names=F, append= T, sep=',')
write.table(Q4_table1 , here("results","tables","Table1_Summary_method.csv"), col.names = T, row.names=F, append= T, sep=',')

t1flex(Q3_table1) %>% 
  save_as_docx(path = here("results","tables","MSWord","Table1_Summary_discipline.docx"),
               pr_section = sect_properties)

t1flex(Q4_table1) %>% 
  save_as_docx(path = here("results","tables","MSWord","Table1_Summary_method.docx"),
               pr_section = sect_properties)


#---------------------------------------------------------------------------------------
#- Table 2) Definitions of Reproducibility -#
table(survey_resp$Q17_1)
table1::label(survey_resp$Q5) <- "Familiarity with reproducibility"

Q3_table2 <- table1::table1(~Q5  | Q3_recoded, data = survey_resp)
Q4_table2 <- table1::table1(~Q5  | Q4, data = survey_resp)

# Output tables using write table and flextable
write.table(Q3_table2 , here("results","tables","Table2_Familiarity_discipline.csv"), col.names = T, row.names=F, append= T, sep=',')
write.table(Q4_table2 , here("results","tables","Table2_Familiarity_method.csv"), col.names = T, row.names=F, append= T, sep=',')

t1flex(Q3_table2) %>% 
  save_as_docx(path = here("results","tables","MSWord","Table2_Familiarity_discipline.docx"),
               pr_section = sect_properties)

t1flex(Q4_table2) %>% 
  save_as_docx(path = here("results","tables","MSWord","Table2_Familiarity_method.docx"),
               pr_section = sect_properties)

#---------------------------------------------------------------------------------------
#- Table 3) Importance of Reproducibility (Q17 and Q8) -#

table1::label(survey_resp$Q8_1) <- "Failing to reproduce a result often means the original finding is false"
table1::label(survey_resp$Q8_2) <- "Failing to reproduce a result rarely detracts from the validity of the original study"
table1::label(survey_resp$Q8_3) <- "If a researcher does not share the data used in their study, I trust the results less"
table1::label(survey_resp$Q8_4) <- "It is important for students to attempt reproductions as part of their training"
table1::label(survey_resp$Q8_5) <- "To be credible, research must be reproducible"
table1::label(survey_resp$Q8_6) <- "Reproducibility is incompatible with the epistemologies within my subfield"

Q3_table3a <- table1::table1(~Q8_1 + Q8_2 +  Q8_3 +  Q8_4 +  Q8_5 +  Q8_6 | Q3_recoded, data = survey_resp)
Q4_table3a <- table1::table1(~Q8_1 + Q8_2 +  Q8_3 +  Q8_4 +  Q8_5 +  Q8_6  | Q4, data = survey_resp)

# Output tables using write table and flextable
write.table(Q3_table3a , here("results","tables","Table3a_Credibility_discipline.csv"), col.names = T, row.names=F, append= T, sep=',')
write.table(Q4_table3a , here("results","tables","Table3a_Credibility_method.csv"), col.names = T, row.names=F, append= T, sep=',')

t1flex(Q3_table3a) %>% 
  save_as_docx(path = here("results","tables","MSWord","Table3a_Credibility_discipline.docx"),
               pr_section = sect_properties)

t1flex(Q4_table3a) %>% 
  save_as_docx(path = here("results","tables","MSWord","Table3a_Credibility_method.docx"),
               pr_section = sect_properties)


table1::label(survey_resp$Q17_1) <- "Validating research findings"
table1::label(survey_resp$Q17_2) <- "Reducing the risk of errors in the research process"
table1::label(survey_resp$Q17_3) <- "Increasing trust in study results"
table1::label(survey_resp$Q17_4) <- "Preventing duplication of efforts in future research projects"
table1::label(survey_resp$Q17_5) <- "Establishing credibility of research in geography"
table1::label(survey_resp$Q17_6) <- "Establishing credibility of research in your primary subfield"
table1::label(survey_resp$Q17_7) <- "Communicating research to academics"
table1::label(survey_resp$Q17_8) <- "Communicating research to practitioners"
table1::label(survey_resp$Q17_9) <- "Training geography students"
table1::label(survey_resp$Q17_10) <- "Meta-analyses"

Q3_table3b <- table1::table1(~Q17_1 + Q17_2 +  Q17_3 +  Q17_4 +  Q17_5 +  Q17_6 + Q17_7 + Q17_8 + Q17_9 + Q17_10 | Q3_recoded, data = survey_resp)
Q4_table3b <- table1::table1(~Q17_1 + Q17_2 +  Q17_3 +  Q17_4 +  Q17_5 +  Q17_6 + Q17_7 + Q17_8 + Q17_9 + Q17_10  | Q4, data = survey_resp)

# Output tables using write table and flextable
write.table(Q3_table3b , here("results","tables","Table3b_Importance_discipline.csv"), col.names = T, row.names=F, append= T, sep=',')
write.table(Q4_table3b , here("results","tables","Table3b_Importance_method.csv"), col.names = T, row.names=F, append= T, sep=',')

t1flex(Q3_table3b) %>% 
  save_as_docx(path = here("results","tables","MSWord","Table3b_Importance_discipline.docx"),
               pr_section = sect_properties)

t1flex(Q4_table3b) %>% 
  save_as_docx(path = here("results","tables","MSWord","Table3b_Importance_method.docx"),
               pr_section = sect_properties)

#---------------------------------------------------------------------------------------
#- Table 4) Proportion of Reproducible Research (Q13) -#
table1::label(survey_resp$Q13_1) <- "Percentage of published results that are reproducible: Geography"
table1::label(survey_resp$Q13_2) <- "Percentage of published results that are reproducible: Subfield"

Q3_table4 <- table1::table1(~Q13_1 + Q13_2 | Q3_recoded, data = survey_resp)
Q4_table4 <- table1::table1(~Q13_1 + Q13_2  | Q4, data = survey_resp)

# Output tables using write table and flextable
write.table(Q3_table4 , here("results","tables","Table4_PublishedResults_discipline.csv"), col.names = T, row.names=F, append= T, sep=',')
write.table(Q4_table4 , here("results","tables","Table4_PublishedResults_method.csv"), col.names = T, row.names=F, append= T, sep=',')

t1flex(Q3_table4) %>% 
  save_as_docx(path = here("results","tables","MSWord","Table4_PublishedResults_discipline.docx"),
               pr_section = sect_properties)

t1flex(Q4_table4) %>% 
  save_as_docx(path = here("results","tables","MSWord","Table4_PublishedResults_method.docx"),
               pr_section = sect_properties)

#---------------------------------------------------------------------------------------
#- Table 5) Practices (Q7) -#
table1::label(survey_resp$Q7a) <- "Familiarity with open source software"
table1::label(survey_resp$Q7b) <- "Familiarity with lab, field, or computational notebooks"
table1::label(survey_resp$Q7c) <- "Familiarity with sharing or archiving data"
table1::label(survey_resp$Q7d) <- "Familiarity with publicly sharing code or scripts"
table1::label(survey_resp$Q7e) <- "Familiarity with pre-registering research designs or protocols"

Q3_table5 <- table1::table1(~Q7a + Q7b + Q7c + Q7d + Q7e | Q3_recoded, data = survey_resp)
Q4_table5 <- table1::table1(~Q7a + Q7b + Q7c + Q7d + Q7e | Q4, data = survey_resp)

# Output tables using write table and flextable
write.table(Q3_table5 , here("results","tables","Table5_PracticeFam_discipline.csv"), col.names = T, row.names=F, append= T, sep=',')
write.table(Q4_table5 , here("results","tables","Table5_PracticeFam_method.csv"), col.names = T, row.names=F, append= T, sep=',')

t1flex(Q3_table5) %>% 
  save_as_docx(path = here("results","tables","MSWord","Table5_PracticeFam_discipline.docx"),
               pr_section = sect_properties)

t1flex(Q4_table5) %>% 
  save_as_docx(path = here("results","tables","MSWord","Table5_PracticeFam_method.docx"),
               pr_section = sect_properties)


#---------------------------------------------------------------------------------------
#- Table 6) Practices  (Q7 Frequency and Q9) -#
table1::label(survey_resp$Q7a_1) <- "Frequency of using open source software"
table1::label(survey_resp$Q7b_1) <- "Frequency of using lab, field, or computational notebooks"
table1::label(survey_resp$Q7c_1) <- "Frequency of using sharing or archiving data"
table1::label(survey_resp$Q7d_1) <- "Frequency of using publicly sharing code or scripts"
table1::label(survey_resp$Q7e_1) <- "Frequency of using pre-registering research designs or protocols"

Q3_table6a <- table1::table1(~Q7a_1 + Q7b_1 + Q7c_1 + Q7d_1 + Q7e_1 | Q3_recoded, data = survey_resp)
Q4_table6a <- table1::table1(~Q7a_1 + Q7b_1 + Q7c_1 + Q7d_1 + Q7e_1 | Q4, data = survey_resp)

# Output tables using write table and flextable
write.table(Q3_table6a , here("results","tables","Table6a_PracticeFreq_discipline.csv"), col.names = T, row.names=F, append= T, sep=',')
write.table(Q4_table6a , here("results","tables","Table6a_PracticeFreq_method.csv"), col.names = T, row.names=F, append= T, sep=',')

t1flex(Q3_table6a) %>% 
  save_as_docx(path = here("results","tables","MSWord","Table6a_PracticeFreq_discipline.docx"),
               pr_section = sect_properties)

t1flex(Q4_table6a) %>% 
  save_as_docx(path = here("results","tables","MSWord","Table6a_PracticeFreq_method.docx"),
               pr_section = sect_properties)



table1::label(survey_resp$Q9_1) <- "Thought about the reproducibility of your research"
table1::label(survey_resp$Q9_2) <- "Spoke with colleagues about reproducibility"
table1::label(survey_resp$Q9_3) <- "Questioned the reproducibility of published research"
table1::label(survey_resp$Q9_4) <- "Published original data with your study"
table1::label(survey_resp$Q9_5) <- "Published code and/or protocols with your study"
table1::label(survey_resp$Q9_6) <- "Considered reproducibility while peer reviewing a grant or publication"
table1::label(survey_resp$Q9_7) <- "Attempted to reproduce your own or someone else's research"

Q3_table6b <- table1::table1(~Q9_1 + Q9_2 + Q9_3 + Q9_4 + Q9_5 + Q9_6 + Q9_7 | Q3_recoded, data = survey_resp)
Q4_table6b <- table1::table1(~Q9_1 + Q9_2 + Q9_3 + Q9_4 + Q9_5 + Q9_6 + Q9_7 | Q4, data = survey_resp)

# Output tables using write table and flextable
write.table(Q3_table6b , here("results","tables","Table6b_Practices_discipline.csv"), col.names = T, row.names=F, append= T, sep=',')
write.table(Q4_table6b , here("results","tables","Table6b_Practices_method.csv"), col.names = T, row.names=F, append= T, sep=',')

t1flex(Q3_table6b) %>% 
  save_as_docx(path = here("results","tables","MSWord","Table6b_Practices_discipline.docx"),
               pr_section = sect_properties)

t1flex(Q4_table6b) %>% 
  save_as_docx(path = here("results","tables","MSWord","Table6b_Practices_method.docx"),
               pr_section = sect_properties)

#---------------------------------------------------------------------------------------
#- Table 7) Characteristics of those who conducted reproductions and (Q11 Q12) -#

reproduction_analysis <- survey_resp %>% filter(consensus %in% c(1,4))
table(reproduction_analysis$consensus)

table1::label(reproduction_analysis$Q11_1) <- "Proportion of results: Identically reproduce"
table1::label(reproduction_analysis$Q11_2) <- "Proportion of results: Partially reproduce"
table1::label(reproduction_analysis$Q11_3) <- "Proportion of results: Fail to reproduce"
table1::label(reproduction_analysis$Q12_1) <- "Ability to access the original study's data"
table1::label(reproduction_analysis$Q12_2) <- "Ability to access the original study's code or analytic procedures"
table1::label(reproduction_analysis$Q12_3) <- "Ability to recreate the computational environment (hardware, software, etc.)"
table1::label(reproduction_analysis$Q12_4) <- "Ability to submit your findings for publication"
table1::label(reproduction_analysis$rp_conservative) <- "Conservative reproduction"
table1::label(reproduction_analysis$rp_liberal) <- "Liberal reproduction"
table1::label(survey_resp$Q10_recoded) <- "Reason for reproduction attempt"

rp_table7 <- table1::table1(~Q10_recoded | Q9_7 , data = survey_resp)

Q3_table7 <- table1::table1(~Q11_1 + Q11_2 + Q11_3 + Q12_1 + Q12_2 + Q12_3 + Q12_4 + rp_conservative + rp_liberal | Q3_recoded, data = reproduction_analysis)
Q4_table7 <- table1::table1(~Q11_1 + Q11_2 + Q11_3 + Q12_1 + Q12_2 + Q12_3 + Q12_4 + rp_conservative + rp_liberal  | Q4, data = reproduction_analysis)


table7_rp_given_some <- table1::table1(~rp_conservative + rp_liberal + Q11_1 + Q11_2 | access_some_data_code, data = reproduction_analysis)
table7_rp_given_all <- table1::table1(~rp_conservative + rp_liberal + Q11_1 + Q11_2 | access_all_data_code, data = reproduction_analysis)


# Output tables using write table and flextable
write.table(Q3_table7 , here("results","tables","Table7a_RPAttempts_discipline.csv"), col.names = T, row.names=F, append= T, sep=',')
write.table(Q4_table7 , here("results","tables","Table7a_RPAttempts_method.csv"), col.names = T, row.names=F, append= T, sep=',')
write.table(table7_rp_given_all , here("results","tables","Table7b_RP_all_data_code.csv"), col.names = T, row.names=F, append= T, sep=',')
write.table(table7_rp_given_some, here("results","tables","Table7b_RP_some_data_code.csv"), col.names = T, row.names=F, append= T, sep=',')
write.table(rp_table7, here("results","tables","Table7_RP_reasons.csv"), col.names = T, row.names=F, append= T, sep=',')


t1flex(Q3_table7) %>% 
  save_as_docx(path = here("results","tables","MSWord","Table7a_RPAttempts_discipline.docx"),
               pr_section = sect_properties)

t1flex(Q4_table7) %>% 
  save_as_docx(path = here("results","tables","MSWord","Table7a_RPAttempts_method.docx"),
               pr_section = sect_properties)

t1flex(table7_rp_given_all) %>% 
  save_as_docx(path = here("results","tables","MSWord","Table7b_RP_all_data_code.docx"),
               pr_section = sect_properties)

t1flex(table7_rp_given_some) %>% 
  save_as_docx(path = here("results","tables","MSWord","Table7b_RP_some_data_code.docx"),
               pr_section = sect_properties)

t1flex(rp_table7) %>% 
  save_as_docx(path = here("results","tables","MSWord","Table7_RP_reasons.docx"),
               pr_section = sect_properties)

#- Exploratory analysis about access to data and code with respect to reproduction results
all_partial_reproduction <- reproduction_analysis %>% filter(Q11_2 == "All")
some_partial_reproduction <- reproduction_analysis %>% filter(Q11_2 == "Some")
all_identical_reproduction <- reproduction_analysis %>% filter(Q11_1 == "All")
some_identical_reproduction <- reproduction_analysis %>% filter(Q11_1 == "Some")

table1::label(all_partial_reproduction$Q12_1) <- "Access to study's data"
table1::label(some_partial_reproduction$Q12_1) <- "Access to study's data"
table1::label(all_identical_reproduction$Q12_1) <- "Access to study's data"
table1::label(some_identical_reproduction$Q12_1) <- "Access to study's data"

table1::label(all_partial_reproduction$Q12_2) <- "Access to study's code"
table1::label(some_partial_reproduction$Q12_2) <- "Access to study's code"
table1::label(all_identical_reproduction$Q12_2) <- "Access to study's code"
table1::label(some_identical_reproduction$Q12_2) <- "Access to study's code"

all_partial <- table1::table1(~Q12_1 | Q12_2 , data = all_partial_reproduction) 
some_partial <- table1::table1(~Q12_1 | Q12_2 , data = some_partial_reproduction)
all_identical <- table1::table1(~Q12_1 | Q12_2 , data = all_identical_reproduction)
some_identical <- table1::table1(~Q12_1 | Q12_2 , data = some_identical_reproduction)


write.table(all_partial, here("results","tables","Data_Code_Matrix_all_partial.csv"), col.names = T, row.names=F, append= T, sep=',')
write.table(some_partial, here("results","tables","Data_Code_Matrix_some_partial.csv"), col.names = T, row.names=F, append= T, sep=',')
write.table(all_identical, here("results","tables","Data_Code_Matrix_all_identical.csv"), col.names = T, row.names=F, append= T, sep=',')
write.table(some_identical, here("results","tables","Data_Code_Matrix_some_identical.csv"), col.names = T, row.names=F, append= T, sep=',')



#---------------------------------------------------------------------------------------
#- Table 8) Barriers -#
table1::label(survey_resp$Q14_1) <- "Fraud (e.g., fabricated or falsified results)"
table1::label(survey_resp$Q14_2) <- "Pressure to publish for career advancement"
table1::label(survey_resp$Q14_3) <- "Insufficient oversight or mentoring"
table1::label(survey_resp$Q14_4) <- "Lack of publishing raw data"
table1::label(survey_resp$Q14_5) <- "Lack of publishing research protocols or computer code"
table1::label(survey_resp$Q14_6) <- "Lack of publishing full results"
table1::label(survey_resp$Q14_7) <- "Differences in the software processing environment"
table1::label(survey_resp$Q14_8) <- "Use of proprietary data or software"
table1::label(survey_resp$Q14_9) <- "Complexity and variability of geographic systems"
table1::label(survey_resp$Q14_10) <- "Random effects"
table1::label(survey_resp$Q14_11) <- "Insufficient documentation about study data (metadata)"
table1::label(survey_resp$Q14_12) <- "Researcher positionality"

Q3_table8 <- table1::table1(~Q14_1 + Q14_2 + Q14_3 + Q14_4 + Q14_5 + Q14_6 + Q14_7 + Q14_8 + 
                              Q14_9 + Q14_10 + Q14_11 + Q14_12 | Q3_recoded, data = survey_resp)
Q4_table8 <- table1::table1(~Q14_1 + Q14_2 + Q14_3 + Q14_4 + Q14_5 + Q14_6 + Q14_7 + Q14_8 + 
                              Q14_9 + Q14_10 + Q14_11 + Q14_12 | Q4, data = survey_resp)

# Output tables using write table and flextable
write.table(Q3_table8 , here("results","tables","Table8_Barriers_discipline.csv"), col.names = T, row.names=F, append= T, sep=',')
write.table(Q4_table8 , here("results","tables","Table8_Barriers_method.csv"), col.names = T, row.names=F, append= T, sep=',')

t1flex(Q3_table8) %>% 
  save_as_docx(path = here("results","tables","MSWord","Table8_Barriers_discipline.docx"),
               pr_section = sect_properties)

t1flex(Q4_table8) %>% 
  save_as_docx(path = here("results","tables","MSWord","Table8_Barriers_method.docx"),
               pr_section = sect_properties)



#---------------------------------------------------------------------------------------
#- Summary Table for Results Section -#

#- Summary measure on definitions, familiarity, practices, and barriers
#------- Familiarity : threshold is "somewhat"  (Q7a + Q7b + Q7c + Q7d + Q7e)
#------- Practices :   threshold is "most of the time" (Q7a_1 + Q7b_1 + Q7c_1 + Q7d_1 + Q7e_1)
#------- Barriers :    threshold is "occasionally"  (Q14_1 + Q14_2 + Q14_3 + Q14_4 + Q14_5)

table(survey_resp$Q14_1)
levels(survey_resp$Q7a_1)
survey_resp <- survey_resp %>% mutate(#RECODE FAMILIARITY VARIABLES
                                      Q7a_bin = as.numeric(as.character(recode(Q7a, "To a great extent" = "1",
                                                                               "Somewhat" = "1",
                                                                               .default = "0"))),
                                      Q7b_bin = as.numeric(as.character(recode(Q7b, "To a great extent" = "1",
                                                                               "Somewhat" = "1",
                                                                               .default = "0"))),
                                      Q7c_bin = as.numeric(as.character(recode(Q7c, "To a great extent" = "1",
                                                                               "Somewhat" = "1",
                                                                               .default = "0"))),
                                      Q7d_bin = as.numeric(as.character(recode(Q7d, "To a great extent" = "1",
                                                                                "Somewhat" = "1",
                                                                                .default = "0"))),
                                      Q7e_bin = as.numeric(as.character(recode(Q7e, "To a great extent" = "1",
                                                                               "Somewhat" = "1",
                                                                               .default = "0"))),
                                      #RECODE PRACTICES VARIABLES
                                      Q7a_1_bin = as.numeric(as.character(recode(Q7a_1, "Always" = "1",
                                                                               "Most of the time" = "1",
                                                                               .default = "0"))),
                                      Q7b_1_bin = as.numeric(as.character(recode(Q7b_1, "Always" = "1",
                                                                               "Most of the time" = "1",
                                                                               .default = "0"))),
                                      Q7c_1_bin = as.numeric(as.character(recode(Q7c_1, "Always" = "1",
                                                                               "Most of the time" = "1",
                                                                               .default = "0"))),
                                      Q7d_1_bin = as.numeric(as.character(recode(Q7d_1, "Always" = "1",
                                                                               "Most of the time" = "1",
                                                                               .default = "0"))),
                                      Q7e_1_bin = as.numeric(as.character(recode(Q7e_1, "Always" = "1",
                                                                               "Most of the time" = "1",
                                                                               .default = "0"))),
                                      #RECODE BARRIERS VARIABLES
                                      Q14_1_bin = as.numeric(as.character(recode(Q14_1, "Frequently" = "1",
                                                                                 "Occasionally" = "1",
                                                                                 .default = "0"))),
                                      Q14_2_bin = as.numeric(as.character(recode(Q14_2, "Frequently" = "1",
                                                                                 "Occasionally" = "1",
                                                                                 .default = "0"))),
                                      Q14_3_bin = as.numeric(as.character(recode(Q14_3, "Frequently" = "1",
                                                                                 "Occasionally" = "1",
                                                                                 .default = "0"))),
                                      Q14_4_bin = as.numeric(as.character(recode(Q14_4, "Frequently" = "1",
                                                                                 "Occasionally" = "1",
                                                                                 .default = "0"))),
                                      Q14_5_bin = as.numeric(as.character(recode(Q14_5, "Frequently" = "1",
                                                                                 "Occasionally" = "1",
                                                                                 .default = "0"))),
                                      Q14_6_bin = as.numeric(as.character(recode(Q14_6, "Frequently" = "1",
                                                                                 "Occasionally" = "1",
                                                                                 .default = "0"))),
                                      Q14_7_bin = as.numeric(as.character(recode(Q14_7, "Frequently" = "1",
                                                                                 "Occasionally" = "1",
                                                                                 .default = "0"))),
                                      Q14_8_bin = as.numeric(as.character(recode(Q14_8, "Frequently" = "1",
                                                                                 "Occasionally" = "1",
                                                                                 .default = "0"))),
                                      Q14_9_bin = as.numeric(as.character(recode(Q14_9, "Frequently" = "1",
                                                                                 "Occasionally" = "1",
                                                                                 .default = "0"))),
                                      Q14_10_bin = as.numeric(as.character(recode(Q14_10, "Frequently" = "1",
                                                                                 "Occasionally" = "1",
                                                                                 .default = "0"))),
                                      Q14_11_bin = as.numeric(as.character(recode(Q14_11, "Frequently" = "1",
                                                                                 "Occasionally" = "1",
                                                                                 .default = "0"))),
                                      Q14_12_bin = as.numeric(as.character(recode(Q14_12, "Frequently" = "1",
                                                                                 "Occasionally" = "1",
                                                                                 .default = "0"))))
table(survey_resp$Q7b,survey_resp$Q7b_bin) #check that recoding worked properly
table(survey_resp$Q7b_1,survey_resp$Q7b_1_bin)
table(survey_resp$Q14_1,survey_resp$Q14_1_bin)

# Summary measures
survey_resp <- survey_resp %>% mutate(definitions = definition_sum,
                                      familiar  = Q7a_bin + Q7b_bin + Q7c_bin + Q7d_bin + Q7e_bin,
                                      practices = Q7a_1_bin + Q7b_1_bin + Q7c_1_bin + Q7d_1_bin + Q7e_1_bin,
                                      barriers = Q14_1_bin + Q14_2_bin + Q14_3_bin + Q14_4_bin + Q14_5_bin + Q14_6_bin
                                      + Q14_7_bin + Q14_8_bin + Q14_9_bin + Q14_10_bin + Q14_11_bin + Q14_12_bin)
table(survey_resp$definitions)
table(survey_resp$familiar)
table(survey_resp$practices)
table(survey_resp$barriers)

table1::label(survey_resp$defimitions) <- "Definition of reproducibility"
table1::label(survey_resp$familiar) <-  "Familiarity with reproducible practices"
table1::label(survey_resp$practices) <- "Experience with reproducible practices"
table1::label(survey_resp$barriers) <-  "Barriers to reproducibility"

Q3_table9 <- table1::table1(~definitions + familiar + practices + barriers| Q3_recoded, data = survey_resp)
Q4_table9 <- table1::table1(~definitions + familiar + practices + barriers | Q4, data = survey_resp)

# Output tables using write table and flextable
write.table(Q3_table9 , here("results","tables","Table9_Master_Table_discipline.csv"), col.names = T, row.names=F, append= T, sep=',')
write.table(Q4_table9 , here("results","tables","Table9_Master_Table_method.csv"), col.names = T, row.names=F, append= T, sep=',')

t1flex(Q3_table9) %>% 
  save_as_docx(path = here("results","tables","MSWord","Table9_Master_Table_discipline.docx"),
               pr_section = sect_properties)

t1flex(Q4_table9) %>% 
  save_as_docx(path = here("results","tables","MSWord","Table9_Master_Table_method.docx"),
               pr_section = sect_properties)


#---------------------------------------------------------------------------------------


