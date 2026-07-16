# Example code to correct hobos 

# Install the hoboR package from CRAN
```
install.packages("hoboR")
library(hoboR)
```
HOBO data loggers have inherent variability in the data collection process, which can be assessed and corrected using the `calibrator()` and `correction()` functions. Identifying variability among HOBO devices before deployment helps detect malfunctioning units and estimate correction factors when possible. This is particularly important in microclimate studies, where differences between environments can be small and device variability may lead to misinterpretation of weather data. Conducting a calibration experiment under controlled conditions before deploying the loggers helps standardizemeasurements and reduce differences among HOBO devices.

To calibrate the HOBO devices, place all data loggers in an incubator or other controlled environment where temperature, relative humidity, or other variables of interest remain stable. If a controlled environment is not available, place the loggers together in a location with similar environmental conditions for several days. Avoid exposing the devices to direct sunlight during the calibration period.

Additionally, the recording channels in the HOBO data loggers should be configured before starting the calibration experiment (e.g., the HOBO [MX2301A](https://www.onsetcomp.com/products/data-loggers/mx2301a)). Enabling the minimum, maximum, and mean recording options for each measurement will provide additional information that can be used during calibration and data analysis.

Once you collect the data from the data loggers, you can use the hoboR function calibration() to calculate the differences and the function correction() to correct the weather measurements recorded from the field plots.

# Usage

Load library(hoboR) and then continue setting the path to your calibration files. For example, if you have 24 HOBO loggers, you need to create a unique folder for each HOBO, e.g., hobo1, hobo2, hobo3, … hobo24, and then put all the CSV files from the same HOBO in its unique folder. We recommend inspecting the files to confirm you have the information needed for the calibration.

### ---- CALIBRATION STEP 1: Load the data
```R
# Set path directories
path <- system.file("extdata/calibration", package = "hoboR")
# Sanity check that the path exists
file.exists(path) # must be TRUE otherwise, check if you are in the correct folder
# Create a vector with your folder names 
folder=paste0(rep("canopy", 5), 1:5)
# Change "hobo" to the folder names, and match the number of HOBOs to calibrate. 
```
> Confirm folder name matches the vector.

Now that you set the path and the folder contents, you need to iterate over the files to create a list of your HOBO data (.csv files).

### For loop to iterate over all the HOBO devices 
```R
pathtoread = dat = data = list()
 
for (i in seq_along(folder)){
   pathtoread[[i]] <- paste0(path, "/",folder[i])
   # Loading all hobo files
   dat[[i]] <- hobinder(as.character(pathtoread[i]), header = TRUE, skip = 0,
    channels = "ON" ) # channels is a new feature
   data[[i]] <- hobocleaner(dat[[i]], format = "mdy")
}
```
Print out the list 2 file 2, `data[[2]]`. The `list` has 5 elements corresponding to 5 HOBO devices, each `data.frame`.

```R
data[[2]]
```

The list containing all HOBO data loggers is processed with calibrator(), expecting the columns to correspond to the
measurements to calibrate and the times set used to calculate the differences among data loggers. These times should correspond to the calibration experiment conducted under controlled conditions.

Enter the date & time format exactly as the HOBO data, for example 2022-03-22 01:00, instead of just 1:00 for 1am.
```R
times <- c("2022-03-22 01:00", "2022-03-22 02:00", "2022-03-22 03:00", 
            "2022-03-22 04:00", "2022-03-22 05:00", "2022-03-22 06:00", 
            "2022-03-22 07:00", "2022-03-22 08:00", "2022-03-22 09:00")
```
Select the target columns corresponding to the weather variables.
```R
variables <- c(2, 7, 12) 
```
### CALIBRATION STEP 1:
The function calibrator() calculates the average difference between multiple data loggers and the first logger in the list, which is used as the reference logger. The function estimates the average values for each data logger relative to the reference. These differential values can later be used with correction() or calibrate() to standardize all data loggers to the same baseline.

```R
calibrationmeans <- calibrator(data, columns= variables, times = times) 
calibrationmeans
```
All data loggers should contain measurements collected during the samecalibration experiment and have the same number of records for the selected time range. HOBOs with different numbers of records will trigger a warning message. Missing HOBO folders are skipped and will appear as "NaN" in the calibrator() output.

To evaluate the variability of the weather variables recorded by the data  loggers by using the recorded recorded data, and the results of `calibrator()`. By selecting the threshold variables, the function will evaluate if the  variability of the correction data is as expected. The results will show that the HOBO data loggers passed the test.
> We recommend allowing a variability of less than 1°C.

```R
correction.test(list.data=data, calibrationfile=calibrationmeans, w.var = c(2, 7, 12), 
                times = times, threshold = c(1, 5, 10))
```
### CORRECTION STEP 2: 
To correct the data, the function correction() applies the calibration diffrence to the measurements collected by HOBO data loggers in your experimental site.
There are two alternatives to correct the data. The first option is to correct a single weather variable from a single HOBO data logger. In the next example, HOBO2 is corrected using the temperature calibration offset.

```R
# Individual corrections
# Change the object "data" to your combined HOBO file name
calibratedfiles <- correction(data, w.var = "Temperature.C.", calibrate = "0.1089") 
```

```R
# Multiple corrections
# Use `w.var = FULL` to correct all variables at once.
multicalibratedfiles <- correction(field, w.var = "FULL", calibrate = calibrationmeans) 
```

> Note: Look at the dataframe structures headline`head(field[[1]])`

Double-check that both weather variables match, use this to match both names.
```R
colnames(calibrationmeans) <- c("Temperature.C.", "RH.C.", "Dew.C.")  
```
