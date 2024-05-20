# Install hoboR
# hoboR installation via devtools, and in the process of submit it to CRAN.

# First, install devtools and dependency libraries

# # install.packages("devtools")
# library("devtools")
# devtools::install_github("LeBoldus-Lab/hoboR", force = TRUE)
library(hoboR)
# Required dependencies

library(lubridate)
library(tidyr)
library(dplyr)
library(reshape2)
library(ggplot2)
library(scales)

# load the library
library(hoboR)
# Example:
#   The data was collected in China Creek in Southern Oregon using a weather station. The measurements were recorded every minute over a period of 5 months, from August to December 2022. The weather variables collected were humidity (Wetness), temperature (Temp), relative humidity (RH), and rain (Rain).

# Add the PATH to your sites for weather data (from HOBO)
path = paste0("~/Desktop/Adam/site_12_date_adj2/")
# make sure the path to your CSV files exists
file.exists(path)     # this will return a logical value TRUE

# loading all hobo files
hobofiles <- hobinder(path, skip = 1)
hobocleaned <- hobocleaner(hobofiles, format = "yymd")
head(hobocleaned)

# getting hobo mean summary by time
hobot5 <- hobotime(hobocleaned, summariseby = "30 mins", na.rm = T)
hobomeans5 <- meanhobo(hobot5, summariseby = "1 day",  na.rm = T)
head(hobomeans5)

# getting hobo means by date
hobomeans <- meanhobo(hobocleaned, summariseby = "24 h",  na.rm = T)
head(hobomeans)
# Checking the differences between summary types
plot(1:nrow(hobomeans), hobomeans$x.Temp, type = "line")
lines(1:nrow(hobomeans5), hobomeans5$x.Temp, type = "line", col = "red")

# Specify a window range 
timerange <- hoborange(hobocleaned, start="2022-08-08", end="2022-12-12")
head(timerange)

# Snapshot of a time interval 
a <- timestamp(hobocleaned, stamp = "2022-08-05 00:01", by = "24 hours",
               days = 100, na.rm = FALSE, plot = F, var = "Temp")
a$Group <- rep("night", nrow(a))
b <- timestamp(hobocleaned, stamp = "2022-08-05 12:01", by = "24 hours",
               days = 100, na.rm = FALSE, plot = F, var = "Temp")
b$Group <- rep("day", nrow(b))

daynight <- rbind(a, b)
# Plot with ggplot2
ggplot(daynight, aes(x = Date, y = Temp, group = Group, color = Group)) +
  geom_line() +
  scale_x_datetime() +
  scale_y_continuous(limits = c(0, 30)) +
  scale_color_manual(values = c("orange", "black")) +
  labs(color = "Source") +
  scale_y_continuous(name = "Temperature °C")+
  scale_x_datetime(name = "Months")+
  theme_minimal()

#Fig. 1) Visualization of the summary results calculated with hoboR of the weather recorded between October 2021 and December 2021, in Brookings, Southern Oregon.

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
  labs(title = "Temperature: August - December, 2022", color = "Legend") +
  scale_color_manual(labels = c("Humidity", "Temp"), values = c("blue", "red")) +
  scale_x_datetime(name= "Date", labels = date_format("%Y-%m-%d"))+
  theme_bw()
