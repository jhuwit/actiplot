#' Plot minute-level activity over time
#'
#' `acti_plot_time()` draws a time-series plot for a minute-level activity
#' measure, such as steps or activity counts. `acti_plot_day()` aligns the data
#' by time of day and places each date in its own facet row.
#' `acti_plot_heatmap()` provides the same date-by-time layout as a heat map.
#'
#' Data are prepared with [actibase::acti_separate_times()], which recognizes
#' the timestamp conventions used by activerse packages and adds date and
#' time-of-day variables.
#'
#' @param data A data frame containing a timestamp and an activity measure.
#' @param value The activity-measure column, supplied unquoted or as a string.
#'   For example, `steps` or `"counts"`.
#' @param time The timestamp column, supplied unquoted or as a string. It is
#'   `time` by default.
#' @param breaks A single duration such as `"1 hour"`, `"4 hours"`, or
#'   `"15 mins"`. It controls x-axis spacing. Use `NULL` for ggplot2's
#'   default on the full-time plot or no specified breaks on aligned plots.
#' @param x_axis The x-axis labelling scheme for `acti_plot_time()`. Use
#'   `"default"` to use `breaks` or ggplot2's default; `"12 hours"` to show
#'   a date and 12-hour clock label every 12 hours; or `"midnight"` to label
#'   each date only at midnight. The latter two options set their own breaks.
#' @param facet The facet labels for `acti_plot_day()`: `"date"` for the full
#'   date, `"month-day"` for a date without the year, or `"day"` for days
#'   since the first recording day (as calculated by
#'   [actibase::acti_separate_times()]).
#' @param ... Additional arguments passed to the primary geom.
#'
#' @return A ggplot object.
#' @examples
#' # The first two hours of the packaged minute-level data.
#' activity <- acti_minute_data[seq_len(120), ]
#'
#' acti_plot_time(activity, counts, breaks = "1 hour")
#' acti_plot_time(acti_minute_data, counts, x_axis = "12 hours")
#' acti_plot_time(acti_minute_data, counts, x_axis = "midnight")
#' acti_plot_day(activity, "counts", breaks = "1 hour")
#' acti_plot_heatmap(activity, counts, breaks = "1 hour")
#'
#' @export
acti_plot_time <- function(data, value, time = time, breaks = NULL,
                           x_axis = c("default", "12 hours", "midnight"), ...) {
  value_name <- .acti_plot_column_name(rlang::enquo(value), "value")
  time_name <- .acti_plot_column_name(rlang::enquo(time), "time")
  x_axis <- match.arg(x_axis)
  prepared <- .acti_plot_prepare(data, value_name, time_name)

  plot <- ggplot2::ggplot(
    prepared,
    ggplot2::aes(x = .data[["time"]], y = .data[[value_name]])
  ) +
    ggplot2::geom_line(...) +
    ggplot2::labs(x = "Time", y = value_name)

  if (x_axis == "12 hours") {
    plot <- plot + ggplot2::scale_x_datetime(
      breaks = .acti_plot_datetime_breaks(
        "12 hours", .acti_plot_timezone(prepared[["time"]])
      ),
      date_labels = "%b %d\n%I %p"
    )
  } else if (x_axis == "midnight") {
    plot <- plot + ggplot2::scale_x_datetime(
      breaks = .acti_plot_datetime_breaks(
        "midnight", .acti_plot_timezone(prepared[["time"]])
      ),
      date_labels = "%b %d"
    )
  } else if (!is.null(breaks)) {
    .acti_plot_break_minutes(breaks)
    plot <- plot + ggplot2::scale_x_datetime(date_breaks = breaks)
  }
  plot
}

#' @rdname acti_plot_time
#' @export
acti_plot_day <- function(data, value, time = time, breaks = "4 hours",
                          facet = c("date", "month-day", "day"), ...) {
  value_name <- .acti_plot_column_name(rlang::enquo(value), "value")
  time_name <- .acti_plot_column_name(rlang::enquo(time), "time")
  facet <- match.arg(facet)
  prepared <- .acti_plot_prepare(data, value_name, time_name)
  prepared[[".acti_facet"]] <- .acti_plot_facet(prepared, facet)

  plot <- ggplot2::ggplot(
    prepared,
    ggplot2::aes(x = .data[[".acti_minutes"]], y = .data[[value_name]])
  ) +
    ggplot2::geom_line(...) +
    ggplot2::facet_grid(rows = ggplot2::vars(!!rlang::sym(".acti_facet"))) +
    ggplot2::labs(x = "Time of day", y = value_name)

  .acti_plot_add_time_of_day_scale(
    plot, breaks, range(prepared[[".acti_minutes"]], na.rm = TRUE)
  )
}

