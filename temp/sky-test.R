install.packages("devtools")
library("devtools")
devtools::install_github("LeBoldus-Lab/hoboR")
library(hoboR)
library(dplyr)
library(ggplot2)

library(hoboR)


path = "~/Desktop/testsky/calibration/originalfiles/"
# the path file exist
file.exists(path)

#
folder=paste0(rep("canopy", 24), 1:24)

pathtoread=calibrationfiles=hobocleaned=data=list()

for (i in seq_along(folder)){
pathtoread[[i]] <- paste0(path, folder[i])
# loading all hobo files
calibrationfiles[[i]] <- hobinder(as.character(pathtoread[i]), channels = "ON" ) # channels is a new feature
data[[i]]=hobocleaned[[i]] <- hobocleaner(calibrationfiles[[i]], format = "ymd")
}
data[[2]]
times <- c("2022-03-22 01:00", "2022-03-22 02:00", "2022-03-22 03:00", "2022-03-22 04:00",
           "2022-03-22 05:00", "2022-03-22 06:00", "2022-03-22 07:00", "2022-03-22 08:00",
           "2022-03-22 09:00")

x <- calibrator(data, columns= c(2, 7, 12), times = times)

correction.test(list.data=data, calibrationfile=x, columns = c(2, 7, 12), 
                times = times, threshold = c(1, 0.5, 10))

ho.range(data[[2]], start="2022-03-22 5:40", end="2022-03-22 9:20")
