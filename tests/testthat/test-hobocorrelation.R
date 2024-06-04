library(hoboR)
library(testthat)

test_that("check impossible values from hobo data", {
  
  test <- hobocorrelations(hobocleaned, summariseby = "week", by = "mean", na.rm = F)
  
  # Check if the result is a data frame
  expect_true(is.ggplot(test))
  
  # Check if the data frame is not empty
  expect_gt(nrow(test$data), 0)
  
  # Check if the data frame has expected columns
  expect_named(test$data, c("Var1", "Var2", "value"))
  
  # Check if the data frame has data loaded from files
  expect_true(all(file.exists(files)))
})
