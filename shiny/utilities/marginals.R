#########################################################
# Defining functions to extract marginals from uniforms #
#########################################################

# Required packages
library(gamlss.dist)
library(nimble)


# Functions
extract_marginal <- function(u, marginal="normal", scale_mean=200, scale_sd=15, wei_shape=NULL) {
  # extract marginal distribution from uniform distribution
  # u: uniform distribution
  # marginal: marginal distribution
  # scale_mean: scale or mean of marginal distribution
  # wei_shape: shape parameter of weibull distribution
  # returns: vector of values for marginal distribution
  lambda <- 1/scale_mean
  u_t <- switch(marginal,
                normal = qnorm(u, mean=scale_mean, sd=scale_sd),
                exponential = qexp(u, rate=lambda),
                logNormal = qlnorm(u, meanlog=log(scale_mean)),
                exGaussian = qexGAUS(u, mu=scale_mean, sigma=scale_sd, nu=0.5*scale_mean),
                doubleExponential = qdexp(u, location=scale_mean, scale=scale_sd),
                weibull = qweibull(u, shape = 1.5, scale=scale_mean)
  )
  return(u_t)
}
