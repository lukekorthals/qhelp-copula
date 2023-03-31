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
    add_surface(colorbar = list(title="Counts")) %>%
    layout(scene = list(xaxis = list(title = "Tgo"),
                        yaxis = list(title = "Tstop"),
                        zaxis = list(title = "Count")),
           title = "Multivariate Distributions"
    )
  return(fig)
}


plot_cdf <- function(u, v) {
    # generates ggplot of cumulative distribution functions
    # u: vector of values for variable 1
    # v: vector of values for variable 2
    # returns: ggplot
    u_ <- u[u < v] # go < stop
    if (length(u_) < 10 ){
      stop("There are not enough Tgo values that are smaller than Tstop. Make sure Tstop mean is not way lower than Tgo mean.")
    }
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
        y = "Cumulative Density",
        col = c("Distribution"),
        title = "Cumulative Probabilities"
      ) + 
      theme(
        legend.position = "top"
      ) +
      scale_color_discrete(labels = c("Tgo", "Tgo < Tstop + delay"))
    return(fig)
}


plot_marginals <- function(u, v) {
  # generates plotly of the mraginal distributions
  # u: vector of values for variable 1
  # v: vector of values for variable 2
  # returns: plotly combined plot
  dat <- data.frame(u, v)
  
  # Histogram of Tgo
  hist_top <- ggplot(dat) + 
    geom_histogram(aes(u)) +
    theme(axis.title.y=element_blank(),axis.text.y=element_blank(),axis.ticks.y=element_blank())
  hist_top <- ggplotly(p = hist_top)
  
  # Combined Scatter
  scatter <- ggplot(dat, aes(x=u, y=v)) +
    geom_point() +
    geom_smooth() +
    labs(
      x = "Tgo",
      y = "Tstop + delay"
    )
  scatter <- ggplotly(p = scatter, type = 'scatter')
  
  # Histogram of Tstop
  hist_right <- ggplot(dat) + 
    geom_histogram(aes(v)) +
    coord_flip() +
    theme(axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank())
  hist_right <- ggplotly(p = hist_right)
  
  # Combined plot
  s <- subplot(
    hist_top, 
    plotly_empty(), 
    scatter,
    hist_right,
    nrows = 2, heights = c(0.2, 0.8), widths = c(0.8, 0.2), margin = 0,
    shareX = TRUE, shareY = TRUE, titleX = TRUE, titleY = TRUE
  )
  return(layout(s, showlegend = FALSE, title="Marginal Distributions"))
}
