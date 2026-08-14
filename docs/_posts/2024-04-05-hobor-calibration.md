## Calibration setup in a controlled environment.
Knowing the variation among individual HOBO devices is crucial before placing them in the field. This is especially true for microclimate studies, where the differences between the environments could be very small, and you would avoid misinterpreting the weather data from the device variance. So, a pre-field calibration step is crucial to correct the differences between the HOBO devices for each environmental variable.  

To calibrate the HOBO devices, you need to put all the devices in an incubator or control environment to have a consistent temperature, humidity, or any other measurements you need to calibrate. If you cannot access a control environment device, leave it in a location with similar conditions for several days. Make sure the hobos are not exposed directly to sunlight. HOBO devices can be set to work with channels  (i.e., MX2301A,https://www.onsetcomp.com/products/data-loggers/mx2301a) to record min, max, and mean values for each of the measurements for the recorded data.

Once you collect the data from the data loggers, you can use the hoboR function `calibrator()` to calculate the differences and the function `correction()` to correct the weather measurements recorded from the field plots.

## Usage
Load `library(hoboR)` and then continue setting the `path` to your calibration files. For example, if you have 24 HOBO loggers, you need to create a unique folder for each HOBO, e.g., hobo1, hobo2, hobo3, ... hobo24, and then put all the CSV files from the same HOBO in its unique folder. We recommend inspecting the files to confirm you have the information needed for the calibration.

Install packages from CRAN
```R
install.packages("hoboR")
library(hoboR)
````

```R
# Set the path
path <- system.file("extdata/calibration", package = "hoboR")
# Sanity check that the path exists
file.exists(path) # must be TRUE otherwise, check if you are in the correct folder
# Create a vector with your folder names 
folder=paste0(rep("canopy", 5), 1:5)
# Change "hobo" to the folder names, and match the number of HOBOs to calibrate. 
# > Confirm folder name matches the vector.
```

Now that you set the path and the folder contents, you need to iterate over the files to create a list of your HOBO csv data.

```R
# Create an empty list to feed through looping to your data
pathtoread = dat = data = list()
 
for (i in seq_along(folder)){
   pathtoread[[i]] <- paste0(path, "/",folder[i])
   # Loading all hobo files
   dat[[i]] <- hobinder(as.character(pathtoread[i]), header = TRUE, skip = 0,
    channels = "ON" ) # channels is a new feature
   data[[i]] <- hobocleaner(dat[[i]], format = "mdy")
}
# Check the content of your list, it will call out the csv from HOBO2
data[[2]]
```
Now that you created the list with all your hobos, the function `calibrator()`, expect that you provide the columns for the measurements to calibrate, as well as the set of time ranges to calculate the difference between your data loggers.
These times would correspond to the experiment you made in a controlled environment. 

```R
# Select the weather variables 
variables <- c(2, 7, 12) # Select the weather variables 
# Make sure you enter the date & time format exactly the same 
# for example 2022-03-22 01:00, instead of 1:00 for 1am.
times <- c("2022-03-22 01:00", "2022-03-22 02:00", "2022-03-22 03:00", 
            "2022-03-22 04:00", "2022-03-22 05:00", "2022-03-22 06:00", 
            "2022-03-22 07:00", "2022-03-22 08:00", "2022-03-22 09:00") 
```

The function `calibrator()` calculates the average difference between multiple data loggers and the first logger in the list, which is used as the reference logger. The function estimates the average values for each data logger relative to the reference. 

These differential values can later be used with `correction()` or `calibrator()` to standardize all data loggers to the same baseline.

```R
calibrationmeans <- calibrator(data, columns= variables, times = times) 
calibrationmeans
```

All data loggers should contain measurements collected during the same calibration experiment and have the same number of records for the selected time range. HOBOs with different numbers of records will trigger a warning message. Missing HOBO folders are skipped and will appear as "NaN" in the calibrator() output.

By selecting the threshold variables, the function will evaluate if the  variability of the correction data is as expected. The results will show that the HOBO data loggers passed the test.

> Preferably allow a variability of less than 1°C.

```R
correction.test(list.data=data, calibrationfile=calibrationmeans, w.var = c(2, 7, 12), 
                times = times, threshold = c(1, 5, 10))
```

To correct the data, the function correction() applies the calibration diffrence to the measurements collected by HOBO data loggers in your experimental site.

There are two alternatives to correct the data. The first option is to correct a single weather variable from a single HOBO data logger. In the next example, HOBO2 is corrected using the temperature calibration offset.

```R
# Individual corrections
# Change the object "data" to your combined HOBO file name
calibratedfiles <- correction(data, w.var = "Temperature.C.", calibrate = "0.1089") 

# Multiple corrections
# Use `w.var = FULL` to correct all variables at once.
multicalibratedfiles <- correction(data, w.var = "FULL", calibrate = calibrationmeans) 

# Note:
# Look at the dataframe structures headline.
head(data[[1]])

# Double-check that both weather variables match, use this to match both names.
colnames(calibrationmeans) <- c("Temperature.C.", "RH.C.", "Dew.C.") 
```

### Handling errors
If the data list throws Warnings, you can use `testhobolist(data, times)` to check if the data logger has missing data or errors. 



<p>Funded by:</p>
<img src="{{ site.baseurl }}/images/osu-psu-usda-logo.png" alt="OSU Logo" style="width: 900px;"/>
