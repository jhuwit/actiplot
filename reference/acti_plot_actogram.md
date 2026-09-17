# Plot an activity actogram

Displays minute-level activity as a date-by-time heat map using actibase
day indexing and time-of-day conversion.

## Usage

``` r
acti_plot_actogram(data, value, time = time, breaks = "4 hours", ...)
```

## Arguments

- data:

  Minute-level activity data.

- value:

  Activity column, supplied unquoted or as a string.

- time:

  Timestamp column.

- breaks:

  Time-of-day axis break interval.

- ...:

  Arguments passed to ggplot2::geom_tile().

## Value

A ggplot object.
