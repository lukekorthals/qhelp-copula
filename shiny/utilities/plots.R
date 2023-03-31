##########################################################
# Defining functions to generate plots for the shiny app #
##########################################################

# Required packages
library(plotly)
library(dplyr)
library(tidyr)
library(ggplot2)


# Plot functions
plot_surface <- function(u, v) {
  # generates plotly surface plot
  # u: vector of values for variable 1
  # v: vector of values for variable 2
  # returns: plotly surface plot
  u_c <- cut(u, 20)
  v_c <- cut(v, 20)
  z <- table(u_c, v_c)
  fig <- plot_ly(z = ~z) %>%
    add_surface()
  return(fig)
}


plot_cdf <- function(u, v) {
    # generates ggplot of cumulative distribution functions
    # u: vector of values for variable 1
    # v: vector of values for variable 2
    # returns: ggplot
    u_ <- u[u < v] # go < stop
    dat <- data.frame(
      u = sample(u, 10000, replace=TRUE),
      u_ = sample(u_, 10000, replace=TRUE)
      )
    fig <-  data.frame(u = sample(u, 10000, replace=TRUE),
                       u_ = sample(u_, 10000, replace=TRUE)) %>%
      pivot_longer(cols = c(u, u_), 
                   names_to = "distribution", 
                   values_to = "value") %>%
      ggplot(aes(x = value, col = distribution)) +
      stat_ecdf() + 
      theme_classic() +
      labs(
        x = "Processing time (ms)",
        y = "Cumulative Density"
      ) + 
      theme(
        legend.position = "top"
      )
    return(fig)
}
