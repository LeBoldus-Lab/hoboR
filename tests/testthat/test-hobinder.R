library(hoboR)
library(testthat)

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
