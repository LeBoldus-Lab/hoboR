# HOBOR::Calibration 

HOBO data loggers can be set work with channels to record min, max and mean values 
for each of the measurements for the recorded data ...

## Calibration set up
First, you need to ..... 

## Usage
Load `library(hoboR)`, and then continue with setting the `path` to your callibration
files. For example, if you have 20 HOBO loggers, you need to add a folder with the
`.csv` file in its unique folder, e.g. hobo1, hobo2, hobo3, ... hobo20, for each 
data logger from your calibration experiment. It is recommended to inspect your
files to make sure you have the information you need for the calibration. 

```R
# Set the path
path = "~/Desktop/testsky/calibration/originalfiles/"
# Sanity check that the path exist
file.exists(path)
# Create the a vector with your folder names 
folder=paste0(rep("canopy", 24), 1:24)
```
Now that you set the path and the folder contents, you need to iterate over the
files to create a list of your HOBO csv data.


```R
# Create an empty list to feed through looping to your data
pathtoread=calibrationfiles=hobocleaned=data=list()

for (i in seq_along(folder)){
pathtoread[[i]] <- paste0(path, folder[i])
# Loading all hobo files
calibrationfiles[[i]] <- hobinder(as.character(pathtoread[i]), channels = "ON" ) # channels is a new feature
data[[i]]=hobocleaned[[i]] <- hobocleaner(calibrationfiles[[i]], format = "ymd")
}
# Check the content of you list, it will results on the csv on hobo2
data[[2]]
```
Now that you created the list with all your hobos, the function `calibrator()`, 
expect that you provide the columns for the measurements to calibrate, as well as 
the a set of time ranges to calculate the differente between your data loggers.
These times would correspond to experiment you made in a control environment. 

```R
# Columns to analyze
measurements <- c(2, 7, 12)
# Selected times
times <- c("2022-03-22 01:00", "2022-03-22 02:00", "2022-03-22 03:00", "2022-03-22 04:00",
           "2022-03-22 05:00", "2022-03-22 06:00", "2022-03-22 07:00", "2022-03-22 08:00",
           "2022-03-22 09:00")

calibrationmeans <- calibrator(data, columns= measurements, times = times)
```
The result of `hobor::calibrator()` is the difference of hobo1 compared to hobo2,
until completed the comparison. This difference shows the deviation of each hobo
to the others.
You can evaluate if the correction of your data loggers is as expected. We
recommend to allow for a variability less than 1°C.
```R
correction.test(list.data=data, calibrationfile=x, columns = c(2, 7, 12), 
                times = times, threshold = c(1, 5, 10))
```

Last, you need to correct your data using `hobor::correction()` to calibrate your 
measurements after collecting data in your experiment site.

If you want to correct the temperature measurements of hobo2, you can use the 
temperature for hobo2, `calibrationmeans[2,1]`. 
```R
# Individual corrections
calibratedfiles <- correction(data, calibration, column = "Temperature", calibrate = "0.1089")
```
You can also calibrate all measurements at once, just make sure your calibration files match the names of your data.
```R
# Multiple corrections
multicalibratedfiles <- correction(data, calibration, column = "FULL", calibrate = USEFILE)
```


