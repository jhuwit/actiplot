#' Add timestamped episode intervals
#'
#' Draws one or more timestamped intervals behind an activity trace. The input
#' data must contain POSIXct start and end columns. This is the common layer
#' underpinning sleep, wear, and activity-bout annotations.
#'
#' @param data An interval data frame.
#' @param start,end Names of POSIXct start and end columns.
#' @param ... Arguments passed to ggplot2::geom_rect().
#' @return A ggplot2 layer.
#' @export
geom_episode <- function(data, start = "start", end = "end", ...) {
  if (!is.data.frame(data) || !all(c(start, end) %in% names(data))) {
    stop("'data' must contain the requested 'start' and 'end' columns.", call. = FALSE)
  }
  if (!inherits(data[[start]], "POSIXt") || !inherits(data[[end]], "POSIXt")) {
    stop("'start' and 'end' must be POSIXct columns.", call. = FALSE)
  }
  if (any(data[[end]] < data[[start]], na.rm = TRUE)) {
    stop("Each episode end must be on or after its start.", call. = FALSE)
  }
  layer_data <- data.frame(
    xmin = data[[start]], xmax = data[[end]],
    ymin = -Inf, ymax = Inf
  )
  ggplot2::geom_rect(
    data = layer_data,
    mapping = ggplot2::aes(
      xmin = .data[["xmin"]], xmax = .data[["xmax"]],
      ymin = .data[["ymin"]], ymax = .data[["ymax"]]
    ),
    inherit.aes = FALSE, ...
  )
}

#' Add sleep-window intervals
#' @inheritParams geom_episode
#' @export
geom_sleep_window <- function(data, start = "start", end = "end", ...) {
  geom_episode(data, start = start, end = end, fill = "navy", alpha = 0.12, ...)
}

#' Add wear intervals
#' @inheritParams geom_episode
#' @export
geom_wear <- function(data, start = "start", end = "end", ...) {
  geom_episode(data, start = start, end = end, fill = "forestgreen", alpha = 0.10, ...)
}

#' Add conventional daily boundaries
#' @param boundary One of midnight or noon.
#' @param ... Arguments passed to geom_time_vline().
#' @return A ggplot2 layer.
#' @export
geom_day_boundary <- function(boundary = c("midnight", "noon"), ...) {
  boundary <- match.arg(boundary)
  geom_time_vline(if (boundary == "midnight") "00:00:00" else "12:00:00", ...)
}
