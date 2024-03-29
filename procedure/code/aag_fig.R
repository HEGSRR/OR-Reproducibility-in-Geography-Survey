# AAG FIGURES FOR PETER
library(here)
library(tidyverse)
library(table1)
library(officer)
library(ggthemes)
library(ggridges)
library("ggtext")
library(extrafont)
download.file("http://simonsoftware.se/other/xkcd.ttf",
              dest="xkcd.ttf", mode="wb")
system("mkdir ~/.fonts")
system("cp xkcd.ttf  ~/.fonts")
font_import(paths = "~/.fonts", pattern="[X/x]kcd")
fonts()
loadfonts()

#--------------------------------#
#-                              -#
#- PERFORM DESCRIPTIVE ANALYSIS -#
#-                              -#
#--------------------------------#
analysis_hegs_rpl <- readRDS("/Users/sarahbardin/Desktop/OR-Replicability-in-Geography-Survey/data/derived/public/analysis_hegs_rpl.rds")

#-------------------------------------------------------------------------------#
#Slide 5 - Individual density plots for could, should, have
#          for RP and RPL OVERALL ONLY, USE SAME VERTICAL AND HORIZONTAL SCALE
#-------------------------------------------------------------------------------#
fill <- "#DCE1E5"
line <- "#003660"
summary(analysis_hegs_rpl$Q12_pcnt_have_rep_1)
#COULD RPL
could_rpl <- ggplot(analysis_hegs_rpl, aes(x=Q13_pcnt_could_rep_1)) + 
  geom_density(fill=fill, colour = line, size = 1, na.rm = T, )  +
  scale_x_continuous(name = "**Could** be replicated (%)",
                     breaks = seq(0, 100, 25),
                     limits=c(0, 100),
                     expand = c(0, 2)) +
  scale_y_continuous(name = "Density",
                     breaks = seq(0, 0.025, .005),
                     limits=c(0, 0.025),
                     expand = c(0, 0)) +
  theme(axis.line.x.bottom = element_line(size=1, colour = "black"),
        axis.line.y = element_blank(),
        axis.ticks.x = element_blank(),
        axis.ticks.y = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(), 
        panel.background = element_blank(),
        text=element_text(family="Tahoma"),
        axis.text.x=element_text(colour="black", size = 9),
        axis.text.y=element_text(colour="black", size = 9),
        axis.title.x = ggtext::element_markdown()) + 
  geom_vline(xintercept = 55.02, size = 1, colour = "#FF3721", linetype = "dashed") 


#SHOULD RPL
should_rpl <- ggplot(analysis_hegs_rpl, aes(x=Q14_pcnt_should_rep_1)) + 
  geom_density(fill=fill, colour = line, size = 1, na.rm = T, )  +
  scale_x_continuous(name = "**Should** be replicated (%)",
                     breaks = seq(0, 100, 25),
                     limits=c(0, 100),
                     expand = c(0, 2)) +
  scale_y_continuous(name = "Density",
                     breaks = seq(0, 0.025, .005),
                     limits=c(0, 0.025),
                     expand = c(0, 0)) +
  theme(axis.line.x.bottom = element_line(size=1, colour = "black"),
        axis.line.y = element_blank(),
        axis.ticks.x = element_blank(),
        axis.ticks.y = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(), 
        panel.background = element_blank(),
        text=element_text(family="Tahoma"),
        axis.text.x=element_text(colour="black", size = 9),
        axis.text.y=element_text(colour="black", size = 9),
        axis.title.x = ggtext::element_markdown()) + 
  geom_vline(xintercept = 55.86, size = 1, colour = "#FF3721", linetype = "dashed") 


#HAVE
have_rpl <- ggplot(analysis_hegs_rpl, aes(x=Q12_pcnt_have_rep_1)) + 
  geom_density(fill=fill, colour = line, size = 1, na.rm = T, )  +
  scale_x_continuous(name = "**Have** been replicated (%)",
                     breaks = seq(0, 100, 25),
                     limits=c(0, 100),
                     expand = c(0, 2)) +
  scale_y_continuous(name = "Density",
                     breaks = seq(0, 0.025, .005),
                     limits=c(0, 0.025),
                     expand = c(0, 0)) +
  theme(axis.line.x.bottom = element_line(size=1, colour = "black"),
        axis.line.y = element_blank(),
        axis.ticks.x = element_blank(),
        axis.ticks.y = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(), 
        panel.background = element_blank(),
        text=element_text(family="Tahoma"),
        axis.text.x=element_text(colour="black", size = 9),
        axis.text.y=element_text(colour="black", size = 9),
        axis.title.x = ggtext::element_markdown()) + 
  geom_vline(xintercept = 26.54, size = 1, colour = "#FF3721", linetype = "dashed") 

