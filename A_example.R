# install.packages("devtools")
# library("devtools")
# devtools::install_github("LeBoldus-Lab/hoboR")
library(hoboR)
library(dplyr)
library(ggplot2)

# Change the number for the site
x =11

# Add the PATH to your sites for weather data (from hobo)
path = paste0("~/Desktop/site_", x)

# loading hobo files
hobofiles <- hobinder(path)
tail(hobofiles)
# cleaning hobo files
hobocleaned <- hobocleaner(hobofiles)
tail(hobocleaned)

# getting hobo means by date
hobomeans <- meanhobo(hobocleaned)
hobomeans |>
    as_tibble()

# reading bucke samples
sampling <- read.csv("~/Desktop/Bucket_Results_Adj.csv") |>
    as_tibble()
# subset your bucket sampling by site
## Remember to replace the EC,NH and CC
Site <- sampling[which(sampling$Location == "NH" & sampling$Site == x) ,]
# n is the total number of baited samples
samp.rates <- samplingrates(Site, n = 9, round= 2)
# get the weather data summary for samples in and out
SITE <- sampling.trends(hobomeans, samp.rates, round = 2)

# write your results by SITE
write.csv(SITE, paste0("site_", x, "_inc_results_by_site.csv"))

