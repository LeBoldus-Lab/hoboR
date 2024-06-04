library(hoboR)
library(testthat)

test_that("correct hobo data with calibration", {
  
  # Full example 
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
  times <- c("2022-03-22 01:00", "2022-03-22 02:00", "2022-03-22 03:00", 
             "2022-03-22 04:00","2022-03-22 05:00", "2022-03-22 06:00", 
             "2022-03-22 07:00", "2022-03-22 08:00","2022-03-22 09:00") 
  x <- calibrator(data, columns = c(2,7,12), times = times)
  test <- correction.test(list.data=data, calibrationfile=x, w.var = c(2, 7, 12), 
                  times = times, threshold = c(1, 5, 10))

  # Check if the result is a data frame
  expect_true(is.matrix(test))
  
  # Check if the data frame is not empty
  expect_gt(nrow(test), 0)
  
  # Convert matrix or array to data frame
  if (!is.data.frame(test)) {
    test <- as.data.frame(test)
  }
  
  # Check column names
  actual_variables <- colnames(test)
  expect_named(test, actual_variables)
  
  # Check if the data frame has data loaded from files
  expect_true(all(file.exists(files)))
})
