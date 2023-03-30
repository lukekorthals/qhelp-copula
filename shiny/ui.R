#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Copula"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            
            selectInput("copula", "Select copula", choices = c("gaussian", "fgm", "clayton", "frank", "gumbel", "amh", "joe", "galambos", "huslerReiss", "tawn", "tev", "t")),
            
            selectInput("x_marginal", "Select marginal for x", choices = c("normal", "exponential")),
            
            selectInput("y_marginal", "Select marginal for y", choices = c("normal", "exponential")),
            
            sliderInput("cor_xy", "Determine Correlation", min=0, max=1, step=0.1, value=0.5),
            
            sliderInput("theta", "Set theta", min=-100, max=100, step=0.1, value=0)
        ),

        # Show a plot of the generated distribution
        mainPanel(
          plotlyOutput("surface_plot"),
          
          plotOutput("cdf_plot")
        )
    )
))
