##########################################################
# Defining functions to generate plots for the shiny app #
##########################################################

# Required packages
library(plotly)
library(dplyr)
library(ggplot2)


# Plot functions
plot_copula_surface <- function(samples){
    # generates plotly plot of the copula surface
    # samples: matrix of samples
    # returns: plotly plot
    fit <- kdecop(samples)
    fig <- plot_ly(x = fit$grid, y = fit$grid, z = fit$estimate) %>%
        add_surface()
    return(fig)
}

plot_cdf <- function(Tgo, Tstop) {
    # generates ggplot of cumulative distribution functions
    # Tgo: vector of values for variable 1
    # Tstop: vector of values for variable 2
    # returns: ggplot
    Tgo_star <- data.frame(Tgo=Tgo, Tstop=Tstop) %>%
        mutate(go_stop_dif = Tgo-Tstop) %>%
        filter(go_stop_dif <= 0) %>%
        dplyr::select(Tgo) %>%
      unlist()
    fig <- ggplot(data.frame(Tgo=Tgo), aes(Tgo)) +
      stat_ecdf(geom="smooth") +
      stat_ecdf(data=data.frame(Tgo_star=Tgo_star), aes(Tgo_star), col="red") +
      theme_classic()
    return(fig)
}

#### USE THIS TO PLOT NICE STUFF
plot_surface <- function(u,v){
  u_c <- cut(u, 20)
  v_c <- cut(v, 20)
  z <- table(u_c, v_c)
  fig <- plot_ly(z = ~z) %>%
    add_surface()
  return(fig)
}

