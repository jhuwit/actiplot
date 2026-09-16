
<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- badges: start -->

[![R-CMD-check](https://github.com/jhuwit/actiplot/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/jhuwit/actiplot/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/jhuwit/actiplot/branch/main/graph/badge.svg)](https://app.codecov.io/gh/jhuwit/actiplot?branch=main)
<!-- badges: end -->

# actiplot

`actiplot` provides `ggplot2` visualizations for minute-level activity
data, including steps and activity counts. It works with the
standardized timestamp conventions used throughout the activerse.

Core entry points:

- `acti_plot_time()` for a complete activity time series
- `acti_plot_day()` for time-of-day-aligned daily rows
- `acti_plot_heatmap()` for a date-by-time activity heat map

## Installation

You can install `actiplot` from GitHub with:

``` r
# install.packages("remotes")
remotes::install_github("jhuwit/actiplot")
```

## Quick start

``` r
activity <- data.frame(
  time = as.POSIXct("2024-01-01", tz = "UTC") + 60 * 0:1439,
  steps = rpois(1440, lambda = 2)
)

acti_plot_time(activity, steps, breaks = "4 hours")
```

![](man/figures/README-example-1.png)<!-- -->

``` r
acti_plot_day(activity, steps, breaks = "4 hours")
```

![](man/figures/README-example-2.png)<!-- -->
