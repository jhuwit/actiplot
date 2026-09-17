# Highlight activity observations beyond a threshold

Adds translucent vertical bands for timestamped observations above or
below a threshold. It intentionally does not merge observations into
bouts; use an explicit interval table with geom_episode() when episode
definitions matter.

## Usage

``` r
geom_threshold_band(
  data,
  value,
  threshold,
  direction = c("above", "below"),
  time = "time",
  ...
)
```

## Arguments

- data:

  A data frame with timestamp and numeric activity columns.

- value:

  Numeric activity column name.

- threshold:

  Numeric threshold.

- direction:

  Whether to highlight values above or below the threshold.

- time:

  Timestamp column name.

- ...:

  Arguments passed to ggplot2::geom_rect().

## Value

A ggplot2 layer.
