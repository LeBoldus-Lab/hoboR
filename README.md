# hoboR
R package for the analysis of  HOBO weather station data.
The HOBO files as CSV, time formats accepted: DD/MM/YYYY, MM/DD/YYYY, YY/MM/DD


## Installation

This project is available on GitHub on `http://github.com/LeBoldus` and can be installed using `devtools`, working on a CRAN version.

Install the following dependencies:
```r
install.packages("dplyr")
install.packages("plyr")
install.packages("lubridate")
install.packages("reshape")
install.packages("ggplot2")
install.packages("devtools")
```

Install using `devtools`
```r
# load library 
library("devtools")
# install from github
devtools::install_github("LeBoldus-Lab/hoboR")
library(hoboR)
```

# Example
Add the PATH to your csv files  
```
path = "/Site_1/"


# loading hobo files 
hobofiles <- hobinder(path, header = T, skip = 1)
tail(hobofiles)
# cleaning hobo files
hobocleaned <- hobocleaner(hobofiles, format = "mdy”) # your files are month day and year "05-01-23" 
                                    # format = "ymd"  # your files are year month and day "20-11-21"
                                    # format = "yymd" # your files are year month and day "2020-11-21" 
tail(hobocleaned)

# summarizing hobo by time intervals 
hobot <- hobotime(hobocleaned, summariseby = "5 mins", na.rm = T)
tail(hobot) 

# retrieve a time interval 
horange(hobocleaned, start="2022-06-04", end="2022-10-22")

# retrieve impossible values
impossiblevalues(hobocleaned)

# transform impossible values to NAs --- This is data dependent
na_data <- NAsensorfailures(hobocleaned, condition = ">", threshold = c(50, 3000, 101), opt = c("Temp", "Rain", "Wetness"))

timestamp(hobocleaned, stamp = "2022-08-05 00:01", by = "24 hours", 
          days = 100, na.rm = TRUE, plot = T, var = "Temp")
          
# getting hobo means by date 
hobomeans <- meanhobo(hobocleaned, summariseby = "24 hours",  na.rm = T)
head(hobomeans)


# plot correlation hobo variables  
horrelation(hobocleaned, summariseby = "month", by = "mean", na.rm = F)


# reading bucke samples
sampling <- read.csv("Bucket_Results_Adj.csv") 
# Calculate the incidence rate  
# n = is the total number of samples collected
samp.rates <- samplingrates(sampling, n = 9, round= 2)

# Get the summary by bates 
summarybybates <- sampling.trends(hobomeans, samp.rates, round = 2)

# Write you new combined data with
write.csv(hobocleaned, "new_hobo_combined_file.csv")
```

Testing roxygen package
```R
roxygen2::roxygenise()
```

The data cleaned can be plotted using the following commands in ggplot
```R
library(ggplot2)
library(scales)


# Plot one variable: temperateure
ggplot(hobocleaned, aes(x=Date.Time, y = Temp)) +
  geom_line(alpha= 0.5) +
  scale_y_continuous( name = "Temperature °C")+
  ggtitle("Temperature: Oct 21 - Jan 22")+
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_x_datetime(labels = date_format("%Y-%m-%d"))

```
![hobo plot 1 variable](https://github.com/LeBoldus-Lab/hoboR/blob/main/figs/hobo_one_var.png)


```R
# Plot two variables: temperature and humidity

ggplot(hobocleaned, aes(x=Date.Time)) +
  geom_line( aes(y=Temp, col = "red"), alpha = 0.5) + 
  geom_line( aes(y= Wetness, col = "blue"), alpha = 0.5) + 
  scale_y_continuous(
    # Features of the first axis
    name = "Temperature °C",
    # Add a second axis and specify its features
    sec.axis = sec_axis(~., name="Humidity")
  ) +
  labs(title = "Temperature: Oct 21 - Jan 22", color = "Legend") +
  scale_color_manual(labels = c("Humidity", "Temp"), values = c("red", "blue")) +
  scale_x_datetime(labels = date_format("%Y-%m-%d"))
```
![hobo plot 2 variable](https://github.com/LeBoldus-Lab/hoboR/blob/main/figs/hobo_two_vars.png)
