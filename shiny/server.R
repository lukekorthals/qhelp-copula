#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

setwd("./utilities")

library(shiny)
library(dplyr)
library(plotly)
source("copula.R")
source("marginals.R")
source("plots.R")

# Define server logic required to draw a histogram
server <- function(input, output){
  
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
  
  
  # plot surface of copula
  output$surface_plot <- renderPlotly({
    print(copula()$surface_plot)
  })
  
  # plot cdf 
  output$cdf_plot <- renderPlot({
    u <- copula()$samples[,1]
    v <- copula()$samples[,2]
    u <- extract_marginal(u, input$x_marginal)
    v <- extract_marginal(v, input$y_marginal)
    u_ <- data.frame(u, v) %>%
      mutate(uv = u-v) %>%
      filter(uv < 0) %>%
      select(u) %>%
      unlist()
    u <- sample(u, 1000, replace=TRUE)
    u_ <- sample(u_, 1000, replace=TRUE)
    print(plot_cdf(u, u_))
  })
  
  # check if condition is fulfilled
  #output$condition_fulfilled <- renderText({
  # insert function to derive distributions
  
  # insert function to check if condition is fulfilled
  
  # store boolean in object called is_fulfilled
  # paste("Condition $P(T_{go} \le s) \le P(T_{go} \le s | T_{go} < T_{stop} + t_d)$ fulfilled?", is_fulfilled)
  #})
  
}

shinyApp(ui = ui, server = server)
