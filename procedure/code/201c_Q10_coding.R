# list of required packages
packages = c("here","tidyverse","table1","officer","readxl")

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

sb_coding <- read_excel(here("data","derived","public","Q10","sb_analysis_10_coding.xlsx"))
pk_coding <- read.csv(here("data","derived","public","Q10","analysis_10_coding_pk.csv"))
jh_coding <- read.csv(here("data","derived","public","Q10","analysis_10_coding_jh.csv"))



table(sb_coding$rp_intent)
sb_coding <- sb_coding %>% transmute(ResponseId,
                                     SB_notes = notes,
                                     sb_rp_intent = 
                                       ifelse(rp_intent == "Missing", 5,
                                       ifelse(rp_intent == "Replication", 3,
                                       ifelse(rp_intent == "Self-Check/Promote transparency of own work", 2,
                                       ifelse(rp_intent == "Teaching/Learning", 4,
                                       ifelse(rp_intent == "Verification/Peer-Review", 1, 5))))))
table(sb_coding$sb_rp_intent)

pk_coding <- pk_coding %>% transmute(ResponseId,
                                     PK_notes = notes,
                                     pk_rp_intent = rp_intent)

combined_sb_pk <- merge(sb_coding,pk_coding,by="ResponseId")
combined_all <- merge(jh_coding,combined_sb_pk,by="ResponseId")

#Replace NA values with 0 and create logical statements to identify discrepancies
combined_all <- combined_all %>%
                         mutate(any_diff = ifelse(rp_intent != sb_rp_intent | rp_intent != pk_rp_intent, 1, 0),
                                no_agreement = ifelse(rp_intent != sb_rp_intent & rp_intent != pk_rp_intent & sb_rp_intent != pk_rp_intent, 1, 0)) %>%
                         select(X, ResponseId, Q3_recoded, Q4, Q10, rp_intent, sb_rp_intent, pk_rp_intent, 
                                any_diff, no_agreement, notes, SB_notes, PK_notes, starts_with("X"))


#Check results of flagging
combined_all %>% filter(no_agreement==1) %>% 
  select(c(rp_intent,sb_rp_intent,pk_rp_intent))    

write.csv(combined_all,here("data","derived","public","full_Q10_coding.csv"))
