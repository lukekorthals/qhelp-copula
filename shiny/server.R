#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
print(getwd())

library(shiny)
library(dplyr)
library(plotly)
source("utilities/copula.R")
source("utilities/marginals.R")
source("utilities/plots.R")

# Define server logic required to draw a histogram
server <- function(input, output){
  
  # print short introduction
  output$short_intro <- renderUI({
    HTML(paste(
    "In this shiny app, you can test if the independent race model can explain
    data from the stop-signal task. We want to know if go and stop signal
    processing times are independent of each other. If the independent race
    model cannot explain your generated data, go and stop signal processing
    times may be dependent on each other. To describe how these two distributions
    relate to each other, we could use use a Copula.",
    " ", " ", sep="<br/>"))
  })
  
  # print explanation if action button is pressed
  output$explain <- renderUI({
    # show text when number of clicks is uneven; hide if even
    if(input$action_explain %% 2 == 1){
      updateActionButton(inputId = "action_explain", label = "Got it!")
      renderUI({HTML("The stop signal paradigm is an experimental setup in which 
        participants are instructed to respond to a cue ('go' signal) as fast as 
        possible, for example by pressing a button. However, on some trials, the
        'go' signal is followed by a 'stop' signal. On these trials, participants
        should try not to respond.<br>
        What cognitive processes determine whether the participant manages to avoid
        responding to a stop signal? The general race model assumes that there is a
        race between two processes: the processing of the go signal and the processing
        of the stop signal. The process that is completed first 'wins' and determines
        the response. For example, if the stop signal processing is completed before
        the go signal processing, the participant will not respond to the stop signal. <br> <br>
        <img src='stop_signal_paradigm.png' alt='Stop Signal Paradigm' width='400' height='400'>")})
    } else {
      updateActionButton(inputId = "action_explain", label = "What is the stop signal task?")
      tagList()
    }
  })
  
  output$race_def <- renderUI({
    # show text when number of clicks is uneven; hide if even
    if(input$action_racemodel %% 2 == 1){
      updateActionButton(inputId = "action_racemodel", label = "Got it!")
      HTML("The independent race model proposes that the distribution of
      the go-signal processing times (T<sub>go</sub>) and distribution of the stop-signal
      processing times (T<sub>stop</sub>) are independent of each other. In other words, the time
      it takes to process a go-signal does not depend on the time it takes to
      process a stop signal and vice versa.")
    } else {
      updateActionButton(inputId = "action_racemodel", label = "What is the independent race model about?")
      tagList()
    }
  })
  
  output$copula_def <- renderUI({
    # show text when number of clicks is uneven; hide if even
    if(input$action_copula %% 2 == 1){
      updateActionButton(inputId = "action_copula", label = "Got it!")
      renderUI({HTML(paste("A copula is a multivariate dsitribution function consisting of uniform marginal distributions. 
        This means, it describes how two or more variables relate to each other. <br> Using a Copula
        instead of a Multivariate Normal has two big advantages:",
        "<ul><li>The marginal distributions of the variables don't have to be normal.</li>
        <li>The marginal distributions of the variables don't have to be the same.</li></ul>",
        "In this shiny app, you can choose a copula function that describes the relationship
        between T<sub>go</sub> and T<sub>stop</sub> also specify a marginal function for each individual variable."))})
    } else {
      updateActionButton(inputId = "action_copula", label = "What is a copula?")
      tagList()
    }
  })
  
  # insert functions to compute chosen copula 
  copula <- reactive({
    cor_copula <- c("gaussian", "fgm")
    df_copula <- c("t")
    theta_copula <- c("clayton", "frank", "gumbel", "amh", "joe", "galambos", "huslerReiss", "tawn", "tev")
    if (input$copula %in% cor_copula){
      copula <- generate_copula_from_cor(cor_xy = input$cor_xy, copula = input$copula)
    } else if (input$copula %in% df_copula) {
      copula <- generate_copula_from_cor_df(input$cor_xy, input$df, copula = input$copula)
    } else if (input$copula %in% theta_copula) {
      copula <- generate_copula_from_theta(theta = input$theta, copula = input$copula)
    }
  }) 
  
  # marginals for x and y
  marginal_x <- reactive({
    marginal_x <- extract_marginal(copula()$samples[,1], 
                                   input$x_marginal, 
                                   scale_mean = input$scale_mean_x,
                                   scale_sd = input$scale_sd_x) 
  })
  
  marginal_y <- reactive({
    marginal_y <- extract_marginal(copula()$samples[,2], 
                                   input$y_marginal, 
                                   scale_mean = input$scale_mean_y,
                                   scale_sd = input$scale_sd_y) + input$t_d
  })
  
  # plot surface of copula
  output$surface_plot <- renderPlotly({
    plot_surface(marginal_x(), marginal_y())
  })
  
  # plot marginals if box checked
  output$marginal_plot <- renderPlotly({
    if(input$show_marginals) {
      plot_marginals(marginal_x(), marginal_y())
    }
  })
  
  # print explanation of condition
  output$explain_cond <- renderUI({
    HTML(paste("The plot below tests the independent race model. The independent race model
    implies that the CDF of all go-signal processing times (red line) should be
    smaller than or equal to the CDF of only the go-signal processing times of
    the trials where go-signal processing was completed earlier than stop-signal
    processing (blue line).\n In the plot below, you can check if this condition
    holds for the data you generated from your chosen combination of copula and
    marginals. If the red line is left of the blue line, the independent race
    model cannot explain the data. This would suggest that the T<sub>go</sub> and
    T<sub>stop</sub> distributions are not independent of each other, but depend on/are
    coupled to each other.", " ", " ", sep="<br/>"))
  })
  
  # plot cdf 
  output$cdf_plot <- renderPlot({
    print(plot_cdf(marginal_x(), marginal_y()))
  })
  
  # check if condition is fulfilled
  #output$condition_fulfilled <- renderText({
  # insert function to derive distributions
  
  # insert function to check if condition is fulfilled
  
  # store boolean in object called is_fulfilled
  # paste("Condition $P(T_{go} \le s) \le P(T_{go} \le s | T_{go} < T_{stop} + t_d)$ fulfilled?", is_fulfilled)
  #})
  
}

#shinyApp(ui = ui, server = server)
