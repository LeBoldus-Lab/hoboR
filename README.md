# hoboR
Function to combined data from HOBO weather stations.
The files need to be exported from the HOBO software as CSV, using 24h format and YYYY-MM-DD.


## Installation

This project is available on GitHub and can be installed using:

> Dependencies: `dplyr`, `purrr`, `lubridate`

``` r
install.packages("devtools")
library("devtools")
devtools::install_github("LeBoldus-Lab/hoboR")
library(hoboR)
```

# Example
Add the PATH to your csv files  
```
path = "~/site_1_date_adj/"


# loading hobo files 
# hobinder reads csv headers automatically, just double check that all csv are in order ## working on auto sorting
hobofiles <- hobinder(path)
tail(hobofiles)
# cleaning hobo files
hobocleaned <- hobocleaner(hobofiles, format = "mdy”) # your files are month day and year "05-01-23" 
                                    # format = "ymd"  # your files are year month and day "20-11-21"
                                    # format = "yymd" # your files are year month and day "2020-11-21" 
tail(hobocleaned)

# getting hobo means by date 
hobomeans <- meanhobo(hobocleaned, na.rm = T)

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
