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

sb_coding <- read_excel(here("data","derived","public","analysis_Q6_coding.xlsx"))
pk_coding <- read_excel(here("data","derived","public","pk_analysis_Q6_coding.xlsx"))

combined <- left_join(sb_coding,pk_coding,by="ResponseId") 
## NOTE: PK deleted cases that were blank rather than coding as Missing

#Replace NA values with 0 and create logical statements to identify discrepancies
combined <- mutate_all(combined, ~replace_na(.,0)) %>% 
                         mutate(diff_data_same = (data_same.x != data_same.y),
                                diff_data_sim = (data_similar.x != data_similar.y),
                                diff_pro_same = (procedure_same.x != procedure_same.y),
                                diff_pro_sim = procedure_similar.x != procedure_similar.y, 
                                diff_res_same = results_same.x != results_same.y,
                                diff_res_sim = results_similar.x != results_similar.y,
                                diff_con_same = context_same.x != context_same.y,
                                diff_con_sim = context_similar.x != context_similar.y,
                                diff_rp_rej = rp_rejection.x != rp_rejection.y ,
                                diff_miss = Missing.x != Missing.y) %>%
                         rowwise %>%
                         mutate(diff_any = if_any(.cols = contains('diff_'), isTRUE)) %>%
                         ungroup

#Check results of flagging
combined %>% select(c(data_similar.x,data_similar.y,diff_data_sim))                                

check <- combined %>% 
          select(starts_with("diff_"))
sapply(check, sum)

discrepancies <- combined %>% filter(diff_any == T)
write.csv(discrepancies,here("data","derived","public","discrepancies_Q6_coding.csv"))
write.csv(combined,here("data","derived","public","full_Q6_coding.csv"))