library(here)
library(tidyverse)
library(qualtRics)
library(svDialogs)


# Code for downloading survey data from Qualtrics API
qualtrics_url <- dlgInput("Qualtrics URL:","asu.co1.qualtrics.com")$res
qualtrics_key <- dlgInput("Qualtrics API Key:", )$res 
rpr_survey_id <- dlgInput("Survey ID:","SV_e2Id3c5vvtqtazI")$res
# find API key and survey ID in Qualtrics "my account" info --> Qualtrics IDs menu
# find URL in the address bar while you're logged into your Qualtrics projects

qualtrics_api_credentials(api_key = qualtrics_key, 
                          base_url = qualtrics_url,
                          install = TRUE,
                          overwrite = TRUE)

readRenviron("~/.Renviron")

# get survey metadata as nested lists, incl questions and possible responses
rpr_survey_metadata <- metadata(rpr_survey_id)

# get data frame with four columns with question ID, name, text and required 
rpr_survey_questions <- survey_questions(rpr_survey_id)

# get survey responses as data frame - ordinal responses are ordered factors
rpr_responses <- fetch_survey(rpr_survey_id)

# Save permenant raw files and associated documentation for archvial purposes
saveRDS(rpr_responses, here("data","raw","private","raw_rpr_responses.rds"))
saveRDS(rpr_survey_questions, here("data","raw","private","raw_rpr_survey_questions.rds"))
saveRDS(rpr_survey_metadata, here("data","raw","private","raw_rpr_survey_metadata.rds"))


# De-identify file to create public raw version
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

                        