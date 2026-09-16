# Internal time helpers shared by plotting layers.

.acti_time_zone <- function(time) {
  timezone <- attr(time, "tzone")
  if (is.null(timezone) || !nzchar(timezone[1L])) "UTC" else timezone[1L]
}

.acti_time_parse_hms <- function(time) {
  time <- ifelse(grepl("^\\d{1,2}:\\d{2}$", time), paste0(time, ":00"), time)
  as.numeric(hms::parse_hms(time))
}

.acti_time_minute_of_day <- function(time, timezone) {
  .acti_time_parse_hms(
    format(time, format = "%H:%M:%S", tz = timezone, usetz = FALSE)
  ) / 60
}

.acti_time_repeat_daily <- function(seconds, time) {
  timezone <- .acti_time_zone(time)
  dates <- seq(min(as.Date(time, tz = timezone)),
               max(as.Date(time, tz = timezone)), by = "day")
  as.numeric(as.POSIXct(dates, tz = timezone)) + seconds
}

.acti_time_parse_intercept <- function(xintercept, timezone, check_timezone,
                                       timezone_supplied = TRUE) {
  if (inherits(xintercept, "hms")) {
    return(list(type = "time", value = as.numeric(xintercept)))
  }
  if (inherits(xintercept, "POSIXt")) {
    return(list(type = "datetime", value = as.POSIXct(xintercept, tz = timezone)))
  }
  if (!is.character(xintercept) || length(xintercept) < 1L || anyNA(xintercept)) {
    stop("xintercept must be a POSIXct value or a non-missing time string.", call. = FALSE)
  }
  is_time_of_day <- grepl("^\\s*\\d{1,2}:\\d{2}(:\\d{2}(\\.\\d+)?)?\\s*$", xintercept)
  if (all(is_time_of_day)) {
    return(list(type = "time", value = .acti_time_parse_hms(trimws(xintercept))))
  }
  if (any(is_time_of_day)) {
    stop("xintercept cannot mix times of day and date-times.", call. = FALSE)
  }
  if (check_timezone && !timezone_supplied) {
    stop("Supply a timezone when checking date-time character values.", call. = FALSE)
  }
  value <- tryCatch(
    as.POSIXct(xintercept, tz = timezone),
    error = function(error) as.POSIXct(NA)
  )
  if (anyNA(value)) stop("Could not parse xintercept as a date-time.", call. = FALSE)
  list(type = "datetime", value = value)
}
