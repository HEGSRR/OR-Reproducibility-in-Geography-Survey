library("tidyverse")
library("stringr")
library("readxl")
library("data.table")
#------------------------------------------------------------------------#
#-                                                                      -#
#- READ IN RAW DATA FROM SCOPUS EXPORTS, COMBINE INTO SINGLE DATA FRAME -#
#-                                                                      -#
#------------------------------------------------------------------------#

#-----------------------#
#--- READ IN ARTICLES --#
#-----------------------#
#setwd("/Users/sarahbardin/Desktop/Scopus/data/scopus_papers")
#files <- list.files(pattern = "\\.csv$")
#DF <-  read.csv(files[1])

#reading each file within the range and append them to create one file
#for (f in files[-1]){
#  df <- read.csv(f)      # read the file
#  DF <- rbind(DF, df)    # append the current file
#}

#writing final file
#write.csv(DF, "raw_scopus.csv", row.names=FALSE)

#-----------------------#
#--- READ IN JOURNALS --#
#-----------------------#
#setwd("/Users/sarahbardin/Desktop/Scopus/data/scopus_journals")
#files <- list.files(pattern = "\\.xlsx$")
#journals <-  read_xlsx(files[1])

#reading each file within the range and append them to create one file
#for (f in files[-1]){
#  df <- read_xlsx(f)      # read the file
#  journals <- rbind(journals, df)    # append the current file
#}

#write.csv(journals, "raw_scopus_journals.csv", row.names=FALSE)
#------------------------------------------------------------------------#
#-                                                                      -#
#- PARSE COLUMNS CONTAINING LISTS OF INFORMATION INTO SEPARATE COLUMNS  -#
#-                                                                      -#
#------------------------------------------------------------------------#

raw_scopus <- read.csv("/Users/sarahbardin/Desktop/Scopus/data/scopus_papers/raw_scopus.csv")
    length(unique(raw_scopus$EID))  ## EID is the unique identifier 

auth_name <- raw_scopus %>%
                transmute(EID,
                          as.data.frame(str_split_fixed(raw_scopus$Authors,".,", n = 270)))
colnames(auth_name)[2:271] <- paste("AuthName", colnames(auth_name[,c(2:271)]),sep="_")

auth_id   <- raw_scopus %>%
                transmute(EID,
                          as.data.frame(str_split_fixed(raw_scopus$Author.s..ID,";", n = 270)))
colnames(auth_id)[2:271] <- paste("AuthID", colnames(auth_id[,c(2:271)]),sep="_")

auth_aff  <- raw_scopus %>%
                transmute(EID,                          
                          as.data.frame(str_split_fixed(raw_scopus$Affiliations,"; ", n = 270)))
colnames(auth_aff)[2:271] <- paste("AuthAff", colnames(auth_aff[,c(2:271)]),sep="_")


#Create wide dataframe
wide_scopus <-as.data.frame(cbind(raw_scopus,auth_name,auth_id,auth_aff))
wide_scopus <- wide_scopus[, !duplicated(colnames(wide_scopus))] # drop duplicate columns
wide_scopus$Source.title <- ifelse(wide_scopus$Source.title == "Gender, Place, and Culture", "Gender, Place and Culture", 
                               ifelse(wide_scopus$Source.title == "Geografisk Tidsskrift", "Geografisk Tidsskrift - Danish Journal of Geography ", 
                                   ifelse(wide_scopus$Source.title == "Quaternary Research", "Quaternary Research (United States)", wide_scopus$Source.title)))

#-------------------------------------------------#
#-                                               -#
#- TRANSFORM WIDE DATA FRAME TO LONG DATA FRAME  -#
#-                                               -#
#-------------------------------------------------#

#Reshape wide_scopus to long
long_name <- auth_name %>% 
                  pivot_longer( cols = starts_with("AuthName"),
                                names_to = "Authorship_Order",
                                names_prefix = "AuthName",
                                values_to = "Name")
long_id <- auth_id %>% 
                  pivot_longer( cols = starts_with("AuthID"),
                                names_to = "Authorship_Order",
                                names_prefix = "AuthID",
                                values_to = "AuthID")

long_aff <- auth_aff %>% 
                  pivot_longer( cols = starts_with("AuthAff"),
                                names_to = "Authorship_Order",
                                names_prefix = "AuthAff",
                                values_to = "Affiliation")

long_scopus <-as.data.frame(cbind(long_name,long_id,long_aff))
#Want to assert that if name is not missing neither is id
#Want to assert if id is not missing neither is name

#Drop rows with missing author names and remove duplicated columns
long_scopus <- long_scopus[nchar(long_scopus$Name)!=0,!duplicated(colnames(long_scopus))]
long_scopus <- long_scopus  %>% 
                    transmute(EID,
                              Name,
                              AuthID,
                              Affiliation,
                              AuthOrder = substr(long_scopus$Authorship_Order,3,5))

