
<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- badges: start -->

[![R-CMD-check](https://github.com/jhuwit/actiquantiles/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/jhuwit/actiquantiles/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/jhuwit/actiquantiles/branch/main/graph/badge.svg)](https://app.codecov.io/gh/jhuwit/actiquantiles?branch=main)
<!-- badges: end -->

# actiquantiles

`actiquantiles` maps physical activity values to NHANES-based quantiles.
The package exposes an `acti_`-prefixed wrapper around
`mapnhanespa::map_nhanes_pa_quantiles()` so the public API can stay
stable while new mapping backends are added later.

Core entry points:

- `acti_map_nhanes()` for participant-level quantile mapping
- `mapnhanespa::nhanes_pa_quantile()` for a single value lookup
- `mapnhanespa::nhanes_pa_age_category()` for age binning

## Installation

You can install `actiquantiles` from GitHub with:

``` r
# install.packages("remotes")
remotes::install_github("jhuwit/actiquantiles")
```

The package depends on `mapnhanespa`, which provides the NHANES mapping
tables and lookup logic.

## Quick Start

``` r
example_data <- data.frame(
  id = c("A", "B"),
  age = c(25, 62),
  sex = c("Female", "Male"),
  measure = c("mims", "ssl_steps"),
  value = c(15000, 7500)
)

mapped <- acti_map_nhanes(example_data)
mapped
#>   id age    sex   measure value acti_pa_quantile
#> 1  A  25 Female      mims 15000        0.5349443
#> 2  B  62   Male ssl_steps  7500        0.3527381
```

The wrapper keeps the input columns and adds `acti_pa_quantile`:

``` r
head(mapped)
#>   id age    sex   measure value acti_pa_quantile
#> 1  A  25 Female      mims 15000        0.5349443
#> 2  B  62   Male ssl_steps  7500        0.3527381
```

For a single value, use the scalar helper from `mapnhanespa` directly:

``` r
mapnhanespa::nhanes_pa_quantile(
  value = 15000,
  age = 25,
  sex = "Female",
  measure = "mims"
)
#> [1] 0.5349443
```
