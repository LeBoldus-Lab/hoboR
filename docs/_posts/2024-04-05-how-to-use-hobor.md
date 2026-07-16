# How to work with hobor

### For readers
Hobor is an R package to process CSV files from HOBO weather stations and data loggers. The best way to start your project with hoboR, is to organize your CSV files in a single directory for `hobobinder()`, this function that processes all CSV files in the directory. For example, if you have 10 experimental sites or locations, you should have 10 folders, and each folder containing all the CSV corresponding to the recorded time. By having all the files in a single data frame, hobocleaner() can sort all the entries and identify duplicates, often generated while data is retrieved or batteries replaced. In addition, multiple functions can help with subset, summarize, identify impossible values and sensor failures, and the hobomean() function summarize the data using the mean and standard deviation by time intervals of your election. 

Additional functions are provided to calibrate HOBO data loggers by accounting for variability among devices. Using one logger as a reference, the remaining loggers can be calibrated with `correction()` and `calibrate()`. An example analysis is included using weather data and baiting records to evaluate the incidence of sudden oak death in relation to environmental conditions.

### For code

```R
# load the library
install.packages("hoboR")
library(hoboR)
```

## Example
Suppose multiple CSV files in a directory called site A. 

```R
# Change the number for the site
site = "A"
# Add the PATH to your sites for weather data (from hobo)
path = paste0("path/to/your/site_", site)
# make sure the path to your CSV files exists
file.exists(path)        # this will return a logical value TRUE
```

All the CSV from site A are merged with `hobinder()`, note that some HOBO files format are different. 
Inspect you file, and choose how many rows you need to skip to read the columns.
```R
# loading all hobo files
hobofiles <- hobinder(path, skip=1)
```
After merging, `hobocleaner()` adjusts to different dataset formats. For example, some data loggers record only rain, temperature and relative humidity, whereas other weather stations may also include variables such as wind speed and atmospheric pressure. The function automatically adapts to these formats, removes duplicated records, and rename columns using standardized weather variable names. In addition, the `date.format` argument must match the format used in the HOBO file. For example, "ymd" corresponds to YYYY/MM/DD, "myd" to MM/YYYY/DD", and "yymd" to two-digit year format YY/MM/DD. Be careful when selecting the date format, as an incorrect format may result in incorrect date parsing.
```R
# cleaning hobo files, add format
hobocleaned <- hobocleaner(hobofiles, format = "ymd")
head(hobocleaned)
tail(hobocleaned)
```
The clean data can be aggregated by time interval, e.g. "5 mins", "12 h", "1 day", etc., by using hobotime(), or obtaining the mean, the minimum and maximum, and the rest of summary statistcs by implementing meanhobo().
```R
# getting hobo mean summary by time
hobot <- hobotime(hobocleaned, summariseby = "5 mins", na.rm = T)
head(hobot)

# getting hobo means by date
hobomeans <- meanhobo(hobocleaned, summariseby = "1 day",  na.rm = T)
head(hobomeans)
```

## Additional features
Additional functions can be used to further analyze, subset or summarize the data, such as `horange()` to specify a window range, `timestamp()` to obtain a snapshot of a time interval, `impossiblevalues()` to identify sensor failures, and `sensorfailures()` to identify sensor failures.
```
# specify a window range 
horange(hobocleaned, start="2022-06-04", end="2022-10-22")

# snapshot of a time interval 
timestamp(hobocleaned, stamp = "2022-08-05 00:01", by = "24 hours",
          days = 100, na.rm = TRUE, plot = T, var = "Temp")

# obtain the maximum and minimum values
impossiblevalues(hobocleaned, showrows = 3)

# identify sensor failures
na_data <- sensorfailures(hobocleaned, condition = ">", threshold = c(50, 3000, 101), opt = c("Temp", "Rain", "Wetness"))
```


## Get plots  
An example to get `ggplot` with the weather data, for one and two variables. Using third party packages the user has more control about the style, color and format of the data. 

```R
library(ggplot2)
library(scales)

# Plot one variable: temperateure
ggplot(hobocleaned, aes(x=as.POSIXct(Date), y = Temp)) +
  geom_line(alpha= 0.5) +
  scale_y_continuous( name = "Temperature °C")+
  ggtitle("Temperature: Oct 14 - Nov 11, 2021")+
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_x_datetime(labels = date_format("%Y-%m-%d"))+
  theme_bw()

# two vars
ggplot(hobocleaned, aes(x=as.POSIXct(Date))) +
  geom_line( aes(y=Temp, col = "red"), alpha = 0.5) + 
  geom_line( aes(y= Wetness, col = "blue"), alpha = 0.5) + 
  scale_y_continuous(
    # Features of the first axis
    name = "Temperature °C",
    # Add a second axis and specify its features
    sec.axis = sec_axis(~., name="Humidity")
  ) +
  labs(title = "Temperature: Oct 14 - Nov 11, 2021", color = "Legend") +
  scale_color_manual(labels = c("Humidity", "Temp"), values = c("blue", "red")) +
  scale_x_datetime(labels = date_format("%Y-%m-%d"))+
  theme_bw()
```

There is a function to analyze the correlation between the weather variables
```R
# hobo data correlation
hobocorrelations(hobocleaned, summariseby = "month", by = "mean", na.rm = F)
```
Here you can check with the function heatmap
```
heatmap(cor(as.matrix(hobocleaned[,2:4])))
test <- na.omit(hobocleaned[,2:5])
cor(test)|>
  heatmap(Colv=NA, Rowv=NA)
```


<p>Funded by:</p>
<img src="../images/osu-psu-usda-logo.png" alt="OSU Logo" style="width: 900px;"/>
