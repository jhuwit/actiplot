# Add timestamped episode intervals

Draws one or more timestamped intervals behind an activity trace. The
input data must contain POSIXct start and end columns. This is the
common layer underpinning sleep, wear, and activity-bout annotations.

## Usage

``` r
geom_episode(data, start = "start", end = "end", ...)
```

## Arguments

- data:

  An interval data frame.

- start, end:

  Names of POSIXct start and end columns.

- ...:

  Arguments passed to ggplot2::geom_rect().

## Value

A ggplot2 layer.
