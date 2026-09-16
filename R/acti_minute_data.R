#' Minute-level accelerometer counts
#'
#' A seven-day example of minute-level accelerometer data. It contains a
#' timestamp, counts for each accelerometer axis, vector-magnitude counts,
#' log-transformed counts, and a wear indicator. The data are suitable for the
#' examples in [acti_plot_time()], [acti_plot_day()], and
#' [acti_plot_heatmap()].
#'
#' @format A tibble with 10,080 rows and 7 variables:
#' \describe{
#'   \item{time}{Timestamp of the minute, as POSIXct.}
#'   \item{axis1, axis2, axis3}{Axis-specific activity counts.}
#'   \item{counts}{Vector-magnitude activity counts.}
#'   \item{counts_log10}{Log10-transformed vector-magnitude counts.}
#'   \item{wear}{Whether the minute was classified as wear time.}
#' }
#' @source ActiGraph GT3X accelerometer recording processed with `actimetrics`.
"acti_minute_data"
