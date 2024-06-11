library(testthat)
library(hobor)

# Sample data for testing
df <- data.frame(
  Date = as.POSIXct(c(
    '2023-06-01 00:00:00', '2023-06-01 01:00:00', '2023-06-01 02:00:00',
    '2023-06-02 00:00:00', '2023-06-02 01:00:00', '2023-06-02 02:00:00'
  )),
  Temp = c(15, 16, 15.5, 17, 18, 17.5),
  Humidity = c(50, 55, 52, 53, 58, 57),
  Rain = c(0, 1, 0, 2, 1, 1)
)


test_that("hobocorrelations creates a correlation heatmap", {
  result <- hobocorrelations(df, summariseby = "day", by = mean, na.rm = TRUE)
  expect_s3_class(result, "ggplot")
})

test_that("hobocorrelations handles na.rm correctly", {
  df_with_na <- df
  df_with_na$Temp[2] <- NA
  result_na_rm_true <- hobocorrelations(df_with_na, summariseby = "day", by = mean, na.rm = TRUE)
  expect_s3_class(result_na_rm_true, "ggplot")
  
  result_na_rm_false <- hobocorrelations(df_with_na, summariseby = "day", by = mean, na.rm = FALSE)
  expect_s3_class(result_na_rm_false, "ggplot")
})

test_that("hobocorrelations handles different summarization intervals", {
  result_day <- hobocorrelations(df, summariseby = "day", by = mean, na.rm = TRUE)
  expect_s3_class(result_day, "ggplot")
  
  result_hour <- hobocorrelations(df, summariseby = "hour", by = mean, na.rm = TRUE)
  expect_s3_class(result_hour, "ggplot")
})

test_that("hobocorrelations handles empty data frame", {
  empty_df <- data.frame(Date = as.POSIXct(character()), Temp = numeric(), Humidity = numeric(), Rain = numeric())
  expect_warning(hobocorrelations(empty_df, summariseby = "day", by = mean, na.rm = TRUE), "Empty input")
})

test_that("hobocorrelations handles single row data frame", {
  single_row_df <- data.frame(
    Date = as.POSIXct('2023-06-01 00:00:00'),
    Temp = 15,
    Humidity = 50,
    Rain = 0
  )
  expect_s3_class(result_hour, "ggplot")
})
