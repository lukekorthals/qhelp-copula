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
  titlePanel("Header"),
  
  tabsetPanel(
    # TAB 1: Explain what this is about
    tabPanel("Overview",
             
    ), 
    
    # TAB 2: Choose and visualize copula
    tabPanel("Copula",
             
             sidebarPanel(
               
               # choose copula
               selectInput(inputId = "copula",
                           label = "Choose copula",
                           c(Gaussian = "gaussian", 
                             Farlie_Gumbel_Morgenstern = "fgm",
                             "t", 
                             Clayton = "clayton",
                             Frank= "frank",     
                             Gumbel = "gumbel",
                             Ali_Mikhail_Haq = "amh",
                             Joe = "joe",
                             Galambos = "galambos",
                             Hüsler_Reiß = "huslerReiss",
                             Tawn = "tawn",
                             t_Extreme_Value = "tev"
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
                            choices  = c("normal", 
                                         "exponential"), 
                            selected = "normal"),
               
               radioButtons(inputId  = "y_marginal", 
                            label    = "Select marginal for y", 
                            choices  = c("normal", 
                                         "exponential"), 
                            selected = "normal")
             ),
             
             mainPanel(
               # output: plot surface of copula
               plotlyOutput(outputId = "surface_plot")
               
             )
             
    ), 
    
    # TAB 3: Evaluate of condition is met
    tabPanel("Probability distribution", 
             
             sidebarPanel(
               
               # Input: slider for delay parameter t_d
               sliderInput(inputId = "slider_td",
                           label   = "Choose delay parameter (in ms)",
                           min = 1, max = 1000, value = 100),
               
               # Input: slider for sample size n 
               sliderInput(inputId = "slider_n",
                           label   = "Choose sample size",
                           min = 30, max = 1500, value = 500)
             ),
             
             mainPanel(
               
               # Output: plot distributions 
               plotOutput(outputId = "cdf_plot"),
               
               # Output: is condition fulfilled?
               textOutput(outputId = "condition_fulfilled")
               
             ),
             
    )
  )
)