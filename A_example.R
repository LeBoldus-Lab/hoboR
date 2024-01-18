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
path = "~/Desktop/Adam/site_12_date_adj2/"
# the path file exist
file.exists(path)

# loading all hobo files
hobofiles <- hobinder(path, header = T, skip=1) # header and skip col is a new feature
head(hobofiles)

# cleaning hobo files, add format
hobocleaned <- hobocleaner(hobofiles, format = "yymd")
head(hobocleaned)
tail(hobocleaned)
# specify a window range 
horange(hobocleaned, start="2022-06-04", end="2022-10-22")

# getting hobo mean summary by time 
hobot <- hobotime(hobocleaned, summariseby = "5 mins", na.rm = T)
head(hobot)

# impossible values
impossiblevalues(hobocleaned, showrows = 3)

na_data <- NAsensorfailures(hobocleaned, condition = ">", threshold = c(50, 3000, 101), opt = c("Temp", "Rain", "Wetness"))

timestamp(hobocleaned, stamp = "2022-08-05 00:01", by = "24 hours", 
          days = 100, na.rm = TRUE, plot = T, var = "Temp")


# getting hobo means by date
hobomeans <- meanhobo(hobocleaned, summariseby = "1 day",  na.rm = T)
head(hobomeans)


# plots 

# horrelation 
horrelation(hobocleaned, summariseby = "month", by = "mean", na.rm = F)

#--------------- Plot 

library(ggplot2)
library(scales)

# Plot one variable: temperateure
ggplot(hobocleaned, aes(x=as.POSIXct(Date), y = Temp)) +
  geom_line(alpha= 0.5) +
  scale_y_continuous( name = "Temperature °C")+
  ggtitle("Temperature: Oct 14 - Nov 11, 2021")+
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_x_datetime(labels = date_format("%Y-%m-%d"))+
  theme_bw()

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
  labs(title = "Temperature: Oct 14 - Nov 11, 2021", color = "Legend") +
  scale_color_manual(labels = c("Humidity", "Temp"), values = c("blue", "red")) +
  scale_x_datetime(labels = date_format("%Y-%m-%d"))+
  theme_bw()

heatmap(cor(as.matrix(hobocleaned[,2:4])))
test <- na.omit(hobocleaned[,2:5])
cor(test)|>
  heatmap(Colv=NA, Rowv=NA)

# reading bucket samples
sampling <- read.csv("~/Desktop/Bucket_Results_Adj.csv")

# subset your bucket sampling by site
## Remember to replace the EC,NH and CC
Site <- sampling[which(sampling$Location == "EC" & sampling$Site == x) ,]
# n is the total number of baited samples
samp.rates <- samplingrates(Site, n = 9, round= 2)
# get the weather data summary for samples in and out
SITE <- sampling.trends(hobomeans, samp.rates, na.rm = T, round = 2)

# write your results by SITE
# write.csv(SITE, paste0("site_", x, "_inc_results_by_site.csv"))


