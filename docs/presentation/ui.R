# UI tags ####
tagList(
  # head
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
    tags$link(rel = "shortcut icon", href = "favicon.png"),
  ),
  navbarPage(
    title = "RPr in Geo",

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
      icon = icon("file-alt"),
      fluidRow(
        column(
          12,
          h1("Debugging"),
          verbatimTextOutput("ver"),
          DT::DTOutput("table"),
        ),
      ),
    ),

    # Awareness ####
    tabPanel(
      "Awareness",
      icon = icon("lightbulb"),
      fluidRow(
        class = "plotly-titles",
        column(
          4,
          h4(
            "How ", strong("familiar"),
            "are you with the term \"reproducibility\"?"
          ),
        ),
        column(
          4,
          h4(
            "You ", strong("understand"),
            "\"reproducibility\" in terms of..."
          ),
        ),
        column(
          4,
          h4(
            "What is ", strong("important"),
            "in the context of \"reproducibility\"?"
          ),
        ),
      ),
      plotlyOutput("q5", height = plot_height) %>% spin(),
    ),

    # Concepts ####
    tabPanel(
      "Concepts",
      icon = icon("comments"),
      tabsetPanel(
        id = "q7_panel",
        tabPanel(
          "Open source",
          fluidRow(
            class = "plotly-titles",
            column(
              4,
              h5(
                "How ", strong("familiar"),
                "are you with open source software?",
                br(),
                "How ", strong("often"),
                "do you use open source software?",
              ),
            ),
            column(
              4,
              h5(
                "You use ",
                strong("open source software"),
                "for ...?"
              ),
            ),
            column(
              4,
              h5(
                "How often do you ",
                strong("document or share"),
                "information related to
                the computational processing environment
                used in your own research?"
              ),
            ),
          ),
          plotlyOutput("q7oss", height = plot_height) %>% spin(),
          p(
            "\"Use\" is recoded for visualization as follows:", br(),
            "Never -> Not at all", br(),
            "Rarely -> Very little", br(),
            "Some of the time -> Somewhat", br(),
            "Most of the time -> To a great extent", br(),
            "Always -> To a great extent",
          ),
        ),
        tabPanel(
          "Notebooks",
          fluidRow(
            column(
              6,
              h5(
                "How ", strong("familiar"),
                "are you with lab, field, or computational notebooks?",
                br(),
                "How ", strong("often"),
                "do you use lab, field, or computational notebooks?",
              ),
              plotlyOutput("q7nb", height = plot_height) %>% spin(),
            ),
          ),
        ),
        tabPanel(
          "Data archive",
        ),
        tabPanel(
          "Sharing code",
        ),
        tabPanel(
          "Pre-register",
          fluidRow(
            column(
              6,
              h5(
                "How ", strong("familiar"),
                "are you with pre-registering research designs or protocols?",
                br(),
                "How ", strong("often"),
                "do you use pre-registering for research designs or protocols?",
              ),
              plotlyOutput("q7reg", height = plot_height) %>% spin(),
            ),
          ),
        ),
      ),
    ),

    # Word Cloud ####
    tabPanel(
      "Word Cloud",
      icon = icon("cloud"),
      tabsetPanel(
        id = "clouds",
        tabPanel(
          "Overall",
          fluidRow(
            column(
              3,
              radioButtons(
                "cloud",
                label = h4("Choose a question:"),
                choiceNames = cloud_questions,
                choiceValues = cloud_cols
              ),
            ),
            column(
              9,
              wordcloud2Output(
                "cloud",
                height = plot_full_height
              ),
            ),
          ),
        ),
        tabPanel(
          "Q6 (groupwise)",
          wordcloud2Output(
            "cloud_q6",
            height = plot_full_height
          ),
        )
      ),
    ),

    # More Stuff ####
    tabPanel(
      "More Stuff",
      icon = icon("file-alt"),
      fluidRow(
        column(
          6,
          h1("More Stuff"),
        ),
      ),
    ),
  )
)