should_rpl
could_rpl
have_rpl

#-------------------------------------------------------------------------------#
#Slide 5 - Ridge line density plots for could, should, have
#-------------------------------------------------------------------------------#

## Do a ridge line version where all three are in one plot at 3 levels 
## have at the top, could in the middle, should at the bottom


itemsQ12<-as.data.frame(analysis_hegs_rpl[,substr(names(analysis_hegs_rpl), 1,3) == "Q12"])
itemsQ13<-analysis_hegs_rpl[,substr(names(analysis_hegs_rpl), 1,3) == "Q13"]
itemsQ14<-analysis_hegs_rpl[,substr(names(analysis_hegs_rpl), 1,3) == "Q14"]

itemsQ12 <- itemsQ12 %>% transmute(response = ifelse(is.na(Q12_pcnt_have_rep_1),"Have","Have"),
                                   value = Q12_pcnt_have_rep_1)
itemsQ13 <- itemsQ13 %>% transmute(response = ifelse(is.na(Q13_pcnt_could_rep_1),"Could","Could"),
                                   value = Q13_pcnt_could_rep_1)
itemsQ14 <- itemsQ14 %>% transmute(response = ifelse(is.na(Q14_pcnt_should_rep_1),"Should","Should"),
                                   value = Q14_pcnt_should_rep_1)

data_ridge <- rbind(itemsQ12,itemsQ13,itemsQ14)
data_ridge$response <- factor(data_ridge$response, levels = c("Should", "Could", "Have"), ordered = TRUE)

ggplot(data_ridge, aes(x = value, y = response, group = response)) + 
  geom_density_ridges(aes(fill = response), scale = 2, alpha = 0.5, color = line) + 
  scale_fill_manual(values = c("#DCD6CC", "#9CBEBE", "#04859B")) +
 # stat_density_ridges(quantile_lines = TRUE, quantiles = 0.5, scale = 2., ) +
  scale_x_continuous(name = "",
                     breaks = seq(0, 100, 25),
                     limits=c(0, 100),
                     expand = c(0, 2)) +
  scale_y_discrete(name = "",
                   expand = c(0, 0)) +
  theme(legend.position = "none") +
  theme(axis.line.x.bottom = element_line(size=0.7, colour = "black"),
        axis.line.y = element_blank(),
        axis.ticks.x = element_blank(),
        axis.ticks.y = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(), 
        panel.background = element_blank(),
        text=element_text(family="Tahoma"),
        axis.text.x=element_text(colour="black", size = 9),
        axis.text.y=element_text(colour="black", size = 12, vjust = -2, face = "bold"),
        axis.title.x = ggtext::element_markdown()) 

#-------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------#

# RPL-Q8_1 THROUGH Q8_10 & Q10_1 THROUGH Q8_6 (combined)
analysis_hegs_rpl <- analysis_hegs_rpl %>% 
  mutate_at(c("Q8_study_factors_1","Q8_study_factors_2","Q8_study_factors_3","Q8_study_factors_4",
              "Q8_study_factors_5","Q8_study_factors_6","Q8_study_factors_7","Q8_study_factors_8",
              "Q8_study_factors_9","Q8_study_factors_10",
              "Q10_phen_factors_1","Q10_phen_factors_2","Q10_phen_factors_3","Q10_phen_factors_4",
              "Q10_phen_factors_5","Q10_phen_factors_6"), funs(dplyr::recode(., 
                                                                             `Very likely to decrease`= -2, 
                                                                             `Somewhat likely to decrease`= -1, 
                                                                             `Not likely to affect` = 0,
                                                                             `Somewhat likely to increase` = 1,
                                                                             `Very likely to increase` = 2,
                                                                             .default = NaN))) %>% 
  mutate_at(c("Q15_decision_factors_1","Q15_decision_factors_2","Q15_decision_factors_3","Q15_decision_factors_4",
              "Q15_decision_factors_5","Q15_decision_factors_6","Q15_decision_factors_7","Q15_decision_factors_8",
              "Q15_decision_factors_9","Q15_decision_factors_10","Q15_decision_factors_11","Q15_decision_factors_12"), funs(dplyr::recode(., 
                                                                                                                                          `Never`= 4, 
                                                                                                                                          `Rarely`= 3, 
                                                                                                                                          `Occasionally` = 2,
                                                                                                                                          `Frequently` = 1,
                                                                                                                                          `Always` = 0,
                                                                                                                                          .default = NaN)))



