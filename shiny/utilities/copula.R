###############################################################
# Defining functions to generate copula from input parameters #
# and to generate random samples from the copula              #
###############################################################

# Required Packages
library(copula)


# Helper functions
compile_copula_list <- function(copula, n=10000) {
    # compile copula and samples into a list
    # copula: copula object
    # n: number of samples to generate
    samples <- rCopula(n, copula)
    copula_list <- list(
        copula=copula, 
        samples=samples 
        )
    return(copula_list)
}


# Copula functions
generate_copula_from_cor <- function(cor_xy, copula="gaussian") {
    # generates copula object from correlation
    # cor_xy: correlation between x and y
    # copula: copula type
    # returns: list of copula object and samples

    # validate input
    valid_copula <- c("gaussian", "fgm")
    if (cor_xy < -1 | cor_xy > 1) {
        stop("cor_xy must be between -1 and 1")
    } else if (!(copula %in% valid_copula)) {
        stop("copula must be gaussian, or fgm")
    }
    # generate copula
    copula_ <- switch(copula,
        gaussian = normalCopula(param=cor_xy, dim=2),
        fgm = fgmCopula(param=cor_xy, dim=2)
    )
    copula_list <- compile_copula_list(copula_)
    return(copula_list)
}


generate_copula_from_cor_df <- function(cor_xy, df, copula="t") {
    # generates copula object from correlation and degrees of freedom
    # cor_xy: correlation between x and y
    # df: degrees of freedom
    # copula: copula type
    # returns: list of copula object and samples

    # validate input
    valid_copula <- c("t")
    if (cor_xy < -1 | cor_xy > 1) {
        stop("cor_xy must be between -1 and 1")
    } else if (!(copula %in% valid_copula)) {
        stop("copula must be t")
    } else if (df <= 0) {
        stop("df must be greater than 0")
    }
    # generate copula
    copula_ <- switch(copula,
        t = tCopula(param=cor_xy, dim=2, df=df)
    )
    copula_list <- compile_copula_list(copula_)
    return(copula_list)
}


generate_copula_from_theta <- function(theta, copula="clayton") {
    # generates copula object from theta
    # theta: copula parameter
    # copula: copula type
    # returns: list of copula object and samples

    # validate input
    valid_copula <- c("clayton", "frank", "gumbel", "amh", "joe", "galambos", "huslerReiss", "tawn", "tev")
    if (!(copula %in% valid_copula)) {
        stop(paste0("copula must be one of ", paste(valid_copula, collapse=", ")))
    } else if (copula == "clayton" & theta < -1) {
        stop("theta must be greater than -1 for clayton copula")
    } else if (copula == "gumbel" & theta < 1) {
        stop("theta must be greater than 1 for gumbel copula")
    } else if(copula == "frank" & (theta < -700 | theta > 700)) {
        stop("theta must be greater between -700 and 700 for frank copula")
    } else if (copula == "amh" & (theta < -1 | theta >= 1)) {
        stop("theta must be greater or equal to -1 and smaller than 1 for amh copula")
    } else if (copula == "joe" & theta < 1) {
        stop("theta must be greater than 1 for joe copula")
    } else if (copula == "galambos" & theta < 0) {
        stop("theta must be greater than 0 for galambos copula")
    } else if (copula == "huslerReiss" & theta < 0) {
        stop("theta must be greater than 0 for huslerReiss copula")
    } else if(copula == "tawn" & (theta < 0 | theta > 1)) {
        stop("theta must be greater than 0 and smaller than 1 for tawn copula")
    } else if (copula == "tev" & (theta < -1 | theta > 1)) {
        stop("theta must be greater or equal to -1 and smaller than 1 for tev copula")
    }
    # generate copula
    copula_ <- switch(copula,
        clayton = claytonCopula(param=theta, dim=2),
        frank = frankCopula(param=theta, dim=2),
        gumbel = gumbelCopula(param=theta, dim=2),
        amh = amhCopula(param=theta, dim=2),
        joe = joeCopula(param=theta, dim=2),
        galambos = galambosCopula(param=theta),
        huslerReiss = huslerReissCopula(param=theta),
        tawn = tawnCopula(param=theta),
        tev = tevCopula(param=theta)
    )
    copula_list <- compile_copula_list(copula_)
    return(copula_list)
}
