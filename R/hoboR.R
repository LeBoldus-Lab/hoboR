setwd("~/Documents/site_1_24hr/")
library(tidyverse)
library(plyr)


hobinder <- function(file){
  # read files from working directory
  files = list.files(path=file, pattern = "\\.csv")
  # get names from files
  names <- as.data.frame(files) |>
    separate(files, into=c("names", "ext"), sep= "[.]")
  # load all .csv files
  ls = list(NULL)
  for (i in 1:length(files)){
    x <- read.csv(files[i], skip=2, header = F)
    x$IDs <- rep(names$names[i], nrow(x))
    ls[[i]] = x
  }
  # bind all csv files with identifiers
  hobos <- rbind.fill(ls)
  colnames(hobos) <- c("tID","Date.Time", "Wetness", "Temp", "RH", "Rain", "Site")
  return(hobos)
}

hobocleaner <- function(file){
  temp <- file[,c(1:6)] |> 
    unique() 
  temp$Date.Time <- gsub("/", "-", temp$Date.Time)
  return(temp)
}

# Example

file = "../site_1_24hr/"

hobo1 <- hobinder(file)
dim(hobo1)
hobo1c <- hobocleaner(hobo1)
dim(hobo1c)

test$data <- as.POSIXct(test$data)

library(scales)
ggplot(test, aes(data, point)) +
  geom_point() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  scale_x_datetime(labels = date_format("%H:%M:%S"))



asDateBuilt(hobo1c$Date.Time)

plot(hobo1c$Date.Time, hobo1c$Temp)

gsub("/", "-", hobo1c$Date.Time)

as.POSIXct(hobo1c$Date.Time)

specs <- read.csv("Site_1_(18025)_0.csv", skip = 1, header = F)[1,] |>
  as.character()
