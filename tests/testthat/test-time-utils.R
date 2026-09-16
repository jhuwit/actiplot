test_that("internal time utilities preserve timezone and minute semantics", {
  time <- as.POSIXct("2024-01-02 10:30:15", tz = "GMT")

  expect_identical(.acti_time_zone(time), "GMT")
  expect_identical(.acti_time_zone(as.POSIXct("2024-01-02")), "UTC")
  expect_equal(.acti_time_parse_hms(c("10:30", "10:30:15")), c(37800, 37815))
  expect_equal(.acti_time_minute_of_day(time, "GMT"), 630.25)
  expect_equal(
    diff(.acti_time_repeat_daily(
      36000,
      as.POSIXct(c("2024-01-01", "2024-01-02"), tz = "GMT")
    )),
    86400
  )
})

test_that("time intercept parsing distinguishes time and datetime values", {
  expect_equal(
    .acti_time_parse_intercept("10:00", "GMT", FALSE)$value,
    36000
  )
  expect_equal(
    .acti_time_parse_intercept(hms::as_hms("10:00:00"), "GMT", FALSE)$value,
    36000
  )
  expect_s3_class(
    .acti_time_parse_intercept(
      as.POSIXct("2024-01-01 10:00:00", tz = "GMT"), "GMT", FALSE
    )$value,
    "POSIXct"
  )
  expect_equal(
    .acti_time_parse_intercept("2024-01-01 10:00:00", "GMT", FALSE)$type,
    "datetime"
  )
  expect_error(.acti_time_parse_intercept(c("10:00", "2024-01-01 10:00:00"), "GMT", FALSE), "cannot mix")
  expect_error(.acti_time_parse_intercept("2024-01-01 10:00:00", "GMT", TRUE, FALSE), "Supply")
  expect_error(.acti_time_parse_intercept("not a time", "GMT", FALSE), "Could not parse")
})
