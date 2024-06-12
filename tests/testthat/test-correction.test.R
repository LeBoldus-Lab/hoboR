library(hoboR)
library(testthat)

# Sample data for testing
set.seed(123)
times <- seq(from = as.POSIXct("2023-06-01 00:00:00", tz = "UTC"), 
             by = "hour", length.out = 10)
list.data <- list(
  data.frame(Date = times, Temp = rnorm(10, 20, 1), Rain = rnorm(10, 50, 5), RH = rnorm(10, 90, 10)),
  data.frame(Date = times, Temp = rnorm(10, 21, 1), Rain = rnorm(10, 55, 5), RH = rnorm(10, 88, 10)),
  data.frame(Date = times, Temp = rnorm(10, 19, 1), Rain = rnorm(10, 52, 5), RH = rnorm(10, 91, 10))
)

times_of_interest <- as.POSIXct(c("2023-06-01 01:00:00",  "2023-06-01 03:00:00", 
                                  "2023-06-01 06:00:00", "2023-06-01 09:00:00"), tz = "UTC")
threshold <- c(1, 5, 10)
w.var <- c("Temp", "Rain", "RH")

calibrationfile <- data.frame(
  Temp = c(0.5, -0.5, 05),
  Rain = c(-1, 0.5, 0.5),
  RH = c(1, -1, 0.5)
)

test_that("correction.test calculates differences and checks thresholds correctly", {
  result <- correction.test(list.data, calibrationfile, w.var = w.var, times = times_of_interest, threshold = threshold)
  
  expect_equal(dim(result[[1]]), c(3, 3)) 
  expect_true(all(result[[1]] %in% c("passed", "not passed"))) 
})

test_that("correction.test handles threshold values correctly", {
  result <- correction.test(list.data, calibrationfile, w.var = w.var, times = times_of_interest, threshold = c(10, 10, 10))
  
  expect_equal(all(result[[1]] == "passed"), T)
})

test_that("correction.test subsets columns correctly", {
  result <- correction.test(list.data, calibrationfile, w.var = w.var, times = times_of_interest, threshold = threshold)
  
  expect_true(all(colnames(list.data[[1]][w.var]) %in% colnames(result[[1]]))) # Columns should match
})

test_that("correction.test handles invalid w.var", {
  invalid_w.var <- c("Temp", "Nonexistent")
  
  expect_error(correction.test(list.data, calibrationfile, w.var = invalid_w.var, times = times_of_interest, threshold = threshold),
               "undefined columns selected")
})

test_that("correction.test handles empty data frames", {
  empty_data <- list(
    data.frame(Date = as.POSIXct(character()), Temp = numeric(), Rain = numeric(), RH = numeric()),
    data.frame(Date = as.POSIXct(character()), Temp = numeric(), Rain = numeric(), RH = numeric()),
    data.frame(Date = as.POSIXct(character()), Temp = numeric(), Rain = numeric(), RH = numeric())
  )
  expect_error(result <- correction.test(empty_data, calibrationfile, w.var = w.var, 
                                           times = times_of_interest, threshold = threshold), 
                 "Empty input")
})

test_that("correction.test handles missing weather variables", {
  incomplete_data <- list(data.frame(Date = times, Temp = rnorm(10, 20, 1)))
  
  expect_error(correction.test(incomplete_data, calibrationfile, w.var = w.var, times = times_of_interest, threshold = threshold), 
               "undefined columns selected")
})