#Convert to factors
q8_10_levels <- paste(c("Very likely to decrease","Somewhat likely to decrease","Not likely to affect",
                        "Somewhat likely to increase", "Very likely to increase"))
q15_levels <- paste(c("Always","Frequently","Occasionally","Rarely",  "Never"))

analysis_hegs_rpl[20:29] = lapply(analysis_hegs_rpl[20:29], factor, levels = -2:2, labels=q8_10_levels)
analysis_hegs_rpl[31:36] = lapply(analysis_hegs_rpl[31:36], factor, levels = -2:2, labels=q8_10_levels)
analysis_hegs_rpl[41:52] = lapply(analysis_hegs_rpl[41:52], factor, levels = 0:4, labels=q15_levels)

items8_10 <-analysis_hegs_rpl[,substr(names(analysis_hegs_rpl), 1,2) == "Q8" | substr(names(analysis_hegs_rpl), 1,3) == 'Q10']
names(items8_10) <- c("Multiple hypotheses were tested", 
                      "Quantitative methods were used", 
                      "Qualitative methods were used", 
                      "Mixed methods were used",
                      "Poor documentation of study methods",
                      "Restricted access data were used",
                      "Data were gathered from multiple sites",
                      "A large research team conducted the study",
                      "Relied on expertise unique to the researcher",
                      "Relied on the unique position of the researcher",
                      "Spatially dependent upon itself",
                      "Strongly related with local conditions",
                      "Exhibits variation across locations",
                      "Cannot be directly measured",
                      "Cannot be directly manipulated",
                      "Has multiple competing theoretical explanations")

items8_10 <- items8_10[,c(5,6,7,8,9,10,1,2,3,4,11,12,13,14,15,16)]
items8_10 <- as.data.frame(items8_10) 

items15 <-analysis_hegs_rpl[,substr(names(analysis_hegs_rpl), 1,3) == c('Q15')]
names(items15) <- c("Pressure to publish original research",
                    "Low value of replication studies",
                    "Low chances of replicating a result",
                    "Lack of experience conducting replications",
                    "Difficult publishing peer-reviewed replications",
                    "Difficulty accessing/creating relevant data",
                    "Insufficient information about original methods",
                    "Difficulty recreating similar procedures",
                    "Lack of funding for replication studies",
                    "Fraud",
                    "Ethical concerns",
                    "Known spatial variation in phenomena being studied")

items15 <- items15[,c(1,9,2,5,10, 6,7,8, 12,4,3,11)]
items15 <- as.data.frame(items15) 

test<-pivot_longer(items8_10, everything()) %>%
  group_by(name) %>%
  dplyr::count(value) %>%
  mutate(percentage = (n/283),
         sum_n = sum(n),
         percentage_diverging = ifelse(value %in% c("Very likely to decrease","Somewhat likely to decrease"),
                                       -1*percentage,
                                       percentage),
         name = factor(name, levels=c("Has multiple competing theoretical explanations",
                                      "Cannot be directly manipulated",
                                      "Cannot be directly measured",
                                      "Exhibits variation across locations",
                                      "Strongly related with local conditions",
                                      "Spatially dependent upon itself",
                                      "Mixed methods were used",
                                      "Qualitative methods were used", 
                                      "Quantitative methods were used", 
                                      "Multiple hypotheses were tested", 
                                      "Relied on the unique position of the researcher",
                                      "Relied on expertise unique to the researcher",
                                      "A large research team conducted the study",
                                      "Data were gathered from multiple sites",
                                      "Restricted access data were used",
                                      "Poor documentation of study methods"
         )),
         label = paste0(round(percentage*100,0),"%"),
         value_ordered = relevel(value, "Very likely to increase")
  )

