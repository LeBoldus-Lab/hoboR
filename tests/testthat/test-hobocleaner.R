library(hoboR)
library(testthat)

test_that("clean hobo data", {
  
  hobocleaned <- hobocleaner(hobofiles, format = "yymd")
  
  # Check if the result is a data frame
  expect_true(is.data.frame(hobocleaned))
  
  # Check if the data frame is not empty
  expect_gt(nrow(hobocleaned), 0)
  
  # Check if the data frame has expected columns
  expect_named(hobocleaned, c("Date", "Wetness", "Temp", "RH", "Rain"))
  
  # Check if the data frame has data loaded from files
  expect_true(all(file.exists(files)))
})
