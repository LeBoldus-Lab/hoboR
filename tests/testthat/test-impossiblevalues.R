library(hoboR)
library(dplyr)
library(testthat)

# Sample data for testing
df <- data.frame(
  Date = as.POSIXct(c(
    '2023-06-01 00:00:00', '2023-06-01 01:00:00', '2023-06-01 02:00:00',
    '2023-06-02 00:00:00', '2023-06-02 01:00:00', '2023-06-02 02:00:00'
  )),
  Temp = c(15, 100, 76, 17, 18, 17.5),
  Humidity = c(50, 55, 52, 101, 200, 57),
  Rain = c(0, 1, 0, 2100, 5000, 20)
)


test_that("impossiblevalues identifies max and min values correctly", {
  result <- impossiblevalues(df, showrows = 2)
  expect_true(is.data.frame(result))
  
  expect_equal(as.numeric(result[1, ]), c(100, 200, 5000))
  expect_equal(as.numeric(result[min(nrow(result)),]), c(15, 50, 0))
  
  expect_equal(result[1, "Temp"], "100")
})



test_that("impossiblevalues handles empty data frame", {
  empty_df <- data.frame(Date = as.POSIXct(character()), Temp = numeric(), Humidity = numeric(), Rain = numeric())
  expect_warning(impossiblevalues(empty_df, showrows = 2))
})

test_that("impossiblevalues handles single column data frame", {
  single_col_df <- data.frame(Date = as.POSIXct(c(
    '2023-06-01 00:00:00', '2023-06-01 01:00:00', '2023-06-01 02:00:00', '2023-06-01 03:00:00'
  )), Temp = c(15, 16, 15.5, 114))
  result <- impossiblevalues(single_col_df, showrows = 2)
  expect_equal(nrow(result), 7)  # 2 rows max, 3 rows NA, 2 rows min
  expect_equal(as.numeric(result[1, "Temp"]), 114)
  expect_equal(as.numeric(result[nrow(result), "Temp"]), 15)
})

test_that("impossiblevalues returns correctly structured output", {
  result <- impossiblevalues(df, showrows = 2)
  expect_true(all(c("Temp", "Humidity", "Rain") %in% colnames(result)))
  expect_equal(ncol(result), 3)
})
