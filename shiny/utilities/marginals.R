###############################################################
# Defining functions to generate copula from input parameters #
# and to generate random samples from the copula              #
###############################################################

# required packages
# install.packages("gamlss.dist")
# install.packages("nimble")
library(gamlss.dist)
library(nimble)

extract_marginal <- function(u, marginal="normal", wei_shape = NULL) { # Add mean reaction time as parameter and use it to rescale the distributions
  u_t <- switch(marginal,
                normal = qnorm(u),
                exponential = qexp(u),
                uniform = qunif(u),
                logNormal = qlnorm(u),
                exGaussian = qexGAUS(u),
                doubleExponential = qdexp(u),
                weibull = qweibull(u, shape = wei_shape)
  )
  return(u_t)
}
