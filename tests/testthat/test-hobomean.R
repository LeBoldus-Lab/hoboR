library(testthat)
library(lubridate)
library(dplyr)

# Sample data for testing
df <- data.frame(
  Date = as.POSIXct(c(
    '2023-06-01 00:00:00', '2023-06-01 01:00:00', '2023-06-01 02:00:00',
    '2023-06-02 00:00:00', '2023-06-02 01:00:00', '2023-06-02 02:00:00'
  )),
  Temp = c(15, 16, 15.5, 17, 18, 17.5),
  Rain = c(0, 1, 0, 2, 1, 1),
  )

test_that("meanhobo calculates means and standard deviations correctly", {
  result <- meanhobo(df, summariseby = "24 hours", na.rm = TRUE)
  expect_equal(nrow(result), 2)
  expect_equal(result$x.Temp, c(15.5, 17.5))
  expect_equal(result$sd.Temp, c(0.5, 0.5))
})

test_that("meanhobo handles na.rm correctly", {
  df_with_na <- df
  df_with_na$Temp[2] <- NA
  result_na_rm_true <- meanhobo(df_with_na, summariseby = "24 hours", na.rm = TRUE)
  expect_equal(result_na_rm_true$x.Temp[1], 15.25)
  expect_equal(result_na_rm_true$sd.Temp[1], sd(c(15, 15.5), na.rm = TRUE))
  
  result_na_rm_false <- meanhobo(df_with_na, summariseby = "24 hours", na.rm = FALSE)
  expect_true(is.na(result_na_rm_false$x.Temp[1]))
})

test_that("meanhobo includes min and max temperatures when minmax is TRUE", {
  result <- meanhobo(df, summariseby = "24 hours", na.rm = TRUE, minmax = TRUE)
  expect_equal(nrow(result), 2)
  expect_equal(result$min.Temp, c(15, 17))
  expect_equal(result$max.Temp, c(16, 18))
})

test_that("meanhobo handles empty data frame", {
  empty_df <- data.frame(Date = as.POSIXct(character()), Temp = numeric(), Rain = numeric())
  expect_warning(meanhobo(empty_df, summariseby = "24 hours", na.rm = TRUE), "Empty input")
})

test_that("meanhobo handles different time intervals", {
  result <- meanhobo(df, summariseby = "1 hour", na.rm = TRUE)
  expect_equal(nrow(result), 6)
  expect_equal(result$x.Temp, c(15, 16, 15.5, 17, 18, 17.5))
})
