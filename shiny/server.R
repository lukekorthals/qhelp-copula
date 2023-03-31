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
source("utilities/content.R")

# Define server logic required to draw a histogram
server <- function(input, output){
  
  # print short introduction
  output$short_intro <- renderText({
    "The goal of this project is to generate and visualize cumulative probability
    distributions of reaction times in the general race model using copulas.
    With the help of a shiny-app, the user can try out different starting 
    configurations by choosing custom copulae and marginals. "
  })
  
  # print explanation if action button is pressed
  output$explain <- renderUI({
    # show text when number of clicks is uneven; hide if even
    if(input$action_explain %% 2 == 1){
      updateActionButton(inputId = "action_explain", label = "Hide explanation")
      renderText({"The stop signal paradigm is an experimental setup within which 
        subjects are instructed to respond to a cue ('go' signal) as fast as 
        possible by for example pressing a button (no stop signal trials). 
        In a small subset of trials, shortly after the 'go' signal, an additional 
        'stop' signal is presented which requires participants to inhibit the 
        initiated response. Within these stop-signal trials, participants might
        or might not manage to inhibit the go."})
    } else {
      updateActionButton(inputId = "action_explain", label = "What is the stop signal task?")
      tagList()
    }
  })
  
  output$copula_def <- renderUI({
    # show text when number of clicks is uneven; hide if even
    if(input$action_copula %% 2 == 1){
      updateActionButton(inputId = "action_copula", label = "Hide definition")
      renderText({"A copula is..."})
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
    marginal_x <- extract_marginal(copula()$samples[,1], input$x_marginal, scale_mean = input$scale_mean_x) 
  })
  
  marginal_y <- reactive({
    marginal_y <- extract_marginal(copula()$samples[,2], input$y_marginal, scale_mean = input$scale_mean_y) + input$t_d
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
  output$explain_cond <- renderText({
    print(explanation_cdf())
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
