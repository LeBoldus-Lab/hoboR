library(hoboR)
library(testthat)

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

# Check if the result is a matrix
test <- testhobolist(data, "2022-03-22")

test_that("load hobo data with multiple files", {
  
  expect_true(is.matrix(test))
  
  # Check if the data frame is not empty
  expect_gt(nrow(test), 0)
  
  # Check if the data frame has expected columns
  expect_named(as.data.frame(test), c("Total entries", "Present entries"))
})
