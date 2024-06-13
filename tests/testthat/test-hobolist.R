library(hoboR)
library(testthat)

# Sample data for testing
set.seed(123)
times <- seq(from = as.POSIXct("2023-06-01 00:00:00", tz = "UTC"), 
             by = "hour", length.out = 10)
list.data <- list(
  data.frame(Date = times, Temp = rnorm(10, 20, 1), Rain = rnorm(10, 50, 5), RH = rnorm(10, 1013, 10)),
  data.frame(Date = times, Temp = rnorm(10, 21, 1), Rain = rnorm(10, 55, 5), RH = rnorm(10, 1015, 10)),
  data.frame(Date = times, Temp = rnorm(10, 19, 1), Rain = rnorm(10, 52, 5), RH = rnorm(10, 1012, 10))
)
times_of_interest <- c("2023-06-01 00:00:00", "2023-06-01 01:00:00", "2023-06-01 02:00:00")


test_that("testhobolist correctly counts total and present entries", {
  result <- testhobolist(data = list.data, times = times_of_interest)
  
  expect_equal(nrow(result), 3) 
  expect_equal(colnames(result), c("Total entries", "Present entries"))
  expect_equal(result[1, "Present entries"], 3) 
})

test_that("testhobolist handles no matching times", {
  no_match_times <- c("2024-01-01 00:00:00", "2024-01-01 01:00:00")
  expect_error(testhobolist(data=list.data, times=no_match_times), "The specified time ranges do not match any entries")
})

test_that("testhobolist handles all matching times", {
  all_match_times <- as.character(times)
  result <- testhobolist(list.data, all_match_times)
  
  expect_equal(as.numeric(result[, "Present entries"]), rep(1, 3)) 
  expect_equal(as.numeric(result[, "Total entries"]), rep(10, 3)) 
})

test_that("testhobolist handles empty data frames", {
  empty_data <- list(
    data.frame(Date = as.POSIXct(character()), Temp = numeric(), Humidity = numeric(), Pressure = numeric())
  )
  expect_error(testhobolist(empty_data, times_of_interest), "The specified time ranges do not match any entries")
})

test_that("testhobolist handles missing Date column gracefully", {
  incomplete_data <- list(
    data.frame(Temp = rnorm(10, 20, 1), Humidity = rnorm(10, 50, 5), Pressure = rnorm(10, 1013, 10))
  )
  
  expect_error(testhobolist(incomplete_data, times_of_interest), "The specified time ranges do not match any entries")
})