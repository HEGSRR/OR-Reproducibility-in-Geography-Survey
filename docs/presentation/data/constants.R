library(shiny)
library(plotly)

# Group definitions ####
subfields <- list("Human", "Methods", "Nature/society", "Physical")
types <- list("Quantitative", "Qualitative", "Mixed Methods")
geo_groups <- list(
  "Everyone",
  "Subfield" = subfields,
  "Type" = types
)

# Columns to cast as factors ####
four_levels <- c("Not at all", "Very little", "Somewhat", "To a great extent")
four_level_cols <- c("Q5", "Q7a", "Q7b", "Q7c", "Q7d", "Q7e")

five_levels <- c("Never", "Rarely", "Some of the time", "Most of the time", "Always")
five_level_cols <- c("Q7a_1", "Q7a_3", "Q7b_1", "Q7c_1", "Q7c_2", "Q7c_3", "Q7d_1", "Q7d_2", "Q7e_1")

# Q8 Levels of agreement ####
agree_levels <- c("Strongly disagree", "Disagree", "Don't know", "Agree", "Strongly agree")

# Q8 questions text ####
q8_text <- c(
  Q8_1 = "Failing to reproduce a result often means the original finding is false.",
  Q8_2 = "Failing to reproduce a result rarely detracts from the validity of the original study.",
  Q8_3 = "If a researcher does not share the data used in their study, I trust the results less.",
  Q8_4 = "It is important for students to attempt reproductions as part of their training.",
  Q8_5 = "To be credible, research must be reproducible.",
  Q8_6 = "Reproducibility is incompatible with the epistemologies within my subfield."
)

# Questions for the word cloud ####
cloud_cols <- list("Q6", "Q10")
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

# Function for subplot ####
# Modified from original by Dan Powers <danielp@takomaparkmd.gov> under MIT License
# https://github.com/dpowerstp/plotlywrappers/blob/76d6bb1d5890c81b4fef00472bc1064926f6aa53/R/subplot_title.R
subplot_title <- function(plot, title, .x = 0.05, .y = 1.1) {
  plot %>%
    plotly::add_annotations(
      text = title,
      x = .x,
      y = .y,
      yref = "paper",
      xref = "paper",
      xanchor = "left",
      yanchor = "top",
      showarrow = FALSE,
      font = list(family = "Fira Sans", size = 24)
    )
}

# Plotly styling ####
fira <- list(family = "Fira Sans", size = 16)

plt_layout <- function(plt, ...) {
  plotly::layout(
    plt,
    xaxis = list(title = FALSE, titlefont = fira, tickfont = fira),
    yaxis = list(title = FALSE, titlefont = fira, tickfont = fira),
    font = fira,
    hoverlabel = list(
      font = fira
    ),
    ...
  )
}

# Plotly config ####
# # https://github.com/plotly/plotly.js/blob/master/src/plot_api/plot_config.js
plt_config <- function(plt, filename, ...) {
  plotly::config(
    plt,
    displaylogo = FALSE,
    showTips = FALSE,
    toImageButtonOptions = list(
      format = "png",
      filename = filename,
      # height = 500,
      # width = 700,
      scale = 4
    ),
    ...
  )
}
