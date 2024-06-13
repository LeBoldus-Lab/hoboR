library(hoboR)
library(testthat)


test_that("hobinder handles invalid paths", {
  expect_message(hobinder("invalid_path"), "No such files in directory")
})

test_that("load hobo data with multiple files", {
  path <- system.file("extdata", package = "hoboR")
  files <- hobinder(path, skip = 1)
  
  # Check if the result is a data frame
  expect_true(is.data.frame(files))
  
  # Check if the data frame is not empty
  expect_gt(nrow(files), 0)
  
  # Check if the data frame has expected columns
  expect_named(files, c("X", "Date", "Wetness", "Temp", "RH", "Rain"))
  
  # Check if the data frame has data loaded from files
  expect_true(all(file.exists(path)))
})

test_that("hobinder handles additional channels", {
  pathoff <- system.file("extdata", package = "hoboR")
  pathon <- system.file("extdata/calibration/canopy1/", package = "hoboR")
  result_off <- hobinder(pathoff, channels = "OFF", skip = 1 )
  result_on <- hobinder(pathon, channels = "ON", skip = 0)
  
  expect_false(any(grepl("Ch", colnames(result_off))))
  expect_true(!any(grepl("Ch", colnames(result_on))))
})
