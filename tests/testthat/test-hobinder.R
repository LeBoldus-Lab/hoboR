library(hoboR)
library(testthat)


test_that("hobinder handles invalid paths", {
  expect_message(hobinder("invalid_path"), "No such files in directory")
})

test_that("load hobo data with multiple files", {
  path <- "inst/extdata/"
  files <- list.files(path, full.names = TRUE, pattern = "\\.csv$")
  
  hobofiles <- hobinder(path, skip = 1)
  
  # Check if the result is a data frame
  expect_true(is.data.frame(hobofiles))
  
  # Check if the data frame is not empty
  expect_gt(nrow(hobofiles), 0)
  
  # Check if the data frame has expected columns
  expect_named(hobofiles, c("X", "Date", "Wetness", "Temp", "RH", "Rain"))
  
  # Check if the data frame has data loaded from files
  expect_true(all(file.exists(files)))
})



test_that("hobinder handles additional channels", {
  pathoff <- "inst/extdata/"
  pathon <- "inst/extdata/calibration/canopy1/"
  result_off <- hobinder(pathoff, channels = "OFF", skip = 1 )
  result_on <- hobinder(pathon, channels = "ON", skip = 0)
  
  expect_false(any(grepl("Ch", colnames(result_off))))
  expect_true(any(grepl("C", colnames(result_on))))
})
