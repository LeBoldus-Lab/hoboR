library(hoboR)
library(testthat)

test_that("check impossible values from hobo data", {
  
  failures <- sensorfailures(hobocleaned, condition = ">", 
                             threshold = c(50, 3000, 101), 
                             opt = c("Temp", "Rain", "Wetness"))  
  
  # Check if the result is a data frame
  expect_true(is.data.frame(failures))
  
  # Check if the data frame is not empty
  expect_gt(nrow(failures), 0)
  
  # Check if the data frame has expected columns
  expect_named(failures, c("Date", "Wetness", "Temp", "RH", "Rain"))
  
  # Check if the data frame has data loaded from files
  expect_true(all(file.exists(files)))
})
