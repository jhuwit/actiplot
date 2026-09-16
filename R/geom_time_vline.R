#' Add a time-aware vertical reference line
#'
#' A convenience layer for ggplot2::geom_vline() that converts time inputs to
#' actiplot time scales. A time of day such as "12:00" is drawn in every daily
#' facet. A complete date-time is drawn at that instant on a full-time plot and
#' only on its matching date facet in an aligned day plot.
#'
#' @param xintercept A POSIXct date-time, an ISO-like date-time character string, or
#'   a time-of-day character string such as "08:30".
#' @param timezone Time zone used to parse date-time character values. The
#'   timestamp time zone in the plot data is used when NULL.
#' @param check_timezone If TRUE, date-time character values require an explicit
#'   timezone.
#' @param ... Arguments passed to ggplot2::geom_vline().
#'
#' @return A ggplot2 layer.
#' @examples
#' acti_plot_day(acti_minute_data, counts) +
#'   geom_time_vline("12:00", linetype = "dashed")
#'
#' acti_plot_time(acti_minute_data, counts) +
#'   geom_time_vline("2017-06-05 09:30:00", timezone = "GMT")
#'
#' @export
geom_time_vline <- function(xintercept, timezone = NULL, check_timezone = FALSE, ...) {
  if (missing(xintercept)) {
    stop("'xintercept' is required.", call. = FALSE)
  }
  if (!is.null(timezone) && (!is.character(timezone) || length(timezone) != 1L)) {
    stop("'timezone' must be NULL or a single time-zone name.", call. = FALSE)
  }
  if (!is.logical(check_timezone) || length(check_timezone) != 1L ||
      is.na(check_timezone)) {
    stop("'check_timezone' must be TRUE or FALSE.", call. = FALSE)
  }
  if (check_timezone && is.null(timezone) && is.character(xintercept) &&
      !all(grepl("^\\s*\\d{1,2}:\\d{2}(:\\d{2}(\\.\\d+)?)?\\s*$", xintercept))) {
    stop("Supply 'timezone' when checking date-time character values.", call. = FALSE)
  }
  ggplot2::layer(
    stat = StatTimeVline,
    geom = ggplot2::GeomVline,
    position = "identity",
    inherit.aes = TRUE,
    mapping = ggplot2::aes(time = .data[["time"]]),
    params = c(
      list(time_value = xintercept, timezone = timezone, check_timezone = check_timezone),
      list(...)
    )
  )
}

StatTimeVline <- ggplot2::ggproto(
  "StatTimeVline", ggplot2::Stat,
  optional_aes = c("time"),
  compute_panel = function(data, scales, time_value, timezone = NULL,
                           check_timezone = FALSE) {
    if (!"time" %in% names(data)) {
      stop("geom_time_vline() needs an actiplot with timestamped data.", call. = FALSE)
    }
    timezone_supplied <- !is.null(timezone)
    if (!timezone_supplied) {
      timezone <- .acti_time_zone(data[["time"]])
    }
    parsed <- .acti_time_parse_intercept(
      time_value, timezone, check_timezone, timezone_supplied
    )
    is_day_plot <- max(data[["x"]], na.rm = TRUE) <= 1440

    if (identical(parsed$type, "time")) {
      intercept <- if (is_day_plot) {
        parsed$value / 60
      } else {
        as.numeric(actibase::acti_repeat_time_of_day(
          parsed$value, data[["time"]], timezone = timezone
        ))
      }
      return(data.frame(xintercept = intercept))
    }

    if (!is_day_plot) {
      return(data.frame(xintercept = as.numeric(parsed$value)))
    }

    target_date <- as.Date(parsed$value, tz = timezone)
    panel_date <- as.Date(data[["time"]][1L], tz = timezone)
    if (!identical(target_date, panel_date)) {
      return(data.frame())
    }
    data.frame(
      xintercept = actibase::acti_time_to_minute(
        parsed$value, start = 0L, timezone = timezone
      )
    )
  }
)

# nocov start
.acti_plot_parse_vline_time <- function(xintercept, timezone, check_timezone,
                                        timezone_supplied = TRUE) {
  if (inherits(xintercept, "hms")) {
    return(list(type = "time", value = as.numeric(xintercept)))
  }
  if (inherits(xintercept, "POSIXt")) {
    return(list(type = "datetime", value = as.POSIXct(xintercept, tz = timezone)))
  }
  if (!is.character(xintercept) || length(xintercept) < 1L || anyNA(xintercept)) {
    stop("'xintercept' must be a POSIXct value or a non-missing time character string.", call. = FALSE)
  }
  is_time_of_day <- grepl("^\\s*\\d{1,2}:\\d{2}(:\\d{2}(\\.\\d+)?)?\\s*$", xintercept)
  if (all(is_time_of_day)) {
    return(list(type = "time", value = .acti_plot_parse_hms(trimws(xintercept))))
  }
  if (any(is_time_of_day)) {
    stop("'xintercept' cannot mix times of day and date-times.", call. = FALSE)
  }
  if (check_timezone && !timezone_supplied) {
    stop("Supply 'timezone' when checking date-time character values.", call. = FALSE)
  }
  value <- as.POSIXct(xintercept, tz = timezone)
  if (anyNA(value)) {
    stop("Could not parse 'xintercept' as a date-time.", call. = FALSE)
  }
  list(type = "datetime", value = value)
}

.acti_plot_repeat_time_of_day <- function(seconds, time) {
  timezone <- .acti_plot_timezone(time)
  dates <- seq(min(as.Date(time, tz = timezone)),
               max(as.Date(time, tz = timezone)), by = "day")
  as.numeric(as.POSIXct(dates, tz = timezone)) + seconds
}

.acti_plot_time_of_day_minutes <- function(time, timezone) {
  .acti_plot_parse_hms(
    format(time, format = "%H:%M:%S", tz = timezone, usetz = FALSE)
  ) / 60
}

.acti_plot_parse_hms <- function(time) {
  time <- ifelse(grepl("^\\d{1,2}:\\d{2}$", time), paste0(time, ":00"), time)
  as.numeric(hms::parse_hms(time))
}
# nocov end
