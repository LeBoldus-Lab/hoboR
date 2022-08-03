# hoboR
Function to combined data from HOBO weather stations.
The files need to be exported from the HOBO software as CSV, using 24h format and YYYY-MM-DD.


## Installation

This project is available on GitHub and can be installed using:

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

hobofiles <- hobinder(path)

head(hobofiles)

hobocleaned <- hobocleaner(hobofiles)
head(hobocleaned)

# Write you new combined data with
write.csv(hobocleaned, "new_hobo_combined_file.csv")
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
