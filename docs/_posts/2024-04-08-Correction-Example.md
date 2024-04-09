# Example code to correct hobos 
# install.packages("devtools")
library("devtools")
devtools::install_github("LeBoldus-Lab/hoboR", force = TRUE)

library(hoboR)

# Set path directories
path1 = "~/Desktop/testsky/calibration/originalfiles/"

path2 = "~/Desktop/testsky/correction_files"


# ---- CALIBRATION STEP 1:

# Check files
file.exists(path1)
list.files(path1)

# Create the folder to store the calibrations
folder=paste0(rep("canopy", 24), 1:24)

pathtoread=calibrationfiles=hobocleaned=data=list()

for (i in seq_along(folder)){
  pathtoread[[i]] <- paste0(path1, folder[i])
  # loading all hobo files
  calibrationfiles[[i]] <- hobinder(as.character(pathtoread[i]), channels = "ON" ) # channels is a new feature
  data[[i]]=hobocleaned[[i]] <- hobocleaner(calibrationfiles[[i]], format = "mdy")
}
data[[2]]
times <- c("2022-03-22 01:00", "2022-03-22 02:00", "2022-03-22 03:00", "2022-03-22 04:00",
           "2022-03-22 05:00", "2022-03-22 06:00", "2022-03-22 07:00", "2022-03-22 08:00",
           "2022-03-22 09:00")

calibrationresults <- calibrator(data, columns= c(2, 7, 12), times = times)
colnames(calibrationresults) <- c("Temperature", "RH", "Dew")

correction.test(list.data=data, calibrationfile=calibrationresults, columns = c(2, 7, 12), 
                times = times, threshold = 1)


#---- CORRECTION STEP 2:

# Check files
file.exists(path2)
list.files(path2)

# loading processed hobo files with meanhobo()
files <- list.files(path=path2, pattern = "\\.csv", full.names = T)
experiment <- lapply(files, function(x) {
  read.csv(x)})

# to correct a single variable
exp2=experiment[[2]]
correction(exp2, w.var = "Temperature", calibrate = "0.1088889")
# to correct multple variables
correction(experiment, w.var = "FULL", calibrate = calibrationresults)