#' @rdname acti_plot_time
#' @export
acti_plot_heatmap <- function(data, value, time = time, breaks = "4 hours", ...) {
  value_name <- .acti_plot_column_name(rlang::enquo(value), "value")
  time_name <- .acti_plot_column_name(rlang::enquo(time), "time")
  prepared <- .acti_plot_prepare(data, value_name, time_name)

  plot <- ggplot2::ggplot(
    prepared,
    ggplot2::aes(
      x = .data[[".acti_minutes"]], y = .data[["date"]],
      fill = .data[[value_name]]
    )
  ) +
    ggplot2::geom_tile(...) +
    ggplot2::labs(x = "Time of day", y = "Date", fill = value_name)

  .acti_plot_add_time_of_day_scale(
    plot, breaks, range(prepared[[".acti_minutes"]], na.rm = TRUE)
  )
}

.acti_plot_prepare <- function(data, value, time) {
  if (!is.data.frame(data)) {
    stop("`data` must be a data frame.", call. = FALSE)
  }
  if (!value %in% names(data)) {
    stop("`value` must name a column in `data`.", call. = FALSE)
  }
  if (!is.numeric(data[[value]])) {
    stop("The `value` column must be numeric.", call. = FALSE)
  }
  if (!time %in% names(data)) {
    stop("`time` must name a timestamp column in `data`.", call. = FALSE)
  }
  if (!inherits(data[[time]], "POSIXt")) {
    stop("The `time` column must be POSIXct or POSIXlt.", call. = FALSE)
  }

  data[["time"]] <- data[[time]]
  prepared <- actibase::acti_separate_times(data)
  prepared[[".acti_minutes"]] <- as.numeric(prepared[["minute"]]) / 60
  prepared
}

.acti_plot_column_name <- function(column, argument) {
  expression <- rlang::get_expr(column)
  if (rlang::is_string(expression)) {
    return(expression)
  }
  if (rlang::is_symbol(expression)) {
    return(rlang::as_string(expression))
  }
  stop(sprintf("`%s` must be a column name or a single string.", argument), call. = FALSE)
}

.acti_plot_break_minutes <- function(breaks) {
  if (!is.character(breaks) || length(breaks) != 1L || is.na(breaks)) {
    stop("`breaks` must be NULL or a duration such as `\"1 hour\"`.", call. = FALSE)
  }
  match <- regexec(
    "^\\s*([0-9]+(?:\\.[0-9]+)?)\\s*(hours?|hrs?|minutes?|mins?)\\s*$",
    breaks, ignore.case = TRUE
  )
  parts <- regmatches(breaks, match)[[1L]]
  if (length(parts) == 0L) {
    stop("`breaks` must be a duration such as `\"1 hour\"` or `\"15 mins\"`.", call. = FALSE)
  }
  amount <- as.numeric(parts[2L])
  multiplier <- if (grepl("^h", parts[3L], ignore.case = TRUE)) 60 else 1
  minutes <- amount * multiplier
  if (!is.finite(minutes) || minutes <= 0 || minutes > 1440) {
    stop("`breaks` must be greater than zero and no more than 24 hours.", call. = FALSE)
  }
  minutes
}

.acti_plot_timezone <- function(time) {
  timezone <- attr(time, "tzone")
  if (is.null(timezone) || !nzchar(timezone[1L])) {
    return("UTC")
  }
  timezone[1L]
}

.acti_plot_datetime_breaks <- function(interval, timezone) {
  function(limits) {
    limits <- as.POSIXct(limits, origin = "1970-01-01", tz = timezone)
    dates <- seq(
      as.Date(limits[1L], tz = timezone) - 1,
      as.Date(limits[2L], tz = timezone) + 1,
      by = "day"
    )
    midnight <- as.POSIXct(dates, tz = timezone)
    breaks <- if (identical(interval, "12 hours")) {
      sort(c(midnight, midnight + 12 * 60 * 60))
    } else {
      midnight
    }
    breaks[breaks >= limits[1L] & breaks <= limits[2L]]
  }
}

.acti_plot_facet <- function(data, facet) {
  if (identical(facet, "date")) {
    return(data[["date"]])
  }
  if (identical(facet, "month-day")) {
    labels <- format(data[["date"]], "%b %d")
    return(factor(labels, levels = unique(labels[order(data[["date"]])])))
  }
  day <- data[["day"]]
  labels <- paste("Day", day)
  factor(labels, levels = paste("Day", sort(unique(day))))
}

.acti_plot_add_time_of_day_scale <- function(plot, breaks, limits) {
  if (is.null(breaks)) {
    return(
      plot +
        ggplot2::scale_x_continuous() +
        ggplot2::coord_cartesian(xlim = limits)
    )
  }
  interval <- .acti_plot_break_minutes(breaks)
  first_break <- floor(limits[1L] / interval) * interval
  last_break <- ceiling(limits[2L] / interval) * interval
  positions <- seq(first_break, last_break, by = interval)
  plot + ggplot2::scale_x_continuous(
    breaks = positions,
    labels = .acti_plot_time_labels(positions),
    expand = ggplot2::expansion(mult = 0)
  ) +
    ggplot2::coord_cartesian(xlim = limits)
}

.acti_plot_time_labels <- function(minutes) {
  hours <- floor(minutes / 60)
  mins <- round(minutes %% 60)
  sprintf("%02d:%02d", hours, mins)
}
