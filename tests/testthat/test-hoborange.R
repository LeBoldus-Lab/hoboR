library(hoboR)
library(testthat)


# Sample data for testing
df <- data.frame(
  Date = as.POSIXct(c("2010-01-01 01:00", "2011-01-01 01:00", "2013-01-01 01:00", "2014-01-01 01:00"), tz = "UTC"),
  Temperature = c(15.5, 16.2, 14.8, 15.0)
)

test_that("hoborange subsets data correctly within date range", {
  result <- hoborange(df, start = "2010-01-01 00:00", end = "2013-01-01 00:00")
  expect_equal(nrow(result), 3)
  expect_equal(result$Temperature, c(15.5, 16.2, 14.8))
})

test_that("hoborange handles dates out of range", {
  expect_error(hoborange(df, start = "2010-01-01 01:00", end = "2022-01-01 00:00"), "Provided dates are out of range")
})

test_that("hoborange handles invalid date formats", {
  expect_error(hoborange(df, start = "2010-03-01 01:00", end = "1920-01-01 00:00"), "Provided dates are out of range")
  expect_error(hoborange(df, start = "1910-01-01 00:00", end = "invalid-date"), "Provided dates are out of range")
})

test_that("hoborange handles empty data frame", {
  empty_df <- data.frame(Date = as.POSIXct(character()), Temperature = numeric())
  expect_error(hoborange(empty_df, start = "1910-01-01 00:00", end = "1920-01-01 00:00"), "Provided dates are out of range")
  expect_equal(nrow(result), 0)
})

test_that("hoborange handles NA values correctly", {
  df_with_na <- data.frame(
    Date = as.POSIXct(c('1910-01-01 00:00', '1915-01-01 00:00', '1920-01-01 00:00', '1925-01-01 00:00')),
    Temperature = c(15.5, NA, 14.8, 15.0)
  )
  result_na_rm_true <- hoborange(df_with_na, start = "1910-01-01 00:00", end = "1925-01-01 00:00", na.rm = TRUE)
  expect_equal(nrow(result_na_rm_true), 4)
  expect_equal(sum(is.na(result_na_rm_true$Temperature)), 1)
  
  result_na_rm_false <- hoborange(df_with_na, start = "1910-01-01 00:00", end = "1925-01-01 00:00", na.rm = FALSE)
  expect_equal(nrow(result_na_rm_false), 4)
  expect_equal(sum(is.na(result_na_rm_false$Temperature)), 1)
})

test_that("hoborange handles single row data frame", {
  single_row_df <- data.frame(
    Date = as.POSIXct('1910-01-01 00:00'),
    Temperature = 15.5
  )
  expect_error(hoborange(single_row_df, start = "1910-01-01 00:00", end = "1920-01-01 00:00"))
})
