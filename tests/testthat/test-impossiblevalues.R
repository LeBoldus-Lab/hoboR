library(hoboR)
library(testthat)

test_that("check impossible values from hobo data", {
  
  values <- impossiblevalues(hobocleaned, showrows = 3)
  
  # Check if there is a message
  f <- function(x) {
    if (x < 0) {
      message("The max value *x*")
      return(x)
    }
  }  
  expect_message(f(-1))  
  
  # Check if the result is a data frame
  expect_true(is.data.frame(values))
  
  # Check if the data frame is not empty
  expect_gt(nrow(values), 0)
  
  # Check if the data frame has expected columns
  expect_named(values, c("Wetness", "Temp", "RH", "Rain"))
  
  # Check if the data frame has data loaded from files
  expect_true(all(file.exists(files)))
})
