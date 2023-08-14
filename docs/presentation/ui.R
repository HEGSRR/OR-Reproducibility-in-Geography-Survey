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
          markdown(
            "
            ### Welcome
            This is an interactive data visualization for
            *Reproducible Research Practices and Barriers to Reproducible Research in Geography:Insights from a Survey*
            by Peter Kedron, Joseph Holler, and Sarah Bardin.

            The purpose of the survey was to systematically develop a baseline of information
            about the state of reproducibility in geography
            and to identify any important differences between subfields and methodological approaches.
            
            This data was collected with an online Qualtrics survey from May 17 to June 10, 2022
            from a random sample of researchers publishing in geographic academic journals as the corresponding author.
            
            The survey inquires researchers about their:
            
            1) understanding and awareness of reproducibility;
            2) awareness and implementation of reproducible research practices;
            3) opinions and perceptions about the role of reproducibility in geography and their subfield; and
            4) experience attempting reproductions of prior studies.
            
            Within each of these themes, responses can be viewed in aggregate (**Everyone**).
            
            Alternatively, subsets of geographers can be selected
            according to one of four *subfields* they are most closely associated with:
            
            - **Human** geography;
            - Spatial analysis and **methods**;
            - **Nature/Society**; or
            - **Physical** geography.
            
            Or, one of three *methods* they most frequently use:
            - **Quantitative**;
            - **Qualitative**; or
            - **Mixed Methods**.
            
            ### Links
            Please read our preprint for this study for more details, including discussions of results:
            
            Kedron, P., Holler, J., & Bardin, S. (2023, June 3).
            *Reproducible Research Practices and Barriers to Reproducible Research in Geography: Insights from a Survey*.
            <https://doi.org/10.31219/osf.io/nyrq9>.
            
            This data visualization is primarily the work of Yifei Luo
            with supervision of Joseph Holler, and can be cited as:
            
            Holler, J., Luo, Y., Kedron, P., & Bardin, S. (2023, August 9). *Reproducibility Survey Data Visualization*.
            <https://doi.org/10.17605/osf.io/b47xu>.
            
            A sample BibTeX entry is as follows:
            
            ```
            @article{holler_2023_reproducibility,
              author = {Holler, Joseph and Luo, Yifei and Kedron, Peter and Bardin, Sarah},
              title = {Reproducibility Survey Data Visualization},
              doi = {10.17605/osf.io/b47xu},
              url = {https://osf.io/b47xu/},
              year = {2023},
              month = {08}
            }
            ```
            
            The code for this visualization is available on GitHub:
            [HEGSRR/OR-Reproducibility-in-Geography-Survey](https://github.com/HEGSRR/OR-Reproducibility-in-Geography-Survey).
            
            The overarching project for this study is available on OSF:
            [A Survey of Reproducibility in Geographic Research](https://osf.io/5yeq8/).
            
            You can also follow progress on our follow-up study on *replicability* here:
            [A Survey of Researcher Perceptions of Replication in Geography](https://osf.io/x6qrk/).
            
            This project was funded through a
            National Science Foundation Directorate for Social, Behavioral and Economic Sciences award,
            number [BCS-2049837](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2049837).
            "
          ),
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
          "Question 5",
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
          "Question 6",
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
          "Question 10",
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
