# Example code to correct hobos 
# install.packages("devtools")

```
library("devtools")
devtools::install_github("LeBoldus-Lab/hoboR", force = TRUE)

library(hoboR)
```

```
# Set path directories
path1 = "~/Desktop/testsky/calibration/originalfiles/"

path2 = "~/Desktop/testsky/correction_files"
```

### ---- CALIBRATION STEP 1:
```R
# Check files
file.exists(path1)
list.files(path1)

# Create the folder to store the calibrations
folder=paste0(rep("canopy", 24), 1:24)
```
## For loop to iterate over all your HOBO devices

```R
pathtoread=calibrationfiles=hobocleaned=data=list()

for (i in seq_along(folder)){
  pathtoread[[i]] <- paste0(path1, folder[i])
  # loading all hobo files
  calibrationfiles[[i]] <- hobinder(as.character(pathtoread[i]), channels = "ON" ) # channels is a new feature
  data[[i]]=hobocleaned[[i]] <- hobocleaner(calibrationfiles[[i]], format = "mdy")
}
```
Lets print out the list data position 2, `data[[2]]`, the list data, has 24 elements corresponding to 24 HOBO devices.

```R
data[[2]]
```
You have to pick the times when you set up your experiment, in our case was from 01:00 to 09:00 hours.

```R
times <- c("2022-03-22 01:00", "2022-03-22 02:00", "2022-03-22 03:00",                    "2022-03-22 04:00", "2022-03-22 05:00", "2022-03-22 06:00",                    "2022-03-22 07:00", "2022-03-22 08:00", "2022-03-22 09:00")
```
You need to select the target columns, where the weather variable is. 
```R
calibrationresults <- calibrator(data, columns= c(2, 7, 12), times = times)
```
The calibration results, is a dataframe with the mean variation values to correct the experimental csv files. You might need to modify the column names to match between the calibration results, and the experiment values. 

```$
colnames(calibrationresults) <- c("Temperature", "RH", "Dew")
```
Once you proceed to correct the values, you can delimit a threshold to allow a threshold difference.
```R
correction.test(list.data=data, calibrationfile=calibrationresults, columns = c(2, 7, 12), times = times, threshold = 1)
```

## CORRECTION STEP 2:
Set the path for the HOBO experiment
```
# Check files
file.exists(path2)
list.files(path2)
```
Load the experimental files, already processed with `hobinder` and `hobocleaner`.  
```R
# This is a generic way to load multiple csv files
files <- list.files(path=path2, pattern = "\\.csv", full.names = T)
experiment <- lapply(files, function(x) {
  read.csv(x)})
```
There is a single variable calibration, you can choose the weather variable and correction.
```R
# to correct a single variable
exp2=experiment[[2]]
correction(exp2, w.var = "Temperature", calibrate = "0.1088889")
```
Also, there is a full mode, where you can specify `"FULL"` and the calibration file, and it will do a multiple correction for all weather variables.
```R
# to correct multple variables
correction(experiment, w.var = "FULL", calibrate = calibrationresults)
```
