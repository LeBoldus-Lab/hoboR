library(hoboR)


path = "~/Desktop/testsky/canopy08/"
path = "~/Desktop/testsky/calibration/originalfiles/"
# the path file exist
file.exists(path)
path=paste0(path, "canopy1/")
# loading all hobo files
# hobofiles <- hobinder(path) # header and skip col is a new feature
hobofiles <- hobinder(path, channels = "ON" ) # channels is a new feature
head(hobofiles)

hobocleaned <- hobocleaner(hobofiles, format = "ymd")

ho.range(hobocleaned, start="2022-03-21 17:45", end="2022-03-21 18:20")
