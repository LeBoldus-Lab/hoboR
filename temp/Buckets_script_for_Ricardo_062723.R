library(hoboR)
library(purrr)
library(lubridate)
library(dplyr)
library(reshape)

FileOrderFix <- read.csv("C:/Users/carsonad/Desktop/csv weather data2/site_11_date_adj2/Site_11_(18224)_27.csv",
                         header = TRUE, sep = ",")


###*** New hoboR 1.2.0 package instructions ***#######
library(hoboR)
library(purrr)
library(lubridate)
library(dplyr)
library(reshape)
library(tidyr)

# Change the number for the site
x = 13

# Add the PATH to your sites for weather data (from hobo) 
path = paste0("C:/Users/carsonad/Desktop/csv weather data2/site_", x, "_date_adj2/")

path = "~/Desktop/Adam/site_12_date_adj2/"

# chose one of the two functions:
# 1. loading hobo files with correct column arrangement  
hobofiles <- hobinder(path, header = T, skip=1)

head(hobofiles)

hobocleaned <- hobocleaner(hobofiles, format = "ymd")

tail(hobocleaned)
head(hobocleaned)

# getting hobo means by date 
hobomeans <- meanhobo(hobocleaned, summariseby = "24 hours",  na.rm = T)
head(hobomeans)

hobomeans$Date <- as.Date(hobomeans$Date)

# reading bucket samples
sampling <- read.csv(file.choose()) |>
  as_tibble()

# subset your bucket sampling by site 
#******** Remember to replace the EC,NH and CC *********##
# if you forget you will get an error message about negative length vectors ###
Site <- sampling[which(sampling$Location == "EC" & sampling$Site == x) ,]

# n is the total number of baited samples 
samp.rates <- samplingrates(Site, n = 9, round= 2)

# get the weather data summary for samples in and out. Note: this is the same code as "summarybybates" 

SITE <- sampling.trends(hobomeans, samp.rates, round = 2, na.rm = T)

#** for second data frame only, change "sampling" column to start at 25
SITE$Sampling[SITE$Sampling == "1"] <- "25"
SITE$Sampling[SITE$Sampling == "2"] <- "26"
SITE$Sampling[SITE$Sampling == "3"] <- "27"
SITE$Sampling[SITE$Sampling == "4"] <- "28"
SITE$Sampling[SITE$Sampling == "5"] <- "29"
SITE$Sampling[SITE$Sampling == "6"] <- "30"

# check data is in correct columns & look for NA's / negative numbers & high temperatures  
head(SITE,24)
head(Site)