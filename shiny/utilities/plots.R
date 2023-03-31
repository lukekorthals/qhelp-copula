##########################################################
# Defining functions to generate plots for the shiny app #
##########################################################

# Required packages
library(plotly)
library(dplyr)
library(ggplot2)


# Plot functions
plot_surface <- function(u, v){
  u_c <- cut(u, 20)
  v_c <- cut(v, 20)
  z <- table(u_c, v_c)
  fig <- plot_ly(z = ~z) %>%
    add_surface()
  return(fig)
}


plot_cdf <- function(u, v) {
    # generates ggplot of cumulative distribution functions
    # Tgo: vector of values for variable 1
    # Tstop: vector of values for variable 2
    # returns: ggplot
    u_ <- u-v
    u_ <- u_[u_ < 0] # go < stop
    dat <- data.frame(
      u = sample(u, 10000, replace=TRUE),
      u_ = sample(u_, 10000, replace=TRUE)
      )
    fig <- ggplot(dat) +
      stat_ecdf(aes(u), geom="smooth", col="black") +
      stat_ecdf(aes(u_), geom="smooth", col="red") +
      theme_classic()
    return(fig)
} 

