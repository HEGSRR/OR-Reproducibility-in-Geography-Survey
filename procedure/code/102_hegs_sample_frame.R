#-------------------------------#
#-- Load libraries and set wd --#
#-------------------------------#

library(tidyverse)
library(stringr)
setwd("/Users/sarahbardin/Desktop/Scopus/data/intermediate")

set.seed(120689)

#------------------------------------------------------------------#
#-- Read in data and restrict to author's latest available email --#
#------------------------------------------------------------------#
scopus <- read_csv("int_scopus_long.csv")

#-Keep only documents that are articles with valid author id information-#
articles <- scopus %>% 
              filter(Document.Type == "Article" & AuthID != "[No author id available]")

#-For each author, identify if they have ever been a corresponding author-#
#-We will only have email information for the corresponding author, so we will restrict to these authors-#
articles <- articles %>% 
                group_by(AuthID) %>% 
                mutate(email_flag = max(CorrespondAuth))

corresponding_authors <- articles %>%
                    filter(email_flag == 1) %>%
                    transmute(Name,
                              AuthID,
                              Year,
                              Affiliation,
                              email,
                              SourceSubjectArea)

#-Identify the years in which we have non-missing emails for the author, flag the latest email year-#
#-We want to use the latest available contact information to improve likelihood of response-#
latest_contact <- corresponding_authors %>%
                      group_by(AuthID) %>%
                      mutate(email_year = ifelse(!is.na(email), Year, 0),
                             latest_email_year = max(email_year),
                             email = tolower(email))

latest_contact_email <- latest_contact %>%
                            filter(latest_email_year == Year & !is.na(email))

#-----------------------------------------------------------------------------------------------#
#-- Deduplicate and output final sampling frame                                               --#
#- Note: Some authors may have served as corresponding author more than once in a single year  -#
#-   and have used different emails when doing so. We want to retain only one email per author -#
#-----------------------------------------------------------------------------------------------#

#-keep unique emails for each AuthID-#
contact_email_dedup <- latest_contact_email %>%
                          group_by(AuthID) %>%
                          distinct(email, .keep_all= TRUE)

#-There are 1,612 instances where the same email is used by more than one distinct AuthID-# 
#-These appear to be potential spouses; shared last name but different first initial-#
#-These may also reflect name changes due to marriage or divorce, when last names differ-@
#-We will remove these cases of multiple AuthIDs associated to the same email-#
check_duplicates <-  contact_email_dedup[duplicated(contact_email_dedup$email),] 
contact_email_dedup <- contact_email_dedup[!duplicated(contact_email_dedup$email),] 

length(unique(contact_email_dedup$AuthID)) ## There are 29,828 authors in our population. 
                                           ## We need to pick emails for 383 observations

email_handles <- c("@gmail", "@outlook", "@hotmail", "@yahoo", "@foxmail", "@aol")
handles <- str_c(as.character(email_handles), collapse = "|")

contact_email_dedup <- contact_email_dedup %>% 
                  add_count(AuthID, name = "total_emails") %>%
                  mutate(personal_email_flag = if_else(str_detect(email, handles), 1, 0), .before = 1) 
table(contact_email_dedup$personal_email_flag) ## pre-removal

##-remove records for AuthID that contain personal email accounts (personal_email_flag == 0)
##-so long as these records aren't the only emails we have for the AuthID (total_email == total_personal_emails)
contact_email_dedup <-  contact_email_dedup %>% 
  group_by(AuthID) %>%
  mutate(Freq = ifelse(row_number() == n(), sum(personal_email_flag) ,NA),
         total_personal_emails = max(Freq, na.rm = T)) %>%
  filter(personal_email_flag == 0 | total_personal_emails == total_emails)
table(contact_email_dedup$personal_email_flag) ## post-removal, dropped 82 records

# confirm we still have the same number of unique AuthIDs and then dedup on AuthID
length(unique(contact_email_dedup$AuthID)) 

contact_authid_dedup <- contact_email_dedup[!duplicated(contact_email_dedup$AuthID),]
table(contact_authid_dedup$personal_email_flag) 

# Associate authors with research areas based on most recent corresponding author publication subject area
contact_authid_dedup$ResearchAreas <- ifelse(contact_authid_dedup$SourceSubjectArea == "Archeology (arts and humanities)" | 
         contact_authid_dedup$SourceSubjectArea == "Architecture" |
         contact_authid_dedup$SourceSubjectArea == "Arts and Humanities (miscellaneous)" | 
         contact_authid_dedup$SourceSubjectArea == "Cultural Studies" |
         contact_authid_dedup$SourceSubjectArea == "History" |
         contact_authid_dedup$SourceSubjectArea == "Paleontology", "Cultural Geography",
         ifelse(contact_authid_dedup$SourceSubjectArea == "Computers in Earth Sciences" |
                  contact_authid_dedup$SourceSubjectArea == "Earth and Planetary Sciences (miscellaneous)" |
                  contact_authid_dedup$SourceSubjectArea == "Earth-Surface Processes" |
                  contact_authid_dedup$SourceSubjectArea == "General Earth and Planetary Sciences" |
                  contact_authid_dedup$SourceSubjectArea == "Oceanography" |
                  contact_authid_dedup$SourceSubjectArea == "Stratigraphy"|
                  contact_authid_dedup$SourceSubjectArea == "Ecology" |
                  contact_authid_dedup$SourceSubjectArea == "Ecology, Evolution, Behavior and Systematics", "Earth Sciences",
                ifelse(contact_authid_dedup$SourceSubjectArea == "Demography" |
                         contact_authid_dedup$SourceSubjectArea == "Engineering (miscellaneous)" |
                         contact_authid_dedup$SourceSubjectArea == "General Business, Management and Accounting" |
                         contact_authid_dedup$SourceSubjectArea == "General Social Sciences" |
                         contact_authid_dedup$SourceSubjectArea == "Political Science and International Relations" |
                         contact_authid_dedup$SourceSubjectArea == "Social Psychology" |
                         contact_authid_dedup$SourceSubjectArea == "Sociology and Political Science" |
                         contact_authid_dedup$SourceSubjectArea == "Urban Studies", "Social Science", "General")))

table(contact_authid_dedup$ResearchAreas)
summary(contact_authid_dedup)

contact_authid_dedup <- contact_authid_dedup %>%
                          mutate(email = gsub(".*: ","",email),
                                 Name_cleaned = str_replace_all(Name, "[[:punct:]]", ""), 
                                 LastName = trimws(Name_cleaned, whitespace = "[A-Z/]+", which = "right"))

contact_authid_dedup$hegs_id <- 1:nrow(contact_authid_dedup) 
setwd("/Users/sarahbardin/Desktop/Scopus/data/analysis")
write_csv(contact_authid_dedup,"hegsrr_sampling_frame.csv")

#-----------------------------------------#
#-- Output final reproducibility sample --#
#-----------------------------------------#

reproducibility_sample <- contact_authid_dedup[sample(nrow(contact_authid_dedup), 2000),]

reproducibility_sample <- reproducibility_sample %>% 
  transmute(hegs_id, AuthID, LastName, email)

write_csv(reproducibility_sample,"reproducibility_sample.csv")

#-Prize Draw Row Numbers-#
floor(runif(3, min=1, max=126))



