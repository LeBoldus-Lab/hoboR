library(hoboR)
library(testthat)

test_that("summarise hobo data using a time interval", {
  
  subset <- hobotime(hobocleaned, summariseby = "30 mins", na.rm = T)
  
  # Check if the result is a data frame
  expect_true(is.data.frame(subset))
  
  # Check if the data frame is not empty
  expect_gt(nrow(subset), 0)
  
  # Check if the data frame has expected columns
  expect_named(subset, c("Date", "Wetness", "Temp", "RH", "Rain"))
  
  # Check if the data frame has data loaded from files
  expect_true(all(file.exists(files)))
})
