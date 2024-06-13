library(hoboR)
library(ggplot2)
library(testthat)

# Sample data for testing
df <- data.frame(
  Date = as.POSIXct(c(
    '2023-06-01 01:00:00', '2023-06-01 02:00:00', '2023-06-01 03:00:00',
    '2023-06-02 01:00:00', '2023-06-02 02:00:00', '2023-06-02 03:00:00',
    '2023-07-02 01:00:00', '2023-07-02 02:00:00', '2023-07-02 03:00:00'
  ), tz="UTC"),
  Temp = c(15, 16, 15.5, 17, 18, 17.5, 15, 12, 13.5),
  Humidity = c(50, 55, 52, 53, 58, 57, 52, 48, 50),
  Rain = c(0, 1, 0, 2, 1, 1, 10, 11, 12)
)

test_that("timestamp selects data correctly based on the provided timestamp and interval", {
  result <- timestamp(df, stamp = "2023-06-01 01:00:00", by = "24 hours", days = 3, na.rm = TRUE, plot = T, var = "Temp")
  expect_equal(nrow(result$data), 2)
  expect_equal(result$data$Temp, c(15, 17))
})

test_that("timestamp handles na.rm correctly", {
  df_with_na <- df
  df_with_na$Temp[2] <- NA
  result_na_rm_true <- timestamp(df_with_na, stamp = "2023-06-01 01:00:00", by = "1 hour", days = 2, na.rm = TRUE, plot = FALSE, var = "Temp")
  expect_equal(nrow(result_na_rm_true$data), 2)
  expect_equal(result_na_rm_true$data$Temp, c(15, NA))
  
  result_na_rm_false <- timestamp(df_with_na, stamp = "2023-06-01 01:00:00", by = "1 hours", days = 2, na.rm = FALSE, plot = FALSE, var = "Temp")
  expect_true(any(is.na(result_na_rm_false$data$Temp)))
})

test_that("timestamp correctly interprets the provided timestamp", {
  result <- timestamp(df, stamp = "2023-06-01 01:00:00", by = "1 hour", days = 2, na.rm = TRUE, plot = FALSE, var = "Temp")
  expect_equal(result$data$Date[1], as.POSIXct("2023-06-01 01:00:00", tz = "UTC"))
})

test_that("timestamp generates a plot when plot = TRUE", {
  q <- timestamp(df, stamp = "2023-06-01 01:00:00", by = "1 hour", days = 2, na.rm = TRUE, plot = TRUE, var = "Temp")
  expect_s3_class(q$plot, "ggplot")
})

test_that("timestamp handles plot = FALSE", {
  expect_output(timestamp(df, stamp = "2023-06-01 01:00:00", by = "24 hours", days = 2, na.rm = TRUE, plot = FALSE, var = "Temp"), "No plot")
})

test_that("timestamp handles empty data frame", {
  empty_df <- data.frame(Date = as.POSIXct(character()), Temp = numeric(), Humidity = numeric(), Rain = numeric())
  expect_error(timestamp(empty_df, stamp = "2023-06-01 01:00:00", by = "24 hours", days = 2, na.rm = TRUE, plot = FALSE, var = "Temp"), "Empty input")
})

test_that("timestamp handles timestamp out of range", {
  expect_error(timestamp(df, stamp = "2025-06-01 00:00", by = "24 hours", days = 2, na.rm = TRUE, plot = FALSE, var = "Temp"), "Date out of range")
})

