# Group definitions ####
library(shiny)
subfields <- list("Human", "Methods", "Nature/society", "Physical")
types <- list("Quantitative", "Qualitative", "Mixed Methods")
geo_groups <- list(
  "Everyone",
  "Subfield" = subfields,
  "Type" = types
)

# Questions for the word cloud ####
cloud_cols <- list("Q6", "Q10", "Q12a", "Q15", "Q17a")
cloud_questions <- list(
  p(
    icon("circle-question"), strong("Question 6"), br(),
    "What is your understanding of the term \"reproducibility\" in the context of your own research?", br(),
    # icon("circle-info"), strong("Note: "), "Only this question is segmentable."
  ),
  p(
    icon("circle-question"), strong("Question 10"), br(),
    "Thinking about the reproduction(s) you attempted in the last 2 years, what made you decide to attempt the reproduction(s)?"
  ),
  p(
    icon("circle-question"), strong("Question 12a"), br(),
    "If you were not able to submit all of the findings of your reproduction(s) for publication, why not?"
  ),
  p(
    icon("circle-question"), strong("Question 15"), br(),
    "Please list any other factors that you believe contribute to a lack of reproducibility in research in your subfield."
  ),
  p(
    icon("circle-question"), strong("Question 17a"), br(),
    "Please list any benefits or important function of reproducibility in your subfield not mentioned above."
  )
)

# Level mappings for density plot ####
four_levels <- list(
  "To a great extent" = 1,
  "Somewhat" = 0.66,
  "Very little" = 0.33,
  "Not at all" = 0
)

five_levels <- list(
  "Always" = 1,
  "Most of the time" = 0.75,
  "Some of the time" = 0.5,
  "Rarely" = 0.25,
  "Never" = 0
)
