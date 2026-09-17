test_that("episode layers validate interval data and add rectangles", {
  episodes <- data.frame(
    start = as.POSIXct("2017-06-03 22:00:00", tz = "GMT"),
    end = as.POSIXct("2017-06-04 07:00:00", tz = "GMT")
  )
  plot <- acti_plot_time(acti_minute_data, counts) + geom_episode(episodes)
  expect_equal(ggplot2::ggplot_build(plot)$data[[2]]$xmin, as.numeric(episodes$start))
  expect_error(geom_episode(data.frame()), "start")
  expect_error(geom_episode(transform(episodes, start = as.character(start))), "POSIXct")
  expect_error(geom_episode(transform(episodes, end = start - 1)), "on or after")
})

test_that("sleep, wear, and boundary layers are available", {
  episodes <- data.frame(
    start = as.POSIXct("2017-06-03 22:00:00", tz = "GMT"),
    end = as.POSIXct("2017-06-04 07:00:00", tz = "GMT")
  )
  expect_s3_class(geom_sleep_window(episodes), "Layer")
  expect_s3_class(geom_wear(episodes), "Layer")
  expect_s3_class(geom_day_boundary(), "Layer")
})
