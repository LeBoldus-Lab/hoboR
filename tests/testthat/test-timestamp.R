library(hoboR)
library(testthat)

test_that("plot hobo data time interval", {
  
  range <- timestamp(hobocleaned, stamp = "2022-08-05 00:01", by = "24 hours",
                 days = 100, na.rm = FALSE, plot = T, var = "Temp")  
  # Check if the result is a data frame
  expect_true(is.data.frame(range))
  
  # Check if the data frame is not empty
  expect_gt(nrow(range), 0)
  
  # Check if the data frame has expected columns
  expect_named(range, c("Date", "Wetness", "Temp", "RH", "Rain"))
  
  # Check if the data frame has data loaded from files
  expect_true(all(file.exists(files)))
})
