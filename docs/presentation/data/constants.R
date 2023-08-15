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

# Q9 questions text ####
q9_text <- c(
  Q9_1 = "Thought about the reproducibility of your research",
  Q9_2 = "Spoke with colleagues about reproducibility",
  Q9_3 = "Questioned the reproducibility of published research",
  Q9_4 = "Published original data with your study",
  Q9_5 = "Published code and/or protocols with your study",
  Q9_6 = "Considered reproducibility while peer reviewing a grant or publication",
  Q9_7 = "Attempted to reproduce your own or someone else's research"
)

# Q14 questions text ####
q14_text <- c(
  Q14_1 = "Fraud (e.g., fabricated or falsified results)",
  Q14_2 = "Pressure to publish for career advancement",
  Q14_3 = "Insufficient oversight or mentoring",
  Q14_4 = "Lack of publishing raw data",
  Q14_5 = "Lack of publishing research protocols or computer code",
  Q14_6 = "Lack of publishing full results",
  Q14_7 = "Differences in the software processing environment",
  Q14_8 = "Use of proprietary data or software",
  Q14_9 = "Complexity and variability of geographic systems",
  Q14_10 = "Random effects",
  Q14_11 = "Insufficient documentation about study data (metadata)",
  Q14_12 = "Researcher positionality"
)

# Q17 questions text ####
q17_text <- c(
  Q17_1 = "Validating research findings",
  Q17_2 = "Reducing the risk of errors in the research process",
  Q17_3 = "Increasing trust in study results",
  Q17_4 = "Preventing duplication of efforts in future research projects",
  Q17_5 = "Establishing credibility of research in geography",
  Q17_6 = "Establishing credibility of research in your primary subfield",
  Q17_7 = "Communicating research to academics",
  Q17_8 = "Communicating research to practitioners",
  Q17_9 = "Training geography students",
  Q17_10 = "Meta-analyses"
)

# Questions for the word cloud ####
cloud_cols <- list("Q6", "Q10")

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


# Function for bar plots
plt_bar <- function(data, prefix, names, pal, label_width, filename) {
  plt <- data %>%
    pivot_longer(starts_with(prefix), values_to = "Response") %>%
    group_by(name) %>%
    mutate(
      Response = fct_na_value_to_level(Response, "No response"),
    ) %>%
    dplyr::count(Response) %>%
    mutate(perc = n / sum(n)) %>%
    ggplot(aes(
      x = fct_rev(name),
      y = n,
      fill = Response,
      text = paste0(
        "<b>", Response, "</b><br>",
        n, " people<br>",
        round(perc * 100, 2), " %"
      )
    )) +
    geom_col(
      position = position_fill(reverse = TRUE),
      width = 0.8
    ) +
    coord_flip() +
    scale_fill_manual(
      values = pal
    ) +
    scale_x_discrete(
      expand = c(0, 0),
      labels = str_wrap(rev(names), width = label_width)
    ) +
    scale_y_continuous(labels = scales::percent) +
    theme(
      axis.title.x = element_blank(),
      axis.title.y = element_blank(),
      axis.line.y = element_blank(),
      axis.ticks.y = element_blank(),
      panel.border = element_blank(),
      panel.background = element_blank(),
      text = element_text(family = "Fira Sans"),
      legend.position = "bottom",
      legend.title = element_blank()
    )
  # plotly
  ggplotly(plt, tooltip = "text") %>%
    plt_layout(
      legend = list(font = fira)
    ) %>%
    plt_config(
      filename = filename
    )
}

