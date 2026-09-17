#' Plot an activity actogram
#'
#' Displays minute-level activity as a date-by-time heat map using actibase day
#' indexing and time-of-day conversion.
#'
#' @param data Minute-level activity data.
#' @param value Activity column, supplied unquoted or as a string.
#' @param time Timestamp column.
#' @param breaks Time-of-day axis break interval.
#' @param ... Arguments passed to ggplot2::geom_tile().
#' @return A ggplot object.
#' @export
acti_plot_actogram <- function(data, value, time = time, breaks = "4 hours", ...) {
  .acti_plot_check_value(value)
  value_name <- .acti_plot_column_name(rlang::enquo(value), "value")
  time_name <- .acti_plot_column_name(rlang::enquo(time), "time")
  prepared <- .acti_plot_prepare(data, value_name, time_name)
  prepared[[".acti_day"]] <- actibase::acti_day_index(prepared[["time"]])
  plot <- ggplot2::ggplot(prepared, ggplot2::aes(
    x = .data[[".acti_minutes"]], y = .data[[".acti_day"]],
    fill = .data[[value_name]]
  )) + ggplot2::geom_tile(...) + ggplot2::scale_y_reverse() +
    ggplot2::labs(x = "Time of day", y = "Day", fill = value_name)
  .acti_plot_add_time_of_day_scale(
    plot, breaks, range(prepared[[".acti_minutes"]], na.rm = TRUE)
  )
}

#' Plot a minute-of-day activity profile
#'
#' @inheritParams acti_plot_actogram
#' @param summary Either "mean" or "median".
#' @return A ggplot object.
#' @export
acti_plot_minute_profile <- function(data, value, time = time,
                                     summary = c("mean", "median"), ...) {
  .acti_plot_check_value(value)
  value_name <- .acti_plot_column_name(rlang::enquo(value), "value")
  time_name <- .acti_plot_column_name(rlang::enquo(time), "time")
  summary <- match.arg(summary)
  prepared <- .acti_plot_prepare(data, value_name, time_name)
  fun <- if (summary == "mean") mean else stats::median
  profile <- stats::aggregate(prepared[[value_name]],
    list(minute = prepared[[".acti_minutes"]]), function(x) fun(x, na.rm = TRUE))
  names(profile)[2L] <- "value"
  ggplot2::ggplot(profile, ggplot2::aes(x = .data[["minute"]], y = .data[["value"]])) +
    ggplot2::geom_line(...) +
    ggplot2::labs(x = "Time of day", y = paste(summary, value_name))
}

#' Add activity marks along a datetime axis
#' @param data Data containing a timestamp column.
#' @param time Timestamp column name.
#' @param ... Arguments passed to ggplot2::geom_rug().
#' @return A ggplot2 layer.
#' @export
geom_activity_rug <- function(data, time = "time", ...) {
  if (!is.data.frame(data) || !time %in% names(data) ||
      !inherits(data[[time]], "POSIXt")) {
    stop("'data' must contain a POSIXct timestamp column.", call. = FALSE)
  }
  ggplot2::geom_rug(data = data,
    mapping = ggplot2::aes(x = .data[[time]]), inherit.aes = FALSE, ...)
}
