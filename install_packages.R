# Install devtools if not already installed
if (!requireNamespace("devtools", quietly = TRUE)) {
  install.packages("devtools")
}

# Install worldfootballR from GitHub
devtools::install_github("JaseZiv/worldfootballR")

# Install other R packages
install.packages(c(
  "dplyr",
  "purrr",
  "readr"
))

# Load the libraries
library(worldfootballR)
library(dplyr)
library(purrr)  # For rate_backoff function
library(readr)  # For write_csv function
