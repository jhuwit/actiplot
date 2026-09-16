# Plotting Minute-Level Activity Data

``` r

library(actiplot)
```

This vignette uses the packaged `acti_minute_data` accelerometer
recording. It contains seven days of minute-level vector-magnitude
activity counts.

``` r

activity <- acti_minute_data
```

## Complete recording

Use
[`acti_plot_time()`](https://jhuwit.github.io/actiplot/reference/acti_plot_time.md)
to inspect activity across the entire recording. The `breaks` argument
accepts ordinary duration strings and sets the interval of the time-axis
labels.

``` r

acti_plot_time(activity, counts, breaks = "4 hours")
```

![](plot-minute-activity_files/figure-html/full-time-1.png)

## Daily aligned rows

Use
[`acti_plot_day()`](https://jhuwit.github.io/actiplot/reference/acti_plot_time.md)
to align each day on the same time-of-day axis. Each facet row is one
calendar date, which makes day-to-day activity patterns easy to compare.

``` r

acti_plot_day(activity, counts, breaks = "4 hours")
```

![](plot-minute-activity_files/figure-html/daily-1.png)

## Date-by-time heat map

[`acti_plot_heatmap()`](https://jhuwit.github.io/actiplot/reference/acti_plot_time.md)
uses the same alignment with counts represented by fill.

``` r

acti_plot_heatmap(activity, counts, breaks = "4 hours")
```

![](plot-minute-activity_files/figure-html/heatmap-1.png)
