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
  
  titlePanel(title = div(img(src = "logo.jpg",width = "100px"),
                         "Testing the Independent Race Model with Copulas")),
  
  br(),
  hr(),
 
   # short intro text
  fluidRow(
    column(12,
           htmlOutput("short_intro"))
  ),
  
  # action button explaining project
  fluidRow(
    column(12, 
           actionButton("action_explain", "What is the stop signal task?"), 
           htmlOutput("explain")
    )
  ),
  
  hr(),
  
  # action button definition copula
  fluidRow(
    column(12, 
           actionButton("action_racemodel", "What is the independent race model about?"), 
           htmlOutput("race_def")
    )
  ),

  hr(),
  
  # action button definition copula
  fluidRow(
    column(12, 
           actionButton("action_copula", "What is a copula again?"), 
           htmlOutput("copula_def")
    )
  ),
  
  br(),
  hr(style="border-top: 1px solid #000000;"), 
  
  titlePanel("Choose copula and marginals"),
  br(),
  fluidRow(
    column(4,   
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
           br(),
           
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
           
    ), 
    
    column(8,
           # output: plot surface of copula
           plotlyOutput(outputId = "surface_plot"), 
    ),
  ),
  
  br(),
  hr(),
  
  fluidRow(
    column(4,
           # choose marginal for x  
           selectInput(inputId  = "x_marginal", 
                        label    = "Select marginal for Tgo", 
                        choices  = c(Normal = "normal", 
                                     Exponential = "exponential",
                                     `Log Normal` = "logNormal",
                                     `Ex Gaussian` = "exGaussian",
                                     `Double Exponential` = "doubleExponential",
                                     `Weibull (default shape = 5`= "weibull"), 
                        selected = "normal"),
           br(),
           # choose mean of Tgo distribution
           sliderInput(inputId = "scale_mean_x",
                       label   = "Choose mean of processing time of GO signal (in ms)",
                       min = 100, max = 1000, value = 300),
           
           br(),
           
           # choose sd of Tgo distribution
           sliderInput(inputId = "scale_sd_x",
                       label   = "Choose sd of processing time of GO signal (in ms)",
                       min = 10, max = 50, step=1, value = 15),
           
           br(),
           # choose marginal of Tstop
           selectInput(inputId  = "y_marginal", 
                        label    = "Select marginal for Tstop", 
                        choices  = c(Normal = "normal", 
                                     Exponential = "exponential",
                                     `Log Normal` = "logNormal",
                                     `Ex Gaussian` = "exGaussian",
                                     `Double Exponential` = "doubleExponential",
                                     `Weibull (default shape = 5` = "weibull"),
                        selected = "normal"),
           br(),
           
           # choose sd of Tstop distribution
           sliderInput(inputId = "scale_sd_y",
                       label   = "Choose sd of processing time of STOP signal (in ms)",
                       min = 10, max = 50, step=1, value = 15),
           
           br(),
           # choose mean of Tstop distribution
           sliderInput(inputId = "scale_mean_y",
                       label   = "Choose mean of processing time for STOP signal (in ms)",
                       min = 100, max = 1000, value = 300),
           br(),
           # choose delay for Tstop
           sliderInput(inputId = "t_d",
                       label   = "Choose delay of response to STOP signal (in ms)",
                       min = 1, max = 1000, value = 100),
           br(),
           # checkbox: see marginals? 
           checkboxInput(inputId = "show_marginals", 
                         label = "Visualize chosen marginals", 
                         value = TRUE),
          
    ), 
    
    column(8, align = "center",
           # Output: show marginals
           plotlyOutput("marginal_plot")
    )
  ), 
  
  hr(style="border-top: 1px solid #000000;"),
  
  titlePanel("Testing the Condition"),
  
  br(),
  
  fluidRow(
    # short explanation of condition
    column(12,
           htmlOutput("explain_cond"))
  ),
  
  fluidRow(
    column(8,
           # Output: plot distributions 
           plotOutput(outputId = "cdf_plot")
           ),
    column(4, 
           # Output: is condition fulfilled?
           textOutput(outputId = "condition_fulfilled")
           )
  )
)
      
