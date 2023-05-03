# install.packages("devtools")
# library("devtools")
# devtools::install_github("LeBoldus-Lab/hoboR", force = TRUE)
library(hoboR)
library(dplyr)
library(ggplot2)

# Change the number for the site
x = "11" #"A"

# Add the PATH to your sites for weather data (from hobo)
path = paste0("~/Desktop/site_", x)

# the path file exist
file.exists(path)

# loading hobo files
hobofiles <- hobinder(path)
head(hobofiles)

# cleaning hobo files, add format 
hobocleaned <- hobocleaner(hobofiles, format = "ymd")
head(hobocleaned)

# getting hobo mean summary by time 
hobot <- hobotime(hobocleaned, summariseby = "25 mins", na.rm = T)
head(hobot)

# impossible values
impossiblevalues(hobocleaned)

# getting hobo means by date
hobomeans <- meanhobo(hobocleaned, summariseby = "24 hours",  na.rm = T)
head(hobomeans)

# reading bucket samples
sampling <- read.csv("~/Desktop/Bucket_Results_Adj.csv") |>
    as_tibble()

# subset your bucket sampling by site
## Remember to replace the EC,NH and CC
Site <- sampling[which(sampling$Location == "EC" & sampling$Site == x) ,]
# n is the total number of baited samples
samp.rates <- samplingrates(Site, n = 9, round= 2)
# get the weather data summary for samples in and out
SITE <- sampling.trends(hobomeans, samp.rates, na.rm = T, round = 2)

# write your results by SITE
# write.csv(SITE, paste0("site_", x, "_inc_results_by_site.csv"))


