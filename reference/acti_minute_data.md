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

The [Figshare
collection](https://springernature.figshare.com/collections/Upper_limb_activity_of_twenty_myoelectric_prosthesis_users_and_twenty_healthy_anatomically_intact_adults_/4457855).

## Details

The original study recorded seven days of wrist-worn ActiGraph activity
from 20 myoelectric prosthesis users and 20 anatomically intact adults.
This package data object is a processed minute-level recording drawn
from that collection.

## References

Chadwell, A., Kenney, L., Granat, M., Thies, S., Galpin, A., & Head, J.
(2019). Upper limb activity of twenty myoelectric prosthesis users and
twenty healthy anatomically intact adults. *Scientific Data*, 6, 199.
<https://doi.org/10.1038/s41597-019-0211-6>
