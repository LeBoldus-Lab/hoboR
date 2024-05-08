## Calibration set up set up in a controlled environment.
Before placing HOBO devices in the field, it is important to know the variation among individual devices. Especially for microclimate studies, because the differences between the environments could be very small, and you would avoid misconducting the weather data from the device variance. So a pre-field calibration is crucial to know the differences between your hobo devices for each environmental variable.  

To calibrate the HOBO devices, you need to put all the devices in an incubator or control environment to have consistent temperature, humidity, or any other measurements you need to calibrate. If you do not have access to a control environment device, leave them in a location with similar conditions for several days. Make sure the hobos are not directly exposed to sunlight. Be aware that some HOBO devices (i.e.MX2301A,https://www.onsetcomp.com/products/data-loggers/mx2301a) can be set to work with channels to record min, max, and mean values for each of the measurements for the recorded data.

Once you collect the data from the data loggers, you can use the hoboR function `calibration()` to calculate the differences and the function `correction()` to correct the weather measurements recorded from the field plots.

## Usage
Load `library(hoboR)` and then continue setting the `path` to your calibration files. For example, if you have 24 HOBO loggers, you need to create a unique folder for each HOBO, e.g., hobo1, hobo2, hobo3, ... hobo24, then put all the CSV files from the same HOBO in its unique folder. It is recommended that you inspect your files to make sure you have the information you need for the calibration. 

```R
# Set the path
path = "~/path/to/calibration/files/" # change to your directory
# Sanity check that the path exists
file.exists(path) # must be TRUE otherwise, check if you are in the correct folder
# Create a vector with your folder names 
folder=paste0(rep("hobo", 24), 1:24)
# Change "hobo" to the words you name for the folders.
# Change 24 to the total number of HOBO that you have in the calibration. 
# Make sure the name of your folder matches the vector created here.
```
Now that you set the path and the folder contents, you need to iterate over the files to create a list of your HOBO csv data.

```R
# Create an empty list to feed through looping to your data
pathtoread=calibrationfiles=hobocleaned=data=list()

for (i in seq_along(folder)){
pathtoread[[i]] <- paste0(path, folder[i])
# Loading all hobo files
calibrationfiles[[i]] <- hobinder(as.character(pathtoread[i]), channels = "ON" ) # channels is a new feature
data[[i]] <- hobocleaner(calibrationfiles[[i]], format = "ymd") # change the format to "mdy" if your DateTime format is MM/DD/YYYY
}
# Check the content of your list, it will call out the csv from HOBO2
data[[2]] 
```
Now that you created the list with all your hobos, the function `calibrator()`, 
expect that you provide the columns for the measurements to calibrate, as well as 
the set of time ranges to calculate the difference between your data loggers.
These times would correspond to the experiment you made in a controlled environment. 

```R
# Columns to analyze
measurements <- c(2, 7, 12) # Select the weather variables 
# Selected times
times <- c("2022-03-22 01:00", "2022-03-22 02:00", "2022-03-22 03:00", "2022-03-22 04:00","2022-03-22 05:00", "2022-03-22 06:00", "2022-03-22 07:00", "2022-03-22 08:00","2022-03-22 09:00") # Make sure you enter the date & time format with zeros, for example 08:00 instead of 8:00 for 8am.

calibrationmeans <- calibrator(data, columns= measurements, times = times) # for the hobo(s) with different length datasets, you will see a warning message. That HOBO won't be calculated, so you will see it as "NaN" when you call out the "calibrationmeans". For that HOBO you have to calculate the numbers manually, then add the numbers to "calibrationmeans" when applying the correction to the field collected data. 
calibrationmeans

# Manually add the calculated HOBO numbers (i.e. HOBO15) into "calibrationmeans", if any.
calibrationmeans[15,] <- c(-0.003056, 0.48528, 0.38472)  
```
The result of `hobor::calibrator()` is the difference of hobo1 compared to HOBO2,
until completed the comparison. We use HOBO1 as the baseline, and these differences show the differences of each hobo
from the baseline HOBO (which is HOBO1 here).
You can evaluate if the correction of your data loggers is as expected. We
recommend allowing a variability of less than 1°C.
```R
correction.test(list.data=data, calibrationfile=x, columns = c(2, 7, 12), 
                times = times, threshold = c(1, 5, 10))
```

While you have your field data collected, use `hobor::hobinder()` and `hobor::hobocleaner()` to combine multiple csv files if you have downloaded the data multiple times. Then you can export the combined data as a separate csv file for correction and further analysis.

Then, you need to correct your data using `hobor::correction()` to calibrate your 
measurements between the HOBO devices after collecting data in your experiment site.

Here are two ways for corrections. If you want to correct the temperature measurements of another single HOBO, for example HOBO2, you can use the 
temperature for hobo2, `calibrationmeans[2,1]`. 
```R
# Individual corrections
calibratedfiles <- correction(data, w.var = "Temperature", calibrate = "0.1089") # Change "data" to your combined HOBO file name
```
Or, if you have plenty of HOBO devices, you can also calibrate all measurements and all the HOBO devices at once, just make sure your calibration files match the names of your data.

First of all, you will have to combine the datasets from all the HOBOs as one file. To do this, use `hobor::hobinder()` and `hobor::hobocleaner()` to combine multiple csv files from the same HOBO device and export as an individual csv file. Then, create a folder and drag all the combined csv files from all HOBO devices to the unique folder.

```R
# Set path directories
path_all = "~/Desktop/testsky/correction_files"

# Check files
file.exists(path_all)
list.files(path_all)

# Load the combined field files, already processed with `hobinder` and `hobocleaner`.  

# This is a generic way to load multiple csv files
files <- list.files(path=path_all, pattern = "\\.csv", full.names = T)
field <- lapply(files, function(x) {
  read.csv(x)})
```

Then you need to check out the structure of the pooled dataframe before applying `hobor::correction()`

```R
# Look at the dataframe structures and headline.
field[[1]]

# Add column names to "calibrationmeans" you created before, so the headline matches the field dataframe.
colnames(calibrationmeans) <- c("Temperature", "RH", "Dew") # Change to fit your weather variables
```

Now use `hobor::correction()` to correct everything in once. 

```R
# Multiple corrections
multicalibratedfiles <- correction(field, w.var = "FULL", calibrate = calibrationmeans) # Change "field" to your data name
```

### Handling errors
If the data list throws Warnings, you can use `testhobolist(data, times)` to check if the data logger has missing data or errors. 



<p>Funded by:</p>
<img src="images/osu-usda-logo.png" alt="OSU Logo" style="width: 900px;"/>
