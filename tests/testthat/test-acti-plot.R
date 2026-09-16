example_activity <- function() {
  # Three same-length windows from the package's minute-level data.
  acti_minute_data[c(1:120, 1441:1560, 2881:3000), ]
}

test_that("all plotting functions accept packaged minute-level data", {
  data <- example_activity()

  expect_s3_class(acti_plot_time(data, counts), "ggplot")
  expect_s3_class(acti_plot_time(data, "counts", breaks = "4 hours"), "ggplot")
  expect_s3_class(acti_plot_day(data, counts), "ggplot")
  expect_s3_class(acti_plot_day(data, "counts", breaks = NULL), "ggplot")
  expect_s3_class(acti_plot_heatmap(data, counts, breaks = "15 mins"), "ggplot")
})

test_that("day plots align time of day without expanding to a full day", {
  data <- example_activity()
  plot <- acti_plot_day(data, counts, breaks = "4 hours")
  built <- ggplot2::ggplot_build(plot)

  expect_equal(sort(unique(built$data[[1]]$x)), 720:839)
  expect_equal(length(plot$facet$params$rows), 1L)
  expect_equal(length(unique(built$data[[1]]$PANEL)), 3L)
  expect_equal(built$layout$panel_params[[1]]$x.range, c(720, 839))
})

test_that("column selection, input types, and breaks are validated", {
  data <- data.frame(
    time = as.POSIXct("2024-01-01", tz = "UTC") + 60 * 0:1,
    steps = c(1, 2)
  )

  expect_error(acti_plot_time(1, steps), "must be a data frame")
  expect_error(acti_plot_time(data, missing), "must name a column")
  expect_error(acti_plot_time(transform(data, steps = as.character(steps)), steps), "must be numeric")
  expect_error(acti_plot_time(data, steps, time = missing), "must name a timestamp")
  expect_error(acti_plot_time(transform(data, time = as.character(time)), steps), "must be POSIXct")
  expect_error(acti_plot_time(data, 1 + 1), "must be a column name")
  expect_error(acti_plot_time(data, steps, time = 1 + 1), "must be a column name")
  expect_error(acti_plot_day(data, steps, breaks = "tomorrow"), "must be a duration")
  expect_error(acti_plot_time(data, steps, breaks = "tomorrow"), "must be a duration")
  expect_error(acti_plot_day(data, steps, breaks = NA_character_), "must be NULL or a duration")
  expect_error(acti_plot_day(data, steps, breaks = "0 minutes"), "greater than zero")
  expect_error(acti_plot_day(data, steps, breaks = "25 hours"), "no more than 24 hours")
})

test_that("break durations and labels are calculated correctly", {
  expect_identical(.acti_plot_break_minutes("1 hour"), 60)
  expect_identical(.acti_plot_break_minutes("15 mins"), 15)
  expect_identical(.acti_plot_break_minutes("0.5 hours"), 30)
  expect_equal(.acti_plot_time_labels(c(0, 15, 60, 1440)), c("00:00", "00:15", "01:00", "24:00"))
})

test_that("plots have stable visual output", {
  data <- example_activity()

  vdiffr::expect_doppelganger(
    "minute-level counts over time",
    acti_plot_time(data, counts, breaks = "4 hours")
  )
  vdiffr::expect_doppelganger(
    "daily aligned minute-level counts",
    acti_plot_day(data, counts, breaks = "4 hours")
  )
  vdiffr::expect_doppelganger(
    "minute-level counts heatmap",
    acti_plot_heatmap(data, counts, breaks = "4 hours")
  )
})
