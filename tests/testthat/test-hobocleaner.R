library(hoboR)
library(testthat)


test_that("hobocleaner removes duplicates and formats date correctly", {
  df <- data.frame(
    X = c(1, 2, 3, 4),
    Date = c('2024-06-01 12:00:00', '2024-06-01 12:00:00', '2024-06-01 12:01:00', '2024-06-01 12:02:00'),
    Value1 = c(1, 1, 2, 3),
    Value2 = c(4, 4, 5, 6),
    Value3 = c(2, 1, 3, NA)
  )
  cleaned_df <- hobocleaner(df, format = "ymd")
  expect_equal(nrow(cleaned_df), 3)
  expect_true(any(class(cleaned_df$Date) == "POSIXt"))
})

test_that("hobocleaner handles different date formats", {
  df <- data.frame(
    X = c(1, 2, 3, 4),
    Date = c('2024-06-01 12:00:00', '2024-06-01 12:00:00', '2024-06-01 12:01:00', '2024-06-01 12:02:00'),
    Value1 = c(1, 1, 2, 3),
    Value2 = c(4, 4, 5, 6),
    Value3 = c(2, 1, 3, NA)
  )
  
  cleaned_mdy <- hobocleaner(df, format = "ymd")
  expect_true(any(class(cleaned_mdy$Date) == "POSIXt"))
  
  df$Date <- c('06-01-2024 12:00:00', '06-01-2024 12:00:00', '06-01-2024 12:01:00', '06-01-2024 12:02:00')
  cleaned_ymd <- hobocleaner(df, format = "mdy")
  expect_true(any(class(cleaned_ymd$Date) == "POSIXt"))
  expect_message(hobocleaner(df, format = "mdy"))
  
  
  df$Date <- c('01/06/2024 12:00:00', '01/06/2024 12:00:00', '01/06/2024 12:01:00', '01/06/2024 12:02:00')
  cleaned_dmy <- hobocleaner(df, format = "dmy")
  expect_true(any(class(cleaned_dmy$Date) == "POSIXt"))
  expect_message(hobocleaner(df, format = "dmy"))
  
  df$Date <- c('24-06-01 12:00:00', '24-06-01 12:00:00', '24-06-01 12:01:00', '24-06-01 12:02:00')
  cleaned_yymd <- hobocleaner(df, format = "yymd")
  expect_true(any(class(cleaned_yymd$Date) == "POSIXt"))
  expect_message(hobocleaner(df, format = "yymd"))
})

test_that("hobocleaner handles empty data frames", {
  df <- data.frame(X= numeric(),Date = character(), Value1 = numeric(), Value2 = numeric())
  expect_warning(hobocleaner(df, format = "ymd"))
})

test_that("hobocleaner handles data frame without date", {
  df <- data.frame(X = c(1,2,3), Value1 = c(1, 2, 3), Value2 = c(4, 5, 6))
  expect_error(hobocleaner(df, format = "ymd"), "Date not found")
})


test_that("clean hobo data", {
  df <- data.frame(
    X = c(1, 2, 3, 4),
    Date = c('2024-06-01 12:00:00', '2024-06-01 12:00:00', '2024-06-01 12:01:00', '2024-06-01 12:02:00'),
    Wetness = c(1, 1, 2, 3),
    Temp = c(4, 4, 5, 6),
    Rain = c(2, 1, 3, NA)
  ) 
  
  cleaned_df <- hobocleaner(df, format = "ymd")
  
  # Check if the result is a data frame
  expect_true(is.data.frame(cleaned_df))
  
  # Check if the data frame is not empty
  expect_gt(nrow(cleaned_df), 0)
  
  # Check if the data frame has expected columns
  expect_named(cleaned_df, c("Date", "Wetness", "Temp", "Rain"))
})