#Q8_10 PLOT ADD MISSING AND DON'T KNOW TO PERCENTAGES BUT DON'T SHOW 
pivot_longer(items8_10, everything()) %>%
  group_by(name) %>%
  dplyr::count(value) %>%
  mutate(percentage = (n/283),
         percentage_diverging = ifelse(value %in% c("Very likely to decrease","Somewhat likely to decrease"),
                                       -1*percentage,
                                       percentage),
         name = factor(name, levels=c("Has multiple competing theoretical explanations",
                                      "Cannot be directly manipulated",
                                      "Cannot be directly measured",
                                      "Exhibits variation across locations",
                                      "Strongly related with local conditions",
                                      "Spatially dependent upon itself",
                                      "Mixed methods were used",
                                      "Qualitative methods were used", 
                                      "Quantitative methods were used", 
                                      "Multiple hypotheses were tested", 
                                      "Relied on the unique position of the researcher",
                                      "Relied on expertise unique to the researcher",
                                      "A large research team conducted the study",
                                      "Data were gathered from multiple sites",
                                      "Restricted access data were used",
                                      "Poor documentation of study methods"
                                      )),
         label = paste0(round(percentage*100,0),"%"),
         value_ordered = relevel(value, "Very likely to increase")
         ) %>%
  filter(!is.na(value) & value != "Not likely to affect") %>%
  ggplot(aes(x = name, y = percentage_diverging, fill = value_ordered)) +
  geom_bar(stat = "identity", width = 0.9) +
  geom_text(aes(label = label), position = position_stack(vjust = 0.4), size = 2.1, colour="white") +
  coord_flip() +
  scale_y_continuous(labels = scales::percent) +
  scale_fill_manual(values = c("#CD2311","#003660","#04859B","#EF5645")) +
  ylab("") + 
  xlab("") +
  scale_x_discrete(expand = c(0, 0))  +
  theme(axis.line.x = element_line(size=0.5, colour = "black"),
        axis.ticks.x = element_line(size=0.5, colour = "black"),
        axis.line.y = element_blank(),
        axis.ticks.y = element_blank(),
        panel.border = element_blank(), 
        panel.background = element_blank(),
        text=element_text(family="Tahoma"),
        axis.text.x=element_text(colour="black", size = 9),
        axis.text.y=element_text(colour="black", size = 10),
        legend.position = "bottom",
        legend.title =element_blank()) 


#Q15 PLOT ADD MISSING AND DON'T KNOW TO PERCENTAGES BUT DON'T SHOW 

pivot_longer(items15, everything()) %>%
  group_by(name) %>%
  dplyr::count(value) %>%
  filter(!is.na(value)) %>%
  mutate(percentage = (n/283),
         name = factor(name, levels=c("Ethical concerns",
                                      "Low chances of replicating a result",
                                      "Lack of experience conducting replications",
                                      "Known spatial variation in phenomena being studied",
                                      "Difficulty recreating similar procedures",
                                      "Insufficient information about original methods",
                                      "Difficulty accessing/creating relevant data",
                                      "Fraud",
                                      "Difficult publishing peer-reviewed replications",
                                      "Low value of replication studies",
                                      "Lack of funding for replication studies",
                                      "Pressure to publish original research"
                                      ))) %>%
  ggplot(aes(x = name, y = percentage, fill = value)) +
  geom_bar(position = position_fill(reverse = TRUE), stat = "identity", width = 0.8) +
  coord_flip() + 
  scale_fill_manual(values = c("#CD2311","#EF5645","#BFBFBF","#D9D9D9","#F2F2F2")) +
  ylab("") + 
  xlab("") +
  scale_x_discrete(expand = c(0, 0))  +
  scale_y_continuous(labels = scales::percent) +
  theme(axis.line.x = element_line(size=0.5, colour = "black"),
        axis.ticks.x = element_line(size=0.5, colour = "black"),
        axis.line.y = element_blank(),
        axis.ticks.y = element_blank(),
        panel.border = element_blank(), 
        panel.background = element_blank(),
        text=element_text(family="Tahoma"),
        axis.text.x=element_text(colour="black", size = 9),
        axis.text.y=element_text(colour="black", size = 10),
        legend.position = "bottom",
        legend.title =element_blank()) 


#-------------------------------------------------------------------------------#
# REPRODUCIBILITY
#-------------------------------------------------------------------------------#
rp <- readRDS("/Users/sarahbardin/Desktop/OR-Reproducibility-in-Geography-Survey/data/derived/public/analysis_hegs_rpr.rds")

# RP_Q14
rp <- rp %>% 
  mutate_at(c("Q14_1","Q14_2","Q14_3","Q14_4",
              "Q14_5","Q14_6","Q14_7","Q14_8",
              "Q14_9","Q14_10","Q14_11","Q14_12"), 
            funs(dplyr::recode(., 
                               `Frequently`= 1, 
                               `Occasionally`= 2, 
                               `Rarely` = 3,
                               `Never` = 4,
                               .default = NaN)))

