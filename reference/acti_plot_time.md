# Plot minute-level activity over time

`acti_plot_time()` draws a time-series plot for a minute-level activity
measure, such as steps or activity counts. `acti_plot_day()` aligns the
data by time of day and places each date in its own facet row.
`acti_plot_heatmap()` provides the same date-by-time layout as a heat
map.

## Usage

``` r
acti_plot_time(data, value, time = time, breaks = NULL, ...)

acti_plot_day(data, value, time = time, breaks = "4 hours", ...)

acti_plot_heatmap(data, value, time = time, breaks = "4 hours", ...)
```

## Arguments

- data:

  A data frame containing a timestamp and an activity measure.

- value:

  The activity-measure column, supplied unquoted or as a string. For
  example, `steps` or `"counts"`.

- time:

  The timestamp column, supplied unquoted or as a string. It is `time`
  by default.

- breaks:

  A single duration such as `"1 hour"`, `"4 hours"`, or `"15 mins"`. It
  controls x-axis spacing. Use `NULL` for ggplot2's default on the
  full-time plot or no specified breaks on aligned plots.

- ...:

  Additional arguments passed to the primary geom.

## Value

A ggplot object.

## Details

Data are prepared with
[`actibase::acti_separate_times()`](https://jhuwit.github.io/actibase/reference/acti_separate_time.html),
which recognizes the timestamp conventions used by activerse packages
and adds date and time-of-day variables.

## Examples

``` r
# The first two hours of the packaged minute-level data.
activity <- acti_minute_data[seq_len(120), ]

acti_plot_time(activity, counts, breaks = "1 hour")

acti_plot_day(activity, "counts", breaks = "1 hour")

acti_plot_heatmap(activity, counts, breaks = "1 hour")

```
