#' Highlight activity observations beyond a threshold
#'
#' Adds translucent vertical bands for timestamped observations above or below a
#' threshold. It intentionally does not merge observations into bouts; use an
#' explicit interval table with geom_episode() when episode definitions matter.
#'
#' @param data A data frame with timestamp and numeric activity columns.
#' @param value Numeric activity column name.
#' @param threshold Numeric threshold.
#' @param direction Whether to highlight values above or below the threshold.
#' @param time Timestamp column name.
#' @param ... Arguments passed to ggplot2::geom_rect().
#' @return A ggplot2 layer.
#' @export
geom_threshold_band <- function(data, value, threshold,
                                direction = c("above", "below"),
                                time = "time", ...) {
  direction <- match.arg(direction)
  if (!is.data.frame(data) || !all(c(time, value) %in% names(data)) ||
      !inherits(data[[time]], "POSIXt") || !is.numeric(data[[value]]) ||
      !is.numeric(threshold) || length(threshold) != 1L || is.na(threshold)) {
    stop("'data' must contain POSIXct time and numeric value columns, with one numeric threshold.", call. = FALSE)
  }
  keep <- if (direction == "above") data[[value]] >= threshold else data[[value]] <= threshold
  selected <- data[keep & !is.na(keep), , drop = FALSE]
  ggplot2::geom_rect(
    data = data.frame(
      xmin = selected[[time]], xmax = selected[[time]] + 60,
      ymin = -Inf, ymax = Inf
    ),
    mapping = ggplot2::aes(
      xmin = .data[["xmin"]], xmax = .data[["xmax"]],
      ymin = .data[["ymin"]], ymax = .data[["ymax"]]
    ),
    inherit.aes = FALSE, alpha = 0.12, ...
  )
}
