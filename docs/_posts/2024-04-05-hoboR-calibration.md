# HOBOR::Calibration 

## Calibration set up set up in a controlled environment.
Before setting up hobos in the field, it is important to know the difference between data loggers by recording the difference variation among individual devices. Acknowledging this can be crucial for testing small environmental differences, such as how differences in weather variables affect the microbial composition in the tree canopy. 

To calibrate the HOBO data loggers, you need to put all the data loggers in an incubator or control environment to control temperature, humidity, or any other measurement you need to calibrate. If you do not have access to a control environment device, leave them in a location with similar conditions for several days. Make sure the hobos are not directly exposed to sunlight. Be aware that HOBO data loggers can be set to work with channels to record min, max, and mean values for each of the measurements for the recorded data.

Once you collect the data from the data loggers, you can use the hobor function `calibration()` to calculate the differences and the function `correction()` to correct the data logger measurements in your experimental data record.

## Usage
Load `library(hobor)` and then continue setting the `path` to your calibration files. For example, if you have 20 HOBO loggers, you need to add a folder with the CSV files in its unique folder, e.g., hobo1, hobo2, hobo3, ... hobo20, for each data logger from your calibration experiment. It is recommended that you inspect your files to make sure you have the information you need for the calibration. 

```R
# Set the path
path = "~/path/to/calibration/files/"
# Sanity check that the path exists
file.exists(path) # must be TRUE otherwise, check if you are in the correct folder
# Create a vector with your folder names 
folder=paste0(rep("hobo", 24), 1:24)
```
Now that you set the path and the folder contents, you need to iterate over the files to create a list of your HOBO csv data.

```R
# Create an empty list to feed through looping to your data
pathtoread=calibrationfiles=hobocleaned=data=list()

for (i in seq_along(folder)){
pathtoread[[i]] <- paste0(path, folder[i])
# Loading all hobo files
calibrationfiles[[i]] <- hobinder(as.character(pathtoread[i]), channels = "ON" ) # channels is a new feature
data[[i]] <- hobocleaner(calibrationfiles[[i]], format = "ymd")
}
# Check the content of you list, it will results on the csv on hobo2
data[[2]]
```
Now that you created the list with all your hobos, the function `calibrator()`, 
expect that you provide the columns for the measurements to calibrate, as well as 
the set of time ranges to calculate the difference between your data loggers.
These times would correspond to the experiment you made in a controlled environment. 

```R
# Columns to analyze
measurements <- c(2, 7, 12)
# Selected times
times <- c("2022-03-22 01:00", "2022-03-22 02:00", "2022-03-22 03:00", "2022-03-22 04:00","2022-03-22 05:00", "2022-03-22 06:00", "2022-03-22 07:00", "2022-03-22 08:00","2022-03-22 09:00")

calibrationmeans <- calibrator(data, columns= measurements, times = times)
```
The result of `hobor::calibrator()` is the difference of hobo1 compared to hobo2,
until completed the comparison. This difference shows the deviation of each hobo
from the others.
You can evaluate if the correction of your data loggers is as expected. We
recommend allowing a variability of less than 1°C.
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

### Handling errors
If the data list throws Warnings, you can use `testhobolist(data, times)` to check if the data logger has missing data or errors. 
