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
      plotlyOutput("q5", height = plot_full_height),
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
            column(
              4,
              h5(
                "How familiar are you with ",
                strong("open source software", .noWS = "after"), "?",
                br(),
                "How often do you use ",
                strong("open source software", .noWS = "after"), "?"
              ),
              plotlyOutput("q7oss", height = plot_height),
              p(
                "\"Use\" is recoded for visualization as follows:", br(),
                "Never -> Not at all", br(),
                "Rarely -> Very little", br(),
                "Some of the time -> Somewhat", br(),
                "Most of the time -> To a great extent", br(),
                "Always -> To a great extent",
              ),
            ),
            column(
              4,
              h5(
                "You use ",
                strong("open source software"),
                "for ...?"
                ),
              plotlyOutput("q7oss_parts", height = plot_height),
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
              plotlyOutput("q7oss_env", height = plot_height),
            ),
          ),
        ),
        tabPanel(
          "Notebooks",
        ),
        tabPanel(
          "Data archive",
        ),
        tabPanel(
          "Sharing code",
        ),
        tabPanel(
          "Pre-register",
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
