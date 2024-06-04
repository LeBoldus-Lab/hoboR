library(hoboR)
library(testthat)

test_that("select hobo data using a time interval", {
  
  df.range <- hoborange(hobocleaned, start="2022-08-08", end="2022-12-12")
  
  # Check if the result is a data frame
  expect_true(is.data.frame(df.range))
  
  # Check if the data frame is not empty
  expect_gt(nrow(df.range), 0)
  
  # Check if the data frame has expected columns
  expect_named(df.range, c("Date", "Wetness", "Temp", "RH", "Rain"))
  
  # Check if the data frame has data loaded from files
  expect_true(all(file.exists(files)))
})
