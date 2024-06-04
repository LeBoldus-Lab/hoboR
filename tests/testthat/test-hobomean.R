library(hoboR)
library(testthat)

test_that("get summary statistics of hobo data using a time interval", {
  
  stats <- meanhobo(subset, summariseby = "1 day",  na.rm = T)
  
  # Check if the result is a data frame
  expect_true(is.data.frame(stats))
  
  # Check if the data frame is not empty
  expect_gt(nrow(stats), 0)
  
  # Check if the data frame has expected columns
  expect_named(stats, c("Date", "x.Wetness", "sd.Wetness", "sum.Rain", "x.Temp", 
                        "sd.Temp", "x.RH", "sd.RH", "x.Rain", "sd.Rain"))
  
  # Check if the data frame has data loaded from files
  expect_true(all(file.exists(files)))
})