#Convert to factors
q14_levels <- paste(c("Frequently","Occasionally","Rarely", "Never"))

rp[57:68] = lapply(rp[57:68], factor, levels = 1:4, labels=q14_levels)

items14 <-rp[,substr(names(rp), 1,3) == "Q14"]
names(items14) <- c("Fraud", 
                    "Pressure to publish", 
                    "Insufficient oversight or mentoring", 
                    "Lack of publishing raw data",
                    "Lack of publishing protocol or code",
                    "Lack of publishing full results",
                    "Differences in software environments",
                    "Use of proprietary data or software",
                    "Complexity and variability of geographic systems",
                    "Random effects",
                    "Insufficient metadata",
                    "Researcher positionality")
test <-
  
  pivot_longer(items14, everything()) %>%
  group_by(name) %>%
  dplyr::count(value) %>%
  mutate(percentage = (n/218),
         label = paste0(round(percentage*100,0),"%"),
         name = factor(name, levels=c("Differences in software environments",
                                      "Random effects",
                                      "Researcher positionality",
                                      "Complexity and variability of geographic systems",
                                      "Use of proprietary data or software",
                                      "Lack of publishing full results",
                                      "Lack of publishing protocol or code",
                                      "Lack of publishing raw data",
                                      "Insufficient metadata",
                                      "Fraud", 
                                      "Insufficient oversight or mentoring", 
                                      "Pressure to publish"
         ))) 

write_csv(test,here("rp14_freqs_pcnts.csv"))

pivot_longer(items14, everything()) %>%
  group_by(name) %>%
  dplyr::count(value) %>%
  mutate(percentage = (n/218),
         label = paste0(round(percentage*100,0),"%"),
         name = factor(name, levels=c("Differences in software environments",
                                      "Random effects",
                                      "Researcher positionality",
                                      "Complexity and variability of geographic systems",
                                      "Use of proprietary data or software",
                                      "Lack of publishing full results",
                                      "Lack of publishing protocol or code",
                                      "Lack of publishing raw data",
                                      "Insufficient metadata",
                                      "Fraud", 
                                      "Insufficient oversight or mentoring", 
                                      "Pressure to publish"
         ))) %>%
  filter(!is.na(value)) %>%
  ggplot(aes(x = name, y = percentage, fill = value)) +
  geom_bar(position = position_fill(reverse = TRUE), stat = "identity", width = 0.8) +
  coord_flip() + 
  scale_fill_manual(values = c("#CD2311","#EF5645", "#D9D9D9","#F2F2F2")) +
  ylab("") + 
  xlab("") +
  scale_x_discrete(expand = c(0, 0))  +
  scale_y_continuous(labels = scales::percent) +
  theme(axis.line.x = element_line(size=0.5, colour = "black"),
        axis.ticks.x = element_line(size=0.5, colour = "black"),
        axis.line.y = element_blank(),
        axis.ticks.y = element_blank(),
        panel.border = element_blank(), 
        panel.background = element_blank(),
        text=element_text(family="Tahoma"),
        axis.text.x=element_text(colour="black", size = 9),
        axis.text.y=element_text(colour="black", size = 10),
        legend.position = "bottom",
        legend.title =element_blank()) 

#-------------------------------------------------------------------------#
fill <- "#DCE1E5"
line <- "#003660"

#COULD RPL
could_rp <- ggplot(rp, aes(x=Q13_1)) + 
  geom_density(fill=fill, colour = line, size = 1, na.rm = T, )  +
  scale_x_continuous(name = "**Could** be reproduced (%)",
                     breaks = seq(0, 100, 25),
                     limits=c(0, 100),
                     expand = c(0, 2)) +
  scale_y_continuous(name = "Density",
                     breaks = seq(0, 0.025, .005),
                     limits=c(0, 0.025),
                     expand = c(0, 0)) +
  theme(axis.line.x.bottom = element_line(size=1, colour = "black"),
        axis.line.y = element_blank(),
        axis.ticks.x = element_blank(),
        axis.ticks.y = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(), 
        panel.background = element_blank(),
        text=element_text(family="Tahoma"),
        axis.text.x=element_text(colour="black", size = 9),
        axis.text.y=element_text(colour="black", size = 9),
        axis.title.x = ggtext::element_markdown()) + 
  geom_vline(xintercept = 55, size = 1, colour = "#FF3721", linetype = "dashed") 


#-------------------------------------------------------------------------------#
#Slide 5 - Ridge line density plots for could rpl and could rp
#-------------------------------------------------------------------------------#

