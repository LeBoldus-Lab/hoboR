# HOBOR
R package for the analysis of  HOBO weather station data.
The HOBO files as CSV, time formats accepted: DD/MM/YYYY, MM/DD/YYYY, YY/MM/DD

## [Documentation](https://leboldus-lab.github.io/hoboR/)

[**manual.github.io/hobor**](https://leboldus-lab.github.io/hoboR/)

## Install using devtools

This project is available on GitHub at `http://github.com/LeBoldus` and can be installed using `devtools`. We are working on a CRAN version.

```R
install.packages("devtools")
library("devtools")
# Installing HOBOR through devtools
devtools::install_github("LeBoldus-Lab/hoboR")
library(hobor)
```

Required dependencies
```r
install.packages("dplyr")
install.packages("plyr")
install.packages("lubridate")
install.packages("reshape")
install.packages("ggplot2")
install.packages("devtools")
```

------ 
HoboR usage

```R
hobofiles <- hobinder(path)
cleanfiles <- hobocleaner(hobofiles, format = "ymd")
# get summary statistics
hobodata <- meanhobo(cleanfiles, summariseby = "5 mins", na.rm = T)
```

The data cleaned can be plotted using the following commands in ggplot
```R
library(ggplot2)
library(scales)
# Plot one variable: temperateure
ggplot(hobodata, aes(x=Date, y = Temp)) +
  geom_line(alpha= 0.5) +
  scale_y_continuous( name = "Temperature °C")+
  ggtitle("Temperature: Oct 21 - Jan 22")+
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_x_datetime(labels = date_format("%Y-%m-%d"))

```
![hobo plot 1 variable](https://github.com/LeBoldus-Lab/hoboR/blob/main/docs/images/hobo_one_var.png)


```R
# Plot two variables: temperature and humidity

ggplot(hobodata, aes(x=Date)) +
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
![hobo plot 2 variable](https://github.com/LeBoldus-Lab/hoboR/blob/main/docs/images/hobo_two_vars.png)





## License

This work is subject to the [MIT License](https://github.com/LeBoldus-Lab/hoboR/blob/main/LICENSE.md)

## Acknowledgements

Grant 123456, and XYZ.

## Contributors and Errors

Welcome pull submission through Github [pull request](https://help.github.com/articles/using-pull-requests/).
Please report any errors or requests using GitHub [issues](https://github.com/LeBoldus_Lab/hoboR/issues).
