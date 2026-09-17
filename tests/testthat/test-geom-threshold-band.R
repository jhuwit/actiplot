test_that("threshold bands select the requested observations", {
  data <- acti_minute_data[1:5, ]
  threshold <- data$counts[3]
  plot <- acti_plot_time(data, counts) +
    geom_threshold_band(data, "counts", threshold)
  band <- ggplot2::ggplot_build(plot)$data[[2]]

  expect_equal(nrow(band), sum(data$counts >= threshold))
  expect_error(geom_threshold_band(data, "missing", 1), "must contain")
})
