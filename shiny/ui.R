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

# Define UI for application 

ui <- fluidPage(
  titlePanel("Heading"),
  fluidRow(
    column(12,  # for action button
           actionButton("action_explain", "What is this about?"), 
           uiOutput("explain")
    )
  ),
  
  titlePanel("Choose copula"),
  fluidRow(
    column(4,   # for copula input
           # choose copula
           selectInput(inputId = "copula",
                       label = "Choose copula",
                       c(Gaussian = "gaussian", 
                         `Farlie Gumbel Morgenstern` = "fgm",
                         "t", 
                         Clayton = "clayton",
                         Frank= "frank",     
                         Gumbel = "gumbel",
                         `Ali Mikhail Haq` = "amh",
                         Joe = "joe",
                         Galambos = "galambos",
                         `Hüsler Reiß` = "huslerReiss",
                         Tawn = "tawn",
                         `t Extreme Value` = "tev"
                       )
           ),
           
           # if fgm, gaussian, or t copula: choice of correlation
           conditionalPanel(
             condition = "input.copula == 'fgm' | input.copula == 'gaussian' | input.copula == 't'",
             sliderInput(inputId = "cor_xy", 
                         label = "Determine Correlation", 
                         min=0, max=1, step=0.1, value=0.5),
             
             # if t copula: additionally choice of df
             conditionalPanel(
               condition = "input.copula == 't'",
               sliderInput(inputId = "df", 
                           label = "Determine degrees of freedom", 
                           min=1, max=50, step=1, value=5),
             )
           ),
           # if other copula: choice of theta
           conditionalPanel(
             condition = "input.copula != 'gaussian' & input.copula != 'fgm' & input.copula != 't'",
             sliderInput(inputId = "theta", 
                         label = "Determine theta", 
                         min=-50, max=50, step=0.1, value=0),
           ),
           # choose marginals for x and y 
           radioButtons(inputId  = "x_marginal", 
                        label    = "Select marginal for x", 
                        choices  = c(Normal = "normal", 
                                     Exponential = "exponential",
                                     `Log Normal` = "logNormal",
                                     `Ex Gaussian` = "exGaussian",
                                     `Double Exponential` = "doubleExponential",
                                     Weibull = "weibull"), 
                        selected = "normal"),
           
           radioButtons(inputId  = "y_marginal", 
                        label    = "Select marginal for y", 
                        choices  = c(Normal = "normal", 
                                     Exponential = "exponential",
                                     `Log Normal` = "logNormal",
                                     `Ex Gaussian` = "exGaussian",
                                     `Double Exponential` = "doubleExponential",
                                     Weibull = "weibull"),
                        selected = "normal")  
    ), 
    
    column(8,   # copula output
           # output: plot surface of copula
           plotlyOutput(outputId = "surface_plot")
    )
  ), 
  titlePanel("Condition"),
  
  fluidRow(
    column(4,   # for condition input
           # Input: slider for delay parameter t_d
           sliderInput(inputId = "slider_td",
                       label   = "Choose delay parameter (in ms)",
                       min = 1, max = 1000, value = 100),
           
           # Input: slider for scaling 
           sliderInput(inputId = "scale_mean",
                       label   = "Choose mean of processing time in ms",
                       min = 100, max = 1000, value = 300)
           
    ), 
    
    column(8,   # condition output
           # Output: plot distributions 
           plotOutput(outputId = "cdf_plot"),
           
           # Output: is condition fulfilled?
           textOutput(outputId = "condition_fulfilled")
           
    )
  ), 
  
  
)