#Merge on article-level information via EID
long_scopus_full <- merge(long_scopus, raw_scopus, by = "EID")

long_scopus_full  <- long_scopus_full %>%
  mutate(as.data.frame(str_split_fixed(long_scopus_full$Correspondence.Address,"; ", n = 3)))

long_scopus_full  <- long_scopus_full %>%
  rename(CorrespondAuthName = colnames(long_scopus_full)[34],
         CorrespondAuthAff = colnames(long_scopus_full)[35],
         email = colnames(long_scopus_full)[36]) 

long_scopus_full  <- long_scopus_full %>%
  mutate(CorrespondAuth = ifelse(substr(str_trim(Name),1,3)!=substr(str_trim(CorrespondAuthName),1,3),0,1),
         CorrespondAuthAff = ifelse(substr(str_trim(Name),1,3)!=substr(str_trim(CorrespondAuthName),1,3),"",long_scopus_full$CorrespondAuthAff),
         email = ifelse(substr(str_trim(Name),1,3)!=substr(str_trim(CorrespondAuthName),1,3),"",long_scopus_full$email))

#Count number of total publications by AuthID
long_scopus_full <- long_scopus_full %>% 
  add_count(AuthID, name = "AuthTotPub")

#-------------------------------------------------#
#-                                               -#
#- MERGE ON JOURNAL LEVEL INFORMATION  -#
#-                                               -#
#-------------------------------------------------#
raw_journals <- read.csv("/Users/sarahbardin/Desktop/Scopus/data/scopus_journals/raw_scopus_journals.csv")

journals <- raw_journals %>% 
                rename(SourceTitle  = Source.title,
                       SourceCiteScore = CiteScore,
                       SourceCitations2017_2020 = X2017.20.Citations,
                       SourceDocuments2017_2020 = X2017.20.Documents,
                       SourcePcntCited = X..Cited) %>%
                transmute(SourceTitle = ifelse(SourceTitle == "Gender, Place, and Culture", "Gender, Place and Culture", 
                                               ifelse(SourceTitle == "Geografisk Tidsskrift", "Geografisk Tidsskrift - Danish Journal of Geography ", 
                                                      ifelse(SourceTitle == "Quaternary Research", "Quaternary Research (United States)", SourceTitle))),
                          SourceCiteScore,
                          SourceCitations2017_2020,
                          SourceDocuments2017_2020,
                          SourcePcntCited,
                          SNIP,
                          SJR,
                          Publisher,
                          as.data.frame(str_split_fixed(raw_journals$Highest.percentile,"\n", n = 3))) 
journals <- journals %>%
                rename(SourcePercentile = V1,
                       SourceRanking = V2,
                       SourceSubjectArea = V3)

int_scopus_long <- merge(long_scopus_full,journals, by.x = c("Source.title"), by.y = c("SourceTitle"))
#Assert that sample size is the same between long_scopus_full and int_scopus_long

int_scopus_wide <- merge(wide_scopus,journals, by.x = c("Source.title"), by.y = c("SourceTitle"))
#Assert that sample size is the same between wide_scopus and int_scopus_wide
#Ask Peter if he wants wide with Author columns arrayed out, or in one field (merge raw_scopus or wide_scopus)

#-------------------------------------------------#
#-                                               -#
#- SAVE PERMANENT FILE, CONSIDER ADDL CLEANING   -#
#-                                               -#
#-------------------------------------------------#
setwd("/Users/sarahbardin/Desktop/Scopus/data/intermediate")
write.csv(int_scopus_long, "int_scopus_long.csv", row.names=FALSE)
write.csv(int_scopus_wide, "int_scopus_wide.csv", row.names=FALSE)


#Export subject area and key terms to explore possible strata
subject_area <- as.data.frame(table(journals$SourceSubjectArea))
auth_key_terms <- as.data.frame(table(wide_scopus$Author.Keywords))
index_key_terms <- as.data.frame(table(wide_scopus$Index.Keywords))

write.csv(subject_area, "scopus_journal_subject_areas.csv", row.names=FALSE)
write.csv(auth_key_terms, "scopus_article_auth_keyterms.csv", row.names=FALSE)
write.csv(index_key_terms, "scopus_article_index_keyterms.csv", row.names=FALSE)


#FOR SEPARATE PROGRAM
# drop records with blank AuthID and AuthID == "[No author id available]"
# reduce to authors who have published at least 2 times
# we will then need to determine whether to classify authors based on key terms for all 5
# years of papers, 
# could classify authors having published in physical, human, or both journals over 5 years

# ADDITIONAL CONSIDERATIONS
# de-duplicate by auth id and affiliation
# consider filling missing author info with existing non-missing info
# explore how many corresponding authors are not also first authors



