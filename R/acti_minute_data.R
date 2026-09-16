#' Minute-level accelerometer counts
#'
#' A seven-day example of minute-level accelerometer data. It contains a
#' timestamp, counts for each accelerometer axis, vector-magnitude counts,
#' log-transformed counts, and a wear indicator. The data are suitable for the
#' examples in [acti_plot_time()], [acti_plot_day()], and
#' [acti_plot_heatmap()].
#'
#' The original study recorded seven days of wrist-worn ActiGraph activity from
#' 20 myoelectric prosthesis users and 20 anatomically intact adults. This
#' package data object is a processed minute-level recording drawn from that
#' collection.
#'
#' @format A tibble with 10,080 rows and 7 variables:
#' \describe{
#'   \item{time}{Timestamp of the minute, as POSIXct.}
#'   \item{axis1, axis2, axis3}{Axis-specific activity counts.}
#'   \item{counts}{Vector-magnitude activity counts.}
#'   \item{counts_log10}{Log10-transformed vector-magnitude counts.}
#'   \item{wear}{Whether the minute was classified as wear time.}
#' }
#' @source The
#'   Figshare collection at <doi:10.6084/m9.figshare.c.4457855>.
#' @references Chadwell, A., Kenney, L., Granat, M., Thies, S., Galpin, A., &
#'   Head, J. (2019). Upper limb activity of twenty myoelectric prosthesis users
#'   and twenty healthy anatomically intact adults. *Scientific Data*, 6, 199.
#'   <doi:10.1038/s41597-019-0211-6>
"acti_minute_data"
