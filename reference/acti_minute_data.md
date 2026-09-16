# Minute-level accelerometer counts

A seven-day example of minute-level accelerometer data. It contains a
timestamp, counts for each accelerometer axis, vector-magnitude counts,
log-transformed counts, and a wear indicator. The data are suitable for
the examples in
[`acti_plot_time()`](https://jhuwit.github.io/actiplot/reference/acti_plot_time.md),
[`acti_plot_day()`](https://jhuwit.github.io/actiplot/reference/acti_plot_time.md),
and
[`acti_plot_heatmap()`](https://jhuwit.github.io/actiplot/reference/acti_plot_time.md).

## Usage

``` r
acti_minute_data
```

## Format

A tibble with 10,080 rows and 7 variables:

- time:

  Timestamp of the minute, as POSIXct.

- axis1, axis2, axis3:

  Axis-specific activity counts.

- counts:

  Vector-magnitude activity counts.

- counts_log10:

  Log10-transformed vector-magnitude counts.

- wear:

  Whether the minute was classified as wear time.

## Source

ActiGraph GT3X accelerometer recording processed with `actimetrics`.
