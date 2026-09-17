# Plotting Minute-Level Activity Data

``` r

library(actiplot)
```

This vignette uses the packaged `acti_minute_data` accelerometer
recording. It contains seven days of minute-level vector-magnitude
activity counts. It is processed from the [upper-limb activity Figshare
collection](https://springernature.figshare.com/collections/Upper_limb_activity_of_twenty_myoelectric_prosthesis_users_and_twenty_healthy_anatomically_intact_adults_/4457855)
described by [Chadwell et
al. (2019)](https://doi.org/10.1038/s41597-019-0211-6).

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

For a more legible complete-recording axis, set `x_axis = "12 hours"`.
It shows date and 12-hour-clock labels at midnight and noon.
Alternatively, `x_axis = "midnight"` prints just the date at midnight,
without `00:00:00`.

``` r

acti_plot_time(activity, counts, x_axis = "12 hours")
```

![](plot-minute-activity_files/figure-html/full-time-readable-axis-1.png)

``` r

acti_plot_time(activity, counts, x_axis = "midnight")
```

![](plot-minute-activity_files/figure-html/full-time-readable-axis-2.png)

## Daily aligned rows

Use
[`acti_plot_day()`](https://jhuwit.github.io/actiplot/reference/acti_plot_time.md)
to align each day on the same time-of-day axis. Each facet row is one
calendar date, which makes day-to-day activity patterns easy to compare.

``` r

acti_plot_day(activity, counts, breaks = "4 hours")
```

![](plot-minute-activity_files/figure-html/daily-1.png)

Set `facet = "month-day"` to remove the year from date strips, or
`facet = "day"` to use the baseline-relative day calculated by
[`actibase::acti_separate_times()`](https://jhuwit.github.io/actibase/reference/acti_separate_time.html).

``` r

acti_plot_day(activity, counts, facet = "month-day")
```

![](plot-minute-activity_files/figure-html/daily-facet-labels-1.png)

``` r

acti_plot_day(activity, counts, facet = "day")
```

![](plot-minute-activity_files/figure-html/daily-facet-labels-2.png)

## Date-by-time heat map

[`acti_plot_heatmap()`](https://jhuwit.github.io/actiplot/reference/acti_plot_time.md)
uses the same alignment with counts represented by fill.

``` r

acti_plot_heatmap(activity, counts, breaks = "4 hours")
```

![](plot-minute-activity_files/figure-html/heatmap-1.png)

## Actogram and daily profile

``` r

acti_plot_actogram(activity, counts, breaks = "4 hours")
```

![](plot-minute-activity_files/figure-html/actogram-1.png)

``` r

acti_plot_minute_profile(activity, counts, summary = "median")
```

![](plot-minute-activity_files/figure-html/minute-profile-1.png)

## Interval annotations

Episode layers use an explicit interval table with POSIXct start and end
columns. The example creates deterministic nightly windows for
illustration.

``` r

sleep_windows <- data.frame(
  start = as.POSIXct(c("2017-06-03 22:00:00", "2017-06-04 22:00:00"), tz = "GMT"),
  end = as.POSIXct(c("2017-06-04 07:00:00", "2017-06-05 07:00:00"), tz = "GMT")
)

acti_plot_time(activity, counts) +
  geom_sleep_window(sleep_windows) +
  geom_day_boundary("noon", linetype = "dashed")
```

![](plot-minute-activity_files/figure-html/intervals-1.png)

The same interval schema supports generic episodes and wear annotations.

``` r

acti_plot_time(activity, counts) +
  geom_episode(sleep_windows, fill = "grey30", alpha = 0.10) +
  geom_wear(sleep_windows)
```

![](plot-minute-activity_files/figure-html/episode-and-wear-1.png)

Additional lightweight annotations can mark selected activity and
intensity.

``` r

acti_plot_time(activity, counts) +
  geom_activity_rug(activity[activity$counts > 10000, ]) +
  geom_threshold_band(activity, "counts", threshold = 10000) +
  geom_time_vline(xintercept = "12:00:00", linetype = "dotted")
```

![](plot-minute-activity_files/figure-html/rug-threshold-vline-1.png)
