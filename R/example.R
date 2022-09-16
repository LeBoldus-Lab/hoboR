install.packages("devtools")
library("devtools")
devtools::install_github("LeBoldus-Lab/hoboR")
library(hoboR)

path = "/Users/ricardoialcala/Desktop/"

hobofiles <- hobinder(path)
tail(hobofiles)

hobocleaned <- hobocleaner(hobofiles)
tail(hobocleaned)

hobocleaned$Date.Time %in% "2021-10-15 02:20:35 UTC" |> table()
library(dplyr)


x.Wetness <- hobocleaned[which(hobocleaned$Date == "2022-01-06"),] |>
  select(Wetness)
  mean(x.Wetness$Wetness)
  
  
# Write you new combined data with
write.csv(hobocleaned, "new_hobo_combined_file.csv")
