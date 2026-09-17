# Plot a minute-of-day activity profile

Plot a minute-of-day activity profile

## Usage

``` r
acti_plot_minute_profile(
  data,
  value,
  time = time,
  summary = c("mean", "median"),
  ...
)
```

## Arguments

- data:

  Minute-level activity data.

- value:

  Activity column, supplied unquoted or as a string.

- time:

  Timestamp column.

- summary:

  Either "mean" or "median".

- ...:

  Arguments passed to ggplot2::geom_tile().

## Value

A ggplot object.
