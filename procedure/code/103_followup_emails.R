
library(tidyverse)
library(stringr)
setwd("/Users/sarahbardin/Desktop/Scopus/data/analysis")

distribution <- read.csv("HEGSReproducibility-Distribution_History_v3.csv")
disposition <- read.csv("Survey-Response-Tracking_qualtrics_update_v2.csv")

combined <- merge(distribution, disposition, by.x = c("Email"), by.y =c("email"))

follow_up_status <- combined %>%
                      transmute(hegs_id,
                                AuthID,
                                Response.ID = Response.ID.x,
                                LastName,
                                Flag_mismatch,
                                disposition_w1_c1,
                                disposition_w1_c1_date,
                                disposition_w1_c2,
                                disposition_w1_c2_date,
                                disposition_w1_c3,
                                disposition_w1_c3_date,
                                disposition_final,
                                new.email,
                                Qualtrics_Status,
                                Qualtrics_Status_Rd2,
                                Qualtrics_Status_Rd3 = Status,
                                Notes)

write.csv(follow_up_status, "Survey-Response-Tracking_qualtrics_update_v3.csv")

