# server function ####
function(input, output, session) {
  # Data ####
  d <- reactive({
    analysis %>%
      # No idea why ifelse and if_else don't work
      dplyr::filter(
        if (input$group %in% subfields) {
          .data$Q3_recoded == input$group
        } else if (input$group %in% types) {
          .data$Q4 == input$group
        } else {
          TRUE
        }
      )
  }) %>%
    bindCache(input$group) %>%
    bindEvent(input$group)

  # table for debugging ####
  output$table <- d() %>%
    # Had to use |> because %>% isn't working here, idk why
    # Sounds like https://github.com/tidyverse/magrittr/issues/159
    DT::datatable(extensions = "Responsive") |>
    DT::renderDT()

  # More debugging ####
  output$ver <- renderPrint(input$group)

  # Q5 plots ####
  output$q5 <- renderPlotly({
    fig1 <- d() %>%
      count(Q5) %>%
      plot_ly(
        x = ~Q5,
        y = ~n,
        type = "bar",
        color = ~Q5,
        colors = mako4,
        # https://community.plotly.com/t/33731
        hovertemplate = "<b>%{x}</b>\n%{y} people<extra></extra>"
      ) %>%
      subplot_title("Familiarity with \"reproducibility\"")

    fig2 <- d() %>%
      summarize(across(c(dat_rec, pro_rec, res_rec, con_rec), sum)) %>%
      pivot_longer(cols = everything()) %>%
      add_column(label = c(
        "Same data", "Same procedure", "Same result", "Same condition"
        )) %>%
      plot_ly(
        x = ~label,
        y = ~value,
        color = ~label,
        colors = pal5,
        type = "bar",
        hovertemplate = "<b>%{x}</b>\n%{y} people<extra></extra>"
      ) %>%
      subplot_title("Reproducibility in terms of...")

    fig3 <- d() %>%
      count(label) %>%
      mutate(
        label = label %>%
          str_replace("/", " & ") %>%
          str_wrap(width = 20)
      ) %>%
      plot_ly(
        x = ~label,
        y = ~n,
        type = "bar",
        color = ~label,
        colors = pal5,
        hovertemplate = "<b>%{x}</b>\n%{y} people<extra></extra>"
      ) %>%
      subplot_title("What is important in reproducibility?")

    plotly::subplot(fig1, fig2, fig3, nrows = 1, shareY = TRUE) %>%
      plt_layout(
        showlegend = FALSE,
        # top margins
        margin = list(t = 100)
      ) %>%
      plt_config(
        filename = paste0(
          "repro_awareness_",
          input$group %>%
            tolower() %>%
            gsub("[^a-z0-9]", "_", .)
        )
      )
  })


  # Word cloud ####
  output$cloud <- renderWordcloud2(clouds[[input$cloud]])
  output$cloud_q6 <- renderWordcloud2(clouds_q6[[input$group]])
}
