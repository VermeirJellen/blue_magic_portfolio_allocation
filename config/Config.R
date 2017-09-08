############################################################################
### Load necessary packages and functions into memory                  #####
############################################################################
# if(!require(installr)) {install.packages("installr"); require(installr)}
# updateR()
packages <- c("zoo", "xts", "httr", "XML", "stringr")
packages <- lapply(packages, FUN = function(x) {
  if (!require(x, character.only = TRUE)) {
    install.packages(x)
    library(x, character.only = TRUE)
  }
})

source("functions/BlueMagicPortfolio.R")
Sys.setenv(TZ='UTC')