## Do a ridge line version where all three are in one plot at 3 levels 
## have at the top, could in the middle, should at the bottom

itemsQ13_rp <-rp[,substr(names(rp), 1,5) == "Q13_1"]
itemsQ13_rpl <-analysis_hegs_rpl[,substr(names(analysis_hegs_rpl), 1,3) == "Q13"]

itemsQ13_rp <- itemsQ13_rp %>% transmute(response = ifelse(is.na(Q13_1),"Reproduced","Reproduced"),
                                   value = Q13_1)
itemsQ13_rpl <- itemsQ13_rpl %>% transmute(response = ifelse(is.na(Q13_pcnt_could_rep_1),"Replicated","Replicated"),
                                         value = Q13_pcnt_could_rep_1)

data_ridge_2 <- rbind(itemsQ13_rp,itemsQ13_rpl)
data_ridge_2$response <- factor(data_ridge_2$response, levels = c("Reproduced", "Replicated"), ordered = TRUE)

ggplot(data_ridge_2, aes(x = value, y = response, group = response)) + 
  geom_density_ridges(aes(fill = response), scale = 2, alpha = 0.5, color = line) + 
  scale_fill_manual(values = c("#DCD6CC","#04859B", "#9CBEBE")) +
  # stat_density_ridges(quantile_lines = TRUE, quantiles = 0.5, scale = 2., ) +
  scale_x_continuous(name = "",
                     breaks = seq(0, 100, 25),
                     limits=c(0, 100),
                     expand = c(0, 2)) +
  scale_y_discrete(name = "",
                   expand = c(0, 0)) +
  theme(legend.position = "none") +
  theme(axis.line.x.bottom = element_line(size=0.7, colour = "black"),
        axis.line.y = element_blank(),
        axis.ticks.x = element_blank(),
        axis.ticks.y = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(), 
        panel.background = element_blank(),
        text=element_text(family="Tahoma"),
        axis.text.x=element_text(colour="black", size = 9),
        axis.text.y=element_text(colour="black", size = 12, vjust = -2, face = "bold"),
        axis.title.x = ggtext::element_markdown()) 



















library(likert)
q8_10_figures <- likert(items8_10)
q15_figures <- likert(items15)
#--THIS WILL BE FOR APPENDIX
plot(q8_10_figures, group.order = names(items8_10[1:16]), centered = TRUE, 
     plot.percent.neutral=TRUE, plot.percents = TRUE,
     plot.percent.low=FALSE, plot.percent.high=FALSE,
     text.size = 2.5,
     panel.background = element_rect(size = 0, color = "grey70", fill = NA),
     legend = "",
     legend.position = "bottom"
)


#CENTERED
plot(q8_10_figures, 
     group.order = names(items8_10[1:16]),
     include.center=FALSE, 
     plot.percents = TRUE,
     plot.percent.low=FALSE, plot.percent.high=FALSE,
     text.size = 2.5,
     panel.background = element_rect(size = 0, color = "grey70", fill = NA),
     legend = "",
     legend.position = "bottom"
)

#NOT CENTERED (UNSURE HOW TO GET PERCENTAGES CORRECT)
plot(q8_10_figures, 
     group.order = names(items8_10[1:16]),
     include.center=FALSE, 
     plot.percents = FALSE,
     plot.percent.low=FALSE, plot.percent.high=FALSE, plot.percent.neutral=TRUE,
     text.size = 2.5,
     panel.background = element_rect(size = 0, color = "grey70", fill = NA),
     centered = FALSE,
     legend = "",
     legend.position = "bottom")


plot(q8_10_figures, 
     ordered = TRUE, 
     plot.percents = FALSE,
     plot.percent.low=FALSE, plot.percent.high=FALSE, plot.percent.neutral=TRUE,
     text.size = 2.5,
     panel.background = element_rect(size = 0, color = "grey70", fill = NA),
     centered = FALSE,
     legend = "",
     legend.position = "bottom")


plot(q15_figures, 
     group.order = names(items15[1:12]),
     include.center=FALSE, 
     plot.percents = FALSE,
     plot.percent.low=FALSE, plot.percent.high=FALSE, plot.percent.neutral=FALSE,
     text.size = 2.5,
     panel.background = element_rect(size = 0, color = "grey70", fill = NA),
     centered = FALSE,
     legend = "",
     legend.position = "bottom",
     colors = c("#CD2311","#EF5645","#BFBFBF","#D9D9D9","#F2F2F2")
)



