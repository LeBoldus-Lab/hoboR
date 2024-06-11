library(hoboR)
library(testthat)
library(testthat)
library(dplyr)

# Sample data for testing
df <- data.frame(
  Date = as.POSIXct(c(
    '2023-06-01 00:00:00', '2023-06-01 01:00:00', '2023-06-01 02:00:00',
    '2023-06-02 00:00:00', '2023-06-02 01:00:00', '2023-06-02 02:00:00'
  )),
  Temp = c(15, 35, 14.5, 17, 33, 32.5),
  Humidity = c(50, 55, 52, 53, 58, 57),
  Rain = c(0, 10, 5, 2, 1, 15)
)


test_that("sensorfailures replaces values correctly with condition >", {
  result <- sensorfailures(df, condition = ">", threshold = c(34, 8), w.var = c("Temp", "Rain"))
  expect_equal(sum(is.na(result$Temp)), 1)
  expect_equal(sum(is.na(result$Rain)), 2)
})

test_that("sensorfailures handles multiple weather variables", {
  result <- sensorfailures(df, condition = ">", threshold = c(34, 8), w.var = c("Temp", "Rain", "Humidity"))
  expect_equal(sum(is.na(result$Temp)), 1)    
  expect_equal(sum(is.na(result$Rain)), 2)   
  expect_equal(sum(is.na(result$Humidity)), 0) 
})

test_that("sensorfailures handles invalid weather variables", {
  expect_error(sensorfailures(df, condition = ">", threshold = c(34, 8), w.var = c("InvalidVar")), "One or more weather variables do not exist")
})

test_that("sensorfailures works with different conditions", {
  result_less <- sensorfailures(df, condition = "<", threshold = c(16, 5), w.var = c("Temp", "Rain"))
  expect_equal(sum(is.na(result_less$Temp)), 2) 
  expect_equal(sum(is.na(result_less$Rain)), 3) 
  
  result_equal <- sensorfailures(df, condition = "==", threshold = c(15, 10), w.var = c("Temp", "Rain"))
  expect_equal(sum(is.na(result_equal$Temp)), 1) 
  expect_equal(sum(is.na(result_equal$Rain)), 1)
})

test_that("sensorfailures handles empty data frame", {
  empty_df <- data.frame(Date = as.POSIXct(character()), Temp = numeric(), Humidity = numeric(), Rain = numeric())
  result <- sensorfailures(empty_df, condition = ">", threshold = c(34, 8), w.var = c("Temp", "Rain"))
  expect_equal(nrow(result), 0)
})

test_that("sensorfailures handles no matching conditions", {
  result <- sensorfailures(df, condition = ">", threshold = c(100, 100), w.var = c("Temp", "Rain"))
  expect_equal(sum(is.na(result$Temp)), 0) # No values should be NA
  expect_equal(sum(is.na(result$Rain)), 0) # No values should be NA
})
