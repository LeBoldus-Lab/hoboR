library(hoboR)
library(testthat)

# Sample data for testing
set.seed(123)
times <- seq(from = as.POSIXct("2023-06-01 00:00:00", tz = "UTC"), 
             by = "hour", length.out = 10)
list.data <- list(
  data.frame(Date = times, Temp = rnorm(10, 20, 1), Rain = rnorm(10, 50, 5), HR = rnorm(10, 90, 10)),
  data.frame(Date = times, Temp = rnorm(10, 21, 1), Rain = rnorm(10, 55, 5), HR = rnorm(10, 88, 10)),
  data.frame(Date = times, Temp = rnorm(10, 19, 1), Rain = rnorm(10, 52, 5), HR = rnorm(10, 91, 10))
)


calibrate <- data.frame(
  Temp = c(0.5, -0.5, 1),
  Rain = c(-2, 1.5, 0.5),
  HR = c(3, -3, 2)
)

test_that("correction applies calibration correctly for FULL", {
  result <- correction(list.data, w.var = "FULL", calibrate = calibrate)
  
  for (i in seq_along(result)) {
    expect_equal(result[[i]]$Temp, list.data[[i]]$Temp + calibrate$Temp[i])
    expect_equal(result[[i]]$Rain, list.data[[i]]$Rain + calibrate$Rain[i])
    expect_equal(result[[i]]$HR, list.data[[i]]$HR + calibrate$HR[i])
  }
})

test_that("correction applies calibration correctly for specific weather variable", {
  specific_calibration <- 2.5
  result <- correction(list.data[[1]], w.var = "Temp", calibrate = specific_calibration)
  
  expect_equal(result$Temp, list.data[[1]]$Temp + specific_calibration)
  expect_equal(result$Rain, list.data[[1]]$Rain)
  expect_equal(result$HR, list.data[[1]]$HR)
})

test_that("correction handles mismatched weather variables", {
  calibrate_invalid <- data.frame(
    WindSpeed = c(1, 2, 3)
  )
  
  expect_warning(correction(list.data, w.var = "FULL", calibrate = calibrate_invalid), "Weather variables do not match")
})

test_that("correction handles invalid calibration values gracefully", {
  invalid_calibration <- "invalid"
  
  expect_warning(correction(list.data[[1]], w.var = "Temp", calibrate = invalid_calibration), "NAs introduced by coercion")
})

test_that("correction handles empty data frames", {
  empty_data <- list(
    data.frame(Date = as.POSIXct(character()), Temp = numeric(), Rain = numeric(), HR = numeric()),
    data.frame(Date = as.POSIXct(character()), Temp = numeric(), Rain = numeric(), HR = numeric()),
    data.frame(Date = as.POSIXct(character()), Temp = numeric(), Rain = numeric(), HR = numeric())
  )
  
  
  result <- correction(empty_data, w.var = "FULL", calibrate = calibrate)
  expect_equal(nrow(result[[1]]), 0)
})

test_that("correction handles missing weather variables", {
  incomplete_data <- list(
    data.frame(Date = times, Temp = rnorm(10, 20, 1))
  )
  
  expect_warning(correction(incomplete_data, w.var = "FULL", calibrate = calibrate), "Weather variables do not match")
})
