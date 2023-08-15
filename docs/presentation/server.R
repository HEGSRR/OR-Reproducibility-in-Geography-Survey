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

  # Q5 plots ####
  output$q5 <- renderPlotly({
    fig1 <- d() %>%
      count(Q5) %>%
      plot_ly(
        x = ~Q5,
        y = ~n,
        type = "bar",
        # https://community.plotly.com/t/33731
        hovertemplate = "<b>%{x}</b>\n%{y} people<extra></extra>"
      )

    fig2 <- d() %>%
      summarize(across(c(dat_rec, pro_rec, res_rec, con_rec), sum)) %>%
      pivot_longer(cols = everything()) %>%
      add_column(label = c(
        "Same data", "Same procedure", "Same result", "Same condition"
      )) %>%
      mutate(label = str_wrap(label, width = width)) %>%
      plot_ly(
        x = ~label,
        y = ~value,
        type = "bar",
        hovertemplate = "<b>%{x}</b>\n%{y} people<extra></extra>"
      )

    fig3 <- d() %>%
      count(label) %>%
      mutate(
        label = label %>%
          str_replace("/", " & ") %>%
          str_wrap(width = width)
      ) %>%
      plot_ly(
        x = ~label,
        y = ~n,
        type = "bar",
        hovertemplate = "<b>%{x}</b>\n%{y} people<extra></extra>"
      )

    plotly::subplot(fig1, fig2, fig3, nrows = 1, shareY = TRUE) %>%
      plt_layout(showlegend = FALSE) %>%
      plt_config(
        filename = paste0(
          "repro_awareness_",
          input$group %>%
            tolower() %>%
            gsub("[^a-z0-9]", "_", .)
        )
      )
  }) %>%
    bindCache(input$group)


  # Q7 open source ####
  output$q7a <- renderPlotly({
    Q7a_1 <- d() %>%
      drop_na(Q7a_1) %>%
      count(Q7a_1)

    plt1 <- d() %>%
      drop_na(Q7a) %>%
      count(Q7a) %>%
      plot_ly(
        x = ~Q7a,
        y = ~n,
        type = "bar",
        name = "Familiar",
        # marker = list(color = "#1b9e77"),
        hovertemplate = "<b>%{x}</b>\n%{y} people"
      ) %>%
      add_bars(
        x = ~Q7a_1,
        y = ~n,
        data = Q7a_1,
        name = "Use OSS",
        # marker = list(color = "#d95f02"),
        hovertemplate = "<b>%{x}</b>\n%{y} people"
      ) %>%
      plt_layout(barmode = "group")

    plt2 <- d() %>%
      select(starts_with("Q7a_2")) %>%
      pivot_longer(cols = everything()) %>%
      filter(value != 0) %>%
      group_by(value) %>%
      summarise(n = n()) %>%
      mutate(value = str_wrap(value, width = width)) %>%
      plot_ly(
        x = ~value,
        y = ~n,
        type = "bar",
        name = "Used for",
        hovertemplate = "<b>%{x}</b>\n%{y} people<extra></extra>"
      )

    plt3 <- d() %>%
      drop_na(Q7a_3) %>%
      count(Q7a_3) %>%
      plot_ly(
        x = ~Q7a_3,
        y = ~n,
        type = "bar",
        # name = "Familiar",
        hovertemplate = "<b>%{x}</b>\n%{y} people<extra></extra>"
      )

    plotly::subplot(plt1, plt2, plt3, nrows = 1, shareY = TRUE) %>%
      plt_layout(showlegend = FALSE) %>%
      plt_config(
        filename = paste0(
          "repro_oss_",
          input$group %>%
            tolower() %>%
            gsub("[^a-z0-9]", "_", .)
        )
      )
  }) %>%
    bindCache(input$group)


  # Q7 notebooks ####
  output$q7b <- renderPlotly({
    Q7b_1 <- d() %>%
      drop_na(Q7b_1) %>%
      count(Q7b_1)

    d() %>%
      drop_na(Q7b) %>%
      count(Q7b) %>%
      plot_ly(
        x = ~Q7b,
        y = ~n,
        type = "bar",
        name = "Familiar",
        # marker = list(color = "#1b9e77"),
        hovertemplate = "<b>%{x}</b>\n%{y} people"
      ) %>%
      add_bars(
        x = ~Q7b_1,
        y = ~n,
        data = Q7b_1,
        name = "Use notebooks",
        # marker = list(color = "#d95f02"),
        hovertemplate = "<b>%{x}</b>\n%{y} people"
      ) %>%
      plt_layout(barmode = "group") %>%
      plt_config(
        filename = paste0(
          "repro_nb_",
          input$group %>%
            tolower() %>%
            gsub("[^a-z0-9]", "_", .)
        )
      )
  }) %>%
    bindCache(input$group)


  # Q7 archive ####
  output$q7c <- renderPlotly({
    Q7c_1 <- d() %>%
      drop_na(Q7c_1) %>%
      count(Q7c_1)

    Q7c_2 <- d() %>%
      drop_na(Q7c_2) %>%
      count(Q7c_2)

    Q7c_3 <- d() %>%
      drop_na(Q7c_3) %>%
      count(Q7c_3)

    d() %>%
      drop_na(Q7c) %>%
      count(Q7c) %>%
      plot_ly(
        x = ~Q7c,
        y = ~n,
        type = "bar",
        name = "Familiar",
        # marker = list(color = "#1b9e77"),
        hovertemplate = "<b>%{x}</b>\n%{y} people"
      ) %>%
      add_bars(
        x = ~Q7c_1,
        y = ~n,
        data = Q7c_1,
        name = "Archive data",
        # marker = list(color = "#d95f02"),
        hovertemplate = "<b>%{x}</b>\n%{y} people"
      ) %>%
      add_bars(
        x = ~Q7c_2,
        y = ~n,
        data = Q7c_2,
        name = "Use DOIs",
        # marker = list(color = "#d95f02"),
        hovertemplate = "<b>%{x}</b>\n%{y} people"
      ) %>%
      add_bars(
        x = ~Q7c_3,
        y = ~n,
        data = Q7c_3,
        name = "Use spatial metadata standards",
        # marker = list(color = "#d95f02"),
        hovertemplate = "<b>%{x}</b>\n%{y} people"
      ) %>%
      plt_layout(barmode = "group") %>%
      plt_config(
        filename = paste0(
          "repro_arch_",
          input$group %>%
            tolower() %>%
            gsub("[^a-z0-9]", "_", .)
        )
      )
  }) %>%
    bindCache(input$group)


  # Q7 codeshare ####
  output$q7d <- renderPlotly({
    Q7d_1 <- d() %>%
      drop_na(Q7d_1) %>%
      count(Q7d_1)

    Q7d_2 <- d() %>%
      drop_na(Q7d_2) %>%
      count(Q7d_2)

    d() %>%
      drop_na(Q7d) %>%
      count(Q7d) %>%
      plot_ly(
        x = ~Q7d,
        y = ~n,
        type = "bar",
        name = "Familiar",
        # marker = list(color = "#1b9e77"),
        hovertemplate = "<b>%{x}</b>\n%{y} people"
      ) %>%
      add_bars(
        x = ~Q7d_1,
        y = ~n,
        data = Q7d_1,
        name = "Share scripts",
        # marker = list(color = "#d95f02"),
        hovertemplate = "<b>%{x}</b>\n%{y} people"
      ) %>%
      add_bars(
        x = ~Q7d_2,
        y = ~n,
        data = Q7d_2,
        name = "Use version control",
        # marker = list(color = "#d95f02"),
        hovertemplate = "<b>%{x}</b>\n%{y} people"
      ) %>%
      plt_layout(barmode = "group") %>%
      plt_config(
        filename = paste0(
          "repro_code_",
          input$group %>%
            tolower() %>%
            gsub("[^a-z0-9]", "_", .)
        )
      )
  }) %>%
    bindCache(input$group)


  # Q7 pre-reg ####
  output$q7e <- renderPlotly({
    Q7e_1 <- d() %>%
      drop_na(Q7e_1) %>%
      count(Q7e_1)

    d() %>%
      drop_na(Q7e) %>%
      count(Q7e) %>%
      plot_ly(
        x = ~Q7e,
        y = ~n,
        type = "bar",
        name = "Familiar",
        # marker = list(color = "#1b9e77"),
        hovertemplate = "<b>%{x}</b>\n%{y} people"
      ) %>%
      add_bars(
        x = ~Q7e_1,
        y = ~n,
        data = Q7e_1,
        name = "Use pre-registering",
        # marker = list(color = "#d95f02"),
        hovertemplate = "<b>%{x}</b>\n%{y} people"
      ) %>%
      plt_layout(barmode = "group") %>%
      plt_config(
        filename = paste0(
          "repro_prereg_",
          input$group %>%
            tolower() %>%
            gsub("[^a-z0-9]", "_", .)
        )
      )
  }) %>%
    bindCache(input$group)


  # Q8 likert ####
  output$q8 <- renderPlotly({
    plt <- q8[[input$group]] %>%
      # ggplot
      ggplot() +
      geom_segment(aes(
        x = fct_rev(name),
        y = start,
        xend = name, yend = start + perc,
        colour = value,
        text = paste0(
          "<b>", value, "</b><br>",
          n, " people<br>",
          round(perc * 100, 2), " %"
        )
      ), linewidth = 12) +
      geom_hline(yintercept = 0, color = c("#646464")) +
      coord_flip() +
      scale_color_manual("Response", values = pal, guide = "legend") +
      labs(title = "", y = "Percent", x = "") +
      scale_x_discrete(
        labels = str_wrap(rev(q8_text), width = 40)
      ) +
      scale_y_continuous(labels = scales::percent) +
      theme_minimal() +
      theme(
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank()
      )
    # plotly
    ggplotly(plt, tooltip = "text") %>%
      plt_layout(
        legend = list(font = fira)
      ) %>%
      plt_config(
        filename = paste0(
          "repro_views_",
          input$group %>%
            tolower() %>%
            gsub("[^a-z0-9]", "_", .)
        )
      )
  }) %>%
    bindCache(input$group)


  # Q13 percentages ####
  output$q13 <- renderPlotly({
    all_geo <- d()$Q13_1 %>%
      density(na.rm = TRUE)

    subfield <- d()$Q13_2 %>%
      density(na.rm = TRUE)

    plot_ly(
      x = ~ all_geo$x,
      y = ~ all_geo$y,
      type = "scatter",
      mode = "lines",
      fill = "tozeroy",
      name = "Geography",
      hovertemplate = "%{x:.2f}%\n%{y:.2%}"
    ) %>%
      add_trace(
        x = ~ subfield$x,
        y = ~ subfield$y,
        type = "scatter",
        mode = "lines",
        fill = "tozeroy",
        name = "Your primary\nsubfield",
        line = list(dash = "dash")
      ) %>%
      plt_layout(
        legend = list(font = fira)
      ) %>%
      plotly::layout(
        xaxis = list(range = list(0, 100), ticksuffix = "%"),
        yaxis = list(tickformat = ".1%"),
        hovermode = "x"
      ) %>%
      plt_config(
        filename = paste0(
          "repro_published_",
          input$group %>%
            tolower() %>%
            gsub("[^a-z0-9]", "_", .)
        )
      )
  }) %>%
    bindCache(input$group)


  # Q9 practices ####
  output$q9 <- renderPlotly({
    d() %>%
      plt_bar(
        "Q9", q9_text, pal3, width_long,
        paste0(
          "repro_practices_",
          input$group %>%
            tolower() %>%
            gsub("[^a-z0-9]", "_", .)
        )
      )
  }) %>%
    bindCache(input$group)

  # Q14 barriers ####
  output$q14 <- renderPlotly({
    d() %>%
      plt_bar(
        "Q14", q14_text, pal5, width_long,
        paste0(
          "repro_barriers_",
          input$group %>%
            tolower() %>%
            gsub("[^a-z0-9]", "_", .)
        )
      )
  }) %>%
    bindCache(input$group)


  # Q17 importance ####
  output$q17 <- renderPlotly({
    d() %>%
      plt_bar(
        "Q17_", q17_text, pal5, width_long,
        paste0(
          "repro_importance_",
          input$group %>%
            tolower() %>%
            gsub("[^a-z0-9]", "_", .)
        )
      )
  }) %>%
    bindCache(input$group)


  # Q6 & Q10 word clouds ####
  output$cloud_q6 <- renderWordcloud2(clouds_q6[[input$group]])
  output$cloud_q10 <- renderWordcloud2(clouds_q10[[input$group]])
}
