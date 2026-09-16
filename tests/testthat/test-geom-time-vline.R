test_that("time-only vertical lines repeat across aligned daily facets", {
  data <- acti_minute_data[c(1:120, 1441:1560), ]
  plot <- acti_plot_day(data, counts) +
    geom_time_vline("13:30", linetype = "dashed")
  built <- ggplot2::ggplot_build(plot)
  lines <- built$data[[2]]

  expect_equal(lines$xintercept, c(810, 810))
  expect_equal(as.integer(sort(unique(lines$PANEL))), c(1L, 2L))
})

test_that("day plots convert character and hms intercepts to numeric minutes", {
  data <- acti_minute_data[c(1:120, 1441:1560), ]
  character_line <- ggplot2::ggplot_build(
    acti_plot_day(data, counts) + geom_time_vline(xintercept = "10:00:00")
  )$data[[2]]
  hms_line <- ggplot2::ggplot_build(
    acti_plot_day(data, counts) +
      geom_time_vline(xintercept = hms::as_hms("10:00:00"))
  )$data[[2]]

  expect_equal(character_line$xintercept, c(600, 600))
  expect_equal(hms_line$xintercept, c(600, 600))
})

test_that("datetime vertical lines target the matching daily facet", {
  data <- acti_minute_data[c(1:120, 1441:1560), ]
  plot <- acti_plot_day(data, counts) +
    geom_time_vline(as.POSIXct("2017-06-03 13:30:00", tz = "GMT"))
  lines <- ggplot2::ggplot_build(plot)$data[[2]]

  expect_equal(lines$xintercept, 810)
  expect_equal(as.integer(lines$PANEL), 2L)
})

test_that("time-only lines repeat for every date on full-time plots", {
  data <- acti_minute_data[c(1:120, 1441:1560), ]
  plot <- acti_plot_time(data, counts) + geom_time_vline("13:30")
  lines <- ggplot2::ggplot_build(plot)$data[[2]]

  expect_equal(length(lines$xintercept), 2L)
  expect_equal(diff(lines$xintercept), 24 * 60 * 60)
})

test_that("time layer validates and parses inputs", {
  expect_error(geom_time_vline(), "'xintercept' is required")
  expect_error(ggplot2::ggplot_build(acti_plot_time(acti_minute_data, counts) + geom_time_vline(NA_character_)), "non-missing")
  expect_error(
    ggplot2::ggplot_build(
      acti_plot_time(acti_minute_data, counts) +
        geom_time_vline("2017-06-03 10:00:00", check_timezone = TRUE)
    ),
    "Supply 'timezone'"
  )
  expect_error(geom_time_vline("12:00", timezone = c("GMT", "UTC")), "single")
  expect_error(geom_time_vline("12:00", check_timezone = NA), "TRUE or FALSE")
})
