test_that("minute-level plots return ggplot objects", {
  data <- data.frame(
    time = as.POSIXct("2024-01-01 00:00:00", tz = "UTC") + 60 * 0:5,
    steps = c(0, 4, 12, 0, 3, 8),
    counts = c(10, 20, 30, 40, 50, 60)
  )

  expect_s3_class(acti_plot_time(data, steps), "ggplot")
  expect_s3_class(acti_plot_day(data, "steps", breaks = "1 hour"), "ggplot")
  expect_s3_class(acti_plot_heatmap(data, counts, breaks = "15 mins"), "ggplot")
})

test_that("day plots align time of day and facet by date", {
  data <- data.frame(
    time = as.POSIXct("2024-01-01 23:59:00", tz = "UTC") + 60 * 0:2,
    steps = c(2, 4, 6)
  )
  plot <- acti_plot_day(data, steps, breaks = "4 hours")
  built <- ggplot2::ggplot_build(plot)

  expect_equal(sort(unique(built$data[[1]]$x)), c(0, 1, 1439))
  expect_equal(length(plot$facet$params$rows), 1L)
})

test_that("plot inputs and break specifications are validated", {
  data <- data.frame(
    time = as.POSIXct("2024-01-01", tz = "UTC") + 60 * 0:1,
    steps = c(1, 2)
  )

  expect_error(acti_plot_time(data, missing), "must name a column")
  expect_error(acti_plot_day(data, steps, breaks = "tomorrow"), "must be a duration")
  expect_error(acti_plot_time(data, steps, breaks = "tomorrow"), "must be a duration")
})
