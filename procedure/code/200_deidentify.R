library(here)
library(tidyverse)


hegs_repro <- read.csv(here("data","raw","private","HEGS-Reproducibility_2022_22_06.csv"))
head(hegs_repro$StartDate)

hegs_repro = hegs_repro[-1,]
hegs_repro = hegs_repro[-1,] # drop first two rows from data as these contain variable labels
head(hegs_repro$StartDate)

hegs_deidentified <- hegs_repro %>% 
                      select(-c(RecipientLastName, 
                                RecipientFirstName, 
                                RecipientEmail,
                                IPAddress))

write.csv(hegs_deidentified, here("data","raw","deidentified","hegsrr_raw_reprod.csv"))
                        