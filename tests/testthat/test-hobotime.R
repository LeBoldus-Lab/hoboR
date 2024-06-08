library(hoboR)
library(testthat)
library(lubridate)

test_that("hobotime aggregates data by specified time interval", {
  df <- data.frame(
    X = c(1, 2, 3),
    Date = as.POSIXct(c('2024-06-01 12:00:00', '2024-06-01 12:01:00', '2024-06-01 12:05:00')),
    Value1 = c(1, 2, 3),
    Value2 = c(4, 5, 6),
    Value3 = c(3, 2, 1)
  )
  
  result <- hobotime(df, summariseby = "5 mins")
  expect_equal(nrow(result), 2)
  expect_true(any(class(result$Date) == "POSIXct"))
  expect_equal(result$Value1, c(1.5, 3))
  expect_equal(result$Value2, c(4.5, 6))
})


test_that("hobotime works with different time intervals", {
  df <- data.frame(
    X = c(1, 2, 3),
    Date = as.POSIXct(c('2024-06-01 12:00:00', '2024-06-01 12:02:00', '2024-06-01 12:10:00')),
    Value1 = c(1, 2, 3),
    Value2 = c(4, 5, 6),
    Value3 = c(3, 2, 1)
  )
  result_10mins <- hobotime(df, summariseby = "10 mins")
  expect_equal(nrow(result_10mins), 2)
  expect_equal(result_10mins$Value1, c(1.5, 3))
  expect_equal(result_10mins$Value2, c(4.5, 6))
})

test_that("hobotime fails with data frame without Date column", {
  df <- data.frame(Value1 = c(1, 2, 3), Value2 = c(4, 5, 6))
  expect_error(hobotime(df, summariseby = "5 mins"), "Date not found")
})


test_that("hobotime handles NA values correctly", {
  df <- data.frame(
    Date = as.POSIXct(c('2024-06-01 12:00:00', '2024-06-01 12:02:00', '2024-06-01 12:07:00')),
    Value1 = c(1, NA, 3),
    Value2 = c(4, 5, NA),
    Value3 = c(3, 2, 1)
  )
  
  result_narm_true_omit <- hobotime(df, summariseby = "5 mins", na.rm = T, na.action = na.omit)
  expect_equal(result_narm_true_omit$Value1, 1)
  expect_equal(result_narm_true_omit$Value2, 4)
  expect_equal(result_narm_true_omit$Value3, 3)
  
  result_narm_true_pass <- hobotime(df, summariseby = "5 mins", na.rm = T, na.action = na.pass)
  expect_equal(result_narm_true_pass$Value1, c(1, 3))
  expect_equal(result_narm_true_pass$Value2, c(4.5, NaN))
  expect_equal(result_narm_true_pass$Value3, c(2.5, 1))
  
  result_na_rm_false_pass <- hobotime(df, summariseby = "5 mins", na.rm = F, na.action = na.pass)
  expect_equal(result_na_rm_false_pass$Value1, c(NA, 3))
  expect_equal(result_na_rm_false_pass$Value2, c(4.5, NA))
  expect_equal(result_na_rm_false_pass$Value3, c(2.5, 1))
  
})


test_that("hobotime handles empty data frame", {
  df <- data.frame(Date = as.POSIXct(character()), Value1 = numeric(), Value2 = numeric())
  expect_warning(hobotime(df, summariseby = "5 mins"))
})

test_that("hobotime handles single row data frame", {
  df <- data.frame(
    Date = as.POSIXct('2024-06-01 12:00:00'),
    Value1 = 1,
    Value2 = 4,
    Value3 = 3
  )
  
  result <- hobotime(df, summariseby = "5 mins")
  expect_equal(nrow(result), 1)
  expect_equal(result$Value1, 1)
  expect_equal(result$Value2, 4)
  expect_equal(result$Value3, 3)
})

test_that("hobotime returns correct column types", {
  df <- data.frame(
    Date = as.POSIXct(c('2024-06-01 12:00:00', '2024-06-01 12:02:00', '2024-06-01 12:05:00')),
    Value1 = c(1, 2, 3),
    Value2 = c(4, 5, 6),
    Value3 = c(3, 2, 1)
  )
  
  result <- hobotime(df, summariseby = "5 mins")
  expect_true(is.POSIXt(result$Date))
  expect_true(is.numeric(result$Value1))
  expect_true(is.numeric(result$Value2))
  expect_true(is.numeric(result$Value3))
})