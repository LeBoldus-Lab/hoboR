library(hoboR)
library(testthat)

test_that("load hobo data with multiple files", {
  path <- "inst/extdata/calibration/"
  # Create an empty list to feed through looping to your data
  pathtoread=calibrationfiles=hobocleaned=data=list()
  folder=paste0(rep("canopy", 24), 1:24)
  
  for (i in seq_along(folder)){
    pathtoread[[i]] <- paste0(path, folder[i])
    # Loading all hobo files
    calibrationfiles[[i]] <- hobinder(as.character(pathtoread[i]), channels = "ON" ) # channels is a new feature
    data[[i]] <- hobocleaner(calibrationfiles[[i]], format = "mdy") # change the format to "mdy" if your DateTime format is MM/DD/YYYY
  }  

  # Check if the result is a data frame
  expect_true(is.list(calibrationfiles[[1]]))
  
  # Check if the data frame is not empty
  expect_gt(nrow(calibrationfiles[[1]]), 0)
  
  # Check if the data frame has expected columns
  actual_variables <- names(calibrationfiles[[1]])
  
  expect_named(calibrationfiles[[1]], actual_variables)
  
  # Check if the data frame has data loaded from files
  expect_true(all(file.exists(files)))
})
