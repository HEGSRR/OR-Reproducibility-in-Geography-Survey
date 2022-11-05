library(here)
library(tidyverse)


raw_rpr_responses <- readRDS(here("data","raw","private","raw_rpr_responses.rds"))
  head(raw_rpr_responses)
  str(raw_rpr_responses)

hegs_rpr_deidentified <- raw_rpr_responses %>% 
                      select(-c(RecipientLastName, 
                                RecipientFirstName, 
                                RecipientEmail,
                                IPAddress,
                                Status,
                                ExternalReference,
                                LocationLatitude,
                                LocationLongitude,
                                DistributionChannel,
                                UserLanguage))

saveRDS(hegs_rpr_deidentified, here("data","raw","public","raw_hegs_rpr.rds"))

                        