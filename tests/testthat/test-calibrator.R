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
columns <- c("Temp", "Rain", "HR")

times_of_interest <- as.POSIXct(c("2023-06-01 01:00:00",  "2023-06-01 03:00:00", 
                                  "2023-06-01 06:00:00", "2023-06-01 09:00:00"), tz = "UTC")


test_that("calibrator calculates differences correctly", {
  result <- calibrator(list.data = list.data, columns = columns, times = times_of_interest)
  
  expect_equal(nrow(result), 3) 
  expect_equal(ncol(result), length(columns)) 
  expect_true(all(rownames(result) == paste0("hobo", 1:3))) 
})

test_that("calibrator handles unequal data frame sizes", {
  # Creating a list with unequal sizes
  unequal_data <- list(
    data.frame(Date = times, Temp = rnorm(10, 20, 1), Rain = rnorm(10, 50, 5), HR = rnorm(10, 1013, 10)),
    data.frame(Date = times[1:8], Temp = rnorm(8, 21, 1), Rain = rnorm(8, 55, 5), HR = rnorm(8, 1015, 10))
  )
  
  expect_warning(result <- calibrator(list.data = unequal_data, columns = columns, times = times_of_interest),
                 "Input Error: Attempting to subtract data frames of unequal size")
  expect_true(any(is.nan(result)))
})

test_that("calibrator subsets columns correctly", {
  result <- calibrator(list.data = list.data, columns = columns, times = times_of_interest)
  
  expect_true(all(colnames(result) == columns)) # Columns should match
})

test_that("calibrator handles invalid columns", {
  invalid_columns <- c("Nonexistent", "Temp")
  
  expect_error(calibrator(list.data = list.data, columns = invalid_columns, times = times_of_interest),
               "undefined columns selected")
})

test_that("calibrator handles empty data frames", {
  empty_data <- list(
    data.frame(Date = as.POSIXct(character()), Temp = numeric(), Rain = numeric(), HR = numeric()),
    data.frame(Date = as.POSIXct(character()), Temp = numeric(), Rain = numeric(), HR = numeric()),
    data.frame(Date = as.POSIXct(character()), Temp = numeric(), Rain = numeric(), HR = numeric())
  )
  
  expect_true(any(is.nan(result <- calibrator(list.data = empty_data, columns = columns, times = times_of_interest))))
})
