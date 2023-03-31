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
    u_ <- data.frame(u, v) %>%
        mutate(go_stop_dif = u-v) %>%
        filter(go_stop_dif <= 0) %>%
        dplyr::select(u) %>%
      unlist()
    fig <- ggplot(data.frame(u), aes(u_)) +
      stat_ecdf(geom="smooth") +
      stat_ecdf(data=data.frame(U_), aes(u_), col="red") +
      theme_classic()
    return(fig)
}

