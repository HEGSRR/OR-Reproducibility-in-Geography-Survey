# UI tags ####
tagList(
  # head
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
    tags$link(rel = "shortcut icon", href = "favicon.png"),
  ),
  navbarPage(
    title = "Reproducibility in Geographic Research",

    # customization
    id = "activeTab",
    theme = bslib::bs_theme(
      fg = "#212529", primary = "#1D5B79", secondary = "#C5DFF8",
      success = "#8EAC50", info = "#468B97", warning = "#F1C93B",
      base_font = bslib::font_google("Fira Sans"),
      code_font = bslib::font_google("Fira Code"),
      bootswatch = "flatly", bg = "#FFFFFF"
    ),
    windowTitle = "Reproducibility in Geographic Research",
    # Access with `Shiny.shinyapp.$inputValues`
    header = # conditionalPanel(
    # condition = "input.activeTab !== 'Word Cloud'",
      selectInput(
        "group", h5("Choose a group:"),
        geo_groups,
      ),
    # ),

    # About ####
    tabPanel(
      "About",
      icon = icon("info"),
      fluidRow(
        column(
          12,
          # col-sm-12
          class = "col-lg-10 col-xl-8 col-xxl-6",
          style = "margin-left: 3vw;",
          markdown(about),
        ),
      ),
    ),

    # Awareness ####
    tabPanel(
      "Awareness",
      icon = icon("bullhorn"),
      tabsetPanel(
        id = "awareness-panel",
        tabPanel(
          "Concept",
          fluidRow(
            column(
              4,
              h4(
                "How ", strong("familiar"),
                "are you with the term “reproducibility”?"
              ),
            ),
            column(
              4,
              h4(
                "You ", strong("understand"),
                "“reproducibility” in terms of..."
              ),
            ),
            column(
              4,
              h4(
                "What is the main", strong("motivation"),
                "of “reproducibility”?"
              ),
            ),
          ),
          plotlyOutput("q5", height = plot_height) %>% spin(),
        ),
        tabPanel(
          "Definition",
          h4(
            "What is your ", strong("understanding"),
            "of the term “reproducibility”",
            "in the context of your own research?",
          ),
          wordcloud2Output(
            "cloud_q6",
            height = plot_height
          ),
        ),
        tabPanel(
          "Motivation",
          h4(
            "Thinking about the reproduction(s)",
            "you attempted in the last 2 years,",
            "What made you decide to ", strong("attempt"),
            "the reproduction(s)?",
          ),
          wordcloud2Output(
            "cloud_q10",
            height = plot_height
          ),
        ),
      ),
    ),

    # Practices ####
    tabPanel(
      "Practices",
      icon = icon("lightbulb"),
      tabsetPanel(
        id = "q7_panel",
        tabPanel(
          "Open source",
          fluidRow(
            column(
              4,
              h4(
                "How ", strong("familiar"),
                "are you with open source software?"
              ),
              h4(
                "How ", strong("often"),
                "do you use open source software?",
                class = "no-mt"
              ),
            ),
            column(
              4,
              h4(
                "You use ",
                strong("open source software"),
                "for ...?"
              ),
            ),
            column(
              4,
              h4(
                "How often do you ",
                strong("document or share"),
                "information related to
                the computational processing environment
                used in your own research?"
              ),
            ),
          ),
          plotlyOutput("q7a", height = plot_height) %>% spin(),
          markdown(
            "
            “Use” is recoded for visualization as follows:

            - Never &rarr; Not at all
            - Rarely &rarr; Very little
            - Some of the time &rarr; Somewhat
            - Most of the time &rarr; To a great extent
            - Always &rarr; To a great extent
            "
          ),
        ),
        tabPanel(
          "Notebooks",
          fluidRow(
            column(
              12,
              h4(
                "How ", strong("familiar"),
                "are you with lab, field, or computational notebooks?"
              ),
              h4(
                "How ", strong("often"),
                "do you use lab, field, or computational notebooks?",
                class = "no-mt",
              ),
            ),
            column(
              12,
              # col-sm-12
              class = "col-lg-10 col-xl-8",
              plotlyOutput("q7b", height = plot_height) %>% spin(),
            ),
          ),
        ),
        tabPanel(
          "Data archive",
          column(
            12,
            h4(
              "How ", strong("familiar"),
              "are you with sharing or archiving data?"
            ),
            h4(
              "How ", strong("often"),
              "do you publicly share or archive data in your own research?",
              class = "no-mt"
            ),
            h4(
              "How ", strong("often"),
              "do you use digital object identifiers (DOIs) ",
              "when public sharing or archiving data in your own research?",
              class = "no-mt"
            ),
            h4(
              "How ", strong("often"),
              "do you use spatial metadata standards ",
              "when publicly sharing or archiving data in your own research?",
              class = "no-mt"
            ),
          ),
          column(
            12,
            # col-sm-12
            class = "col-lg-10 col-xl-8",
            plotlyOutput("q7c", height = plot_height) %>% spin(),
          ),
        ),
        tabPanel(
          "Sharing code",
          column(
            12,
            h4(
              "How ", strong("familiar"),
              "are you with publicly sharing code or scripts?"
            ),
            h4(
              "How ", strong("often"),
              "do you publicly share code or scripts in your own research?",
              class = "no-mt"
            ),
            h4(
              "How ", strong("often"),
              "do you use version control software (e.g., Git) ",
              "to facilitate sharing code or scripts in your research?",
              class = "no-mt"
            ),
          ),
          column(
            12,
            # col-sm-12
            class = "col-lg-10 col-xl-8",
            plotlyOutput("q7d", height = plot_height) %>% spin(),
          ),
        ),
        tabPanel(
          "Pre-register",
          fluidRow(
            column(
              12,
              h4(
                "How ", strong("familiar"),
                "are you with pre-registering research designs or protocols?",
              ),
              h4(
                "How ", strong("often"),
                "do you use pre-registering for research designs or protocols?",
                class = "no-mt"
              ),
            ),
            column(
              12,
              # col-sm-12
              class = "col-lg-10 col-xl-8",
              plotlyOutput("q7e", height = plot_height) %>% spin(),
            ),
          ),
        ),
      ),
    ),

    # Opinions ####
    tabPanel(
      "Opinions",
      icon = icon("comments"),
      tabsetPanel(
        id = "op_panel",
        tabPanel(
          "Views",
          fluidRow(
            column(
              12,
              # col-sm-12
              class = "col-xxl-8",
              h4(
                "To what extent do you agree with the following",
                "statements about research in your subfield?",
              ),
              plotlyOutput("q8", height = plot_height) %>% spin(),
            ),
          ),
        ),
        tabPanel(
          "Published results",
          fluidRow(
            column(
              12,
              # col-sm-12
              class = "col-xxl-8",
              h4(
                "In your opinion, what percentage of the",
                "published results are reproducible within...?",
              ),
              plotlyOutput("q13", height = plot_height) %>% spin(),
            ),
          ),
        ),
        tabPanel(
          "Importance",
          fluidRow(
            column(
              12,
              # col-sm-12
              class = "col-xxl-10",
              h4(
                "How important is reproducibility within your subfield for...?",
              ),
              plotlyOutput("q17", height = plot_full_height) %>% spin(),
            ),
          ),
        ),
        tabPanel(
          "Barriers",
          fluidRow(
            column(
              12,
              # col-sm-12
              class = "col-xxl-10",
              h4(
                "In your opinion,",
                "how frequently do each of these factors contribute",
                "to a lack of reproducibility in research in your subfield?",
              ),
              plotlyOutput("q14", height = plot_full_height) %>% spin(),
            ),
          ),
        ),
      ),
    ),

    # Experience ####
    tabPanel(
      "Experience",
      icon = icon("bullseye"),
      fluidRow(
        column(
          12,
          # col-sm-12
          class = "col-xxl-10",
          h4("In the last 2 years, have you...?"),
          plotlyOutput("q9", height = plot_height) %>% spin(),
        ),
      ),
    ),
  )
)
