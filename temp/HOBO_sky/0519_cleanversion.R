

library(ggplot2)
library(tidyverse)
library(dplyr)
library(readr)
library("writexl")
library(nlme)

#change language if not in EN
#Sys.setenv(LANG = "en")

#files were pooled and edited individually by hand. Just put them into the same folder. 

#load files.
list_of_files <- list.files(path = "C:/Users/skyla/Desktop/HOBO_SOD/stats_hobo/calibration/combined",
                            recursive = TRUE,
                            pattern = "\\.csv$",
                            full.names = TRUE)

#pooled together and create the dataframe.
  #need to make sure all columns are the same. 
  #Or delete the last three columns (log in/log out records) before pooling them together. 
df <- readr::read_csv(list_of_files, id = "file_name")


#rename the columns.
names(df)[1] <- "file"
names(df)[3] <- "DateTime"
names(df)[4] <- "Temp"
names(df)[5] <- "Temp_max"
names(df)[6] <- "Temp_min"
names(df)[7] <- "Temp_avg"
names(df)[8] <- "Temp_sd"
names(df)[9] <- "Humid"
names(df)[10] <- "Humid_max"
names(df)[11] <- "Humid_min"
names(df)[12] <- "Humid_avg"
names(df)[13] <- "Humid_sd"
names(df)[14] <- "Dewpoint"


df$file=factor(df$file,
                levels=c("C:/Users/skyla/Desktop/HOBO_SOD/stats_hobo/calibration/combined/canopy01.csv", "C:/Users/skyla/Desktop/HOBO_SOD/stats_hobo/calibration/combined/canopy02.csv",
                         "C:/Users/skyla/Desktop/HOBO_SOD/stats_hobo/calibration/combined/canopy03.csv", "C:/Users/skyla/Desktop/HOBO_SOD/stats_hobo/calibration/combined/canopy04.csv",
                         "C:/Users/skyla/Desktop/HOBO_SOD/stats_hobo/calibration/combined/canopy05.csv", "C:/Users/skyla/Desktop/HOBO_SOD/stats_hobo/calibration/combined/canopy06.csv",
                         "C:/Users/skyla/Desktop/HOBO_SOD/stats_hobo/calibration/combined/canopy07.csv", "C:/Users/skyla/Desktop/HOBO_SOD/stats_hobo/calibration/combined/canopy08.csv",
                         "C:/Users/skyla/Desktop/HOBO_SOD/stats_hobo/calibration/combined/canopy09.csv", "C:/Users/skyla/Desktop/HOBO_SOD/stats_hobo/calibration/combined/canopy10.csv",
                         "C:/Users/skyla/Desktop/HOBO_SOD/stats_hobo/calibration/combined/canopy11.csv", "C:/Users/skyla/Desktop/HOBO_SOD/stats_hobo/calibration/combined/canopy12.csv",
                         "C:/Users/skyla/Desktop/HOBO_SOD/stats_hobo/calibration/combined/canopy13.csv", "C:/Users/skyla/Desktop/HOBO_SOD/stats_hobo/calibration/combined/canopy14.csv",
                         "C:/Users/skyla/Desktop/HOBO_SOD/stats_hobo/calibration/combined/canopy15.csv", "C:/Users/skyla/Desktop/HOBO_SOD/stats_hobo/calibration/combined/canopy16.csv",
                         "C:/Users/skyla/Desktop/HOBO_SOD/stats_hobo/calibration/combined/canopy17.csv", "C:/Users/skyla/Desktop/HOBO_SOD/stats_hobo/calibration/combined/canopy18.csv",
                         "C:/Users/skyla/Desktop/HOBO_SOD/stats_hobo/calibration/combined/canopy19.csv", "C:/Users/skyla/Desktop/HOBO_SOD/stats_hobo/calibration/combined/canopy20.csv",
                         "C:/Users/skyla/Desktop/HOBO_SOD/stats_hobo/calibration/combined/canopy21.csv", "C:/Users/skyla/Desktop/HOBO_SOD/stats_hobo/calibration/combined/canopy22.csv",
                         "C:/Users/skyla/Desktop/HOBO_SOD/stats_hobo/calibration/combined/canopy23.csv", "C:/Users/skyla/Desktop/HOBO_SOD/stats_hobo/calibration/combined/canopy24.csv"), 
                labels=c("canopy01", "canopy02", "canopy03", "canopy04","canopy05","canopy06", "canopy07","canopy08", "canopy09", "canopy10",
                         "canopy11", "canopy12", "canopy13", "canopy14","canopy15","canopy16", "canopy17","canopy18", "canopy19", "canopy20",
                         "canopy21", "canopy22", "canopy23", "canopy24"))



#select specific time of data
  #including 3/22-4/4 in the incubator.
  #and 4/6-4/27 in an open spot in the air (no sun exposure). 
  #the reason I am picking some specific time is,
  #those time should be stable in the incubator, and not in temperature increasing/decreasing process.
  #during 4/6-4/27 the weather changed by natural. So picked up the time randomly (mainly for humidity variance). 
df2 <- subset(df,  DateTime == "3/22/2022 1:00" |
                DateTime == "3/22/2022 2:00" |
                DateTime == "3/22/2022 3:00" |
                DateTime == "3/22/2022 17:00" |
                DateTime == "3/22/2022 18:00" |
                DateTime == "3/22/2022 19:00" |
                DateTime == "3/23/2022 17:00" |
                DateTime == "3/23/2022 18:00" |
                DateTime == "3/23/2022 19:00" |
                DateTime == "3/25/2022 1:00" |
                DateTime == "3/25/2022 2:00" |
                DateTime == "3/25/2022 3:00" |
                DateTime == "3/26/2022 17:00" |
                DateTime == "3/26/2022 18:00" |
                DateTime == "3/26/2022 19:00" |
                DateTime == "3/27/2022 17:00" |
                DateTime == "3/27/2022 18:00" |
                DateTime == "3/27/2022 19:00" |
                DateTime == "3/29/2022 1:00" |
                DateTime == "3/29/2022 2:00" |
                DateTime == "3/29/2022 3:00" |
                DateTime == "3/30/2022 1:00" |
                DateTime == "3/30/2022 2:00" |
                DateTime == "3/30/2022 3:00" |
                DateTime == "3/31/2022 1:00" |
                DateTime == "3/31/2022 2:00" |
                DateTime == "3/31/2022 3:00" |
                DateTime == "4/1/2022 1:00" |
                DateTime == "4/1/2022 2:00" |
                DateTime == "4/1/2022 3:00" |
                DateTime == "4/2/2022 1:00" |
                DateTime == "4/2/2022 2:00" |
                DateTime == "4/2/2022 3:00" |
                DateTime == "4/3/2022 1:00" |
                DateTime == "4/3/2022 2:00" |
                DateTime == "4/3/2022 3:00" |
                DateTime == "4/7/2022 11:00" |
                DateTime == "4/7/2022 12:00" |
                DateTime == "4/7/2022 13:00" |
                DateTime == "4/9/2022 11:00" |
                DateTime == "4/9/2022 12:00" |
                DateTime == "4/9/2022 13:00" |
                DateTime == "4/10/2022 20:00" |
                DateTime == "4/10/2022 21:00" |
                DateTime == "4/10/2022 22:00" |
                DateTime == "4/11/2022 7:00" |
                DateTime == "4/11/2022 8:00" |
                DateTime == "4/11/2022 9:00" |
                DateTime == "4/12/2022 11:00" |
                DateTime == "4/12/2022 12:00" |
                DateTime == "4/12/2022 13:00" |
                DateTime == "4/13/2022 14:00" |
                DateTime == "4/13/2022 15:00" |
                DateTime == "4/13/2022 16:00" |
                DateTime == "4/14/2022 7:00" |
                DateTime == "4/14/2022 8:00" |
                DateTime == "4/14/2022 9:00" |
                DateTime == "4/15/2022 18:00" |
                DateTime == "4/15/2022 19:00" |
                DateTime == "4/15/2022 20:00" |
                DateTime == "4/16/2022 4:00" |
                DateTime == "4/16/2022 5:00" |
                DateTime == "4/16/2022 6:00" |
                DateTime == "4/17/2022 14:00" |
                DateTime == "4/17/2022 15:00" |
                DateTime == "4/17/2022 16:00" |
                DateTime == "4/20/2022 12:00" |
                DateTime == "4/20/2022 13:00" |
                DateTime == "4/20/2022 14:00" |
                DateTime == "4/21/2022 20:00" |
                DateTime == "4/21/2022 21:00" |
                DateTime == "4/21/2022 22:00" |
                DateTime == "4/23/2022 6:00" |
                DateTime == "4/23/2022 7:00" |
                DateTime == "4/23/2022 8:00"
                )

#check 30 sec measuring variation for each hobo itself. 
  #to make sure the stability of measurements.
#temperature check   1. max-min   2. temp-temp_avg
df2 <- df2 %>% 
  mutate(check1 = Temp_max - Temp_min)
df2 <- df2 %>% 
  mutate(check2 = Temp - Temp_avg)
#humidity check   1. max-min   2. humid-humid_avg
df2 <- df2 %>% 
  mutate(check3 = Humid_max - Humid_min)
df2 <- df2 %>% 
  mutate(check4 = Humid - Humid_avg)
#All look fine. Using "Temp" and "Humid" in the following progress.


##Temperature calibration----
#only use the DateTime 3/22-4/3 to calibrate. (The period in Incubator)
df3 <- subset(df,  DateTime == "3/22/2022 1:00" |
                DateTime == "3/22/2022 2:00" |
                DateTime == "3/22/2022 3:00" |
                DateTime == "3/22/2022 17:00" |
                DateTime == "3/22/2022 18:00" |
                DateTime == "3/22/2022 19:00" |
                DateTime == "3/23/2022 17:00" |
                DateTime == "3/23/2022 18:00" |
                DateTime == "3/23/2022 19:00" |
                DateTime == "3/25/2022 1:00" |
                DateTime == "3/25/2022 2:00" |
                DateTime == "3/25/2022 3:00" |
                DateTime == "3/26/2022 17:00" |
                DateTime == "3/26/2022 18:00" |
                DateTime == "3/26/2022 19:00" |
                DateTime == "3/27/2022 17:00" |
                DateTime == "3/27/2022 18:00" |
                DateTime == "3/27/2022 19:00" |
                DateTime == "3/29/2022 1:00" |
                DateTime == "3/29/2022 2:00" |
                DateTime == "3/29/2022 3:00" |
                DateTime == "3/30/2022 1:00" |
                DateTime == "3/30/2022 2:00" |
                DateTime == "3/30/2022 3:00" |
                DateTime == "3/31/2022 1:00" |
                DateTime == "3/31/2022 2:00" |
                DateTime == "3/31/2022 3:00" |
                DateTime == "4/1/2022 1:00" |
                DateTime == "4/1/2022 2:00" |
                DateTime == "4/1/2022 3:00" |
                DateTime == "4/2/2022 1:00" |
                DateTime == "4/2/2022 2:00" |
                DateTime == "4/2/2022 3:00" |
                DateTime == "4/3/2022 1:00" |
                DateTime == "4/3/2022 2:00" |
                DateTime == "4/3/2022 3:00"
              )


#by using linear model
model1 = lm(Temp ~ DateTime * hobo , data = df3)
summary(model1)
anova(model1)

ggplot(model1, aes(x=hobo, y=Temp, group=hobo)) +
  geom_point() +
  geom_line() 

model2 = lm(Temp ~ hobo , data = df3)
summary(model2)
anova(model2)


##Humidity calibration----
#hobo_15 missing data after 4/4. Just ignore it.
#by using linear model
model3 = lm(Humid ~ DateTime * hobo , data = df2)
summary(model3)
anova(model3)

ggplot(model3, aes(x=hobo, y=Humid, group=hobo)) +
  geom_point() +
  geom_line() 

model4 = lm(Humid ~ hobo , data = df2)
summary(model4)
anova(model4)

#Either the temperature or humidity is related to hobos. 
#So an additive calibration should be enough. Which means the difference among hobos are additive. 


#calibration number calculation----
##using hobo#1 as the baseline. Add/subtract the values. 
#calculate the difference between hobos. 

write_xlsx(df2,"C:/Users/skyla/Desktop/HOBO_SOD/stats_hobo/calibration/df2.xlsx")
#working through excel --> df2_ed, saved as csv. 
#using hobo_01 as the baseline to calculate the measurement differences between hobos by DateTime.
#for temperature (temp_cal), humidity (humid_cal), and dewpoint (DP_cal). 


#re-load the csv after editing. 
df2_ed = read.csv("df2_ed.csv")

#average the differences by hobos. 
numbers <- df2_ed %>%
  select(hobo, Temp_cal, Humid_cal, DP_cal) %>%
  group_by(hobo) %>%
  summarise(temp_cal_avg=mean(Temp_cal), temp_cal_sd=sd(Temp_cal), RH_cal_avg=mean(Humid_cal), RH_cal_sd=sd(Humid_cal),DP_cal_avg=mean(DP_cal), DP_cal_sd=sd(DP_cal))
#standard deviation is huge but could be ignored because every number is small. 
#just would like to check it. 

#output the numbers. 
write_xlsx(numbers,"C:/Users/skyla/Desktop/HOBO_SOD/stats_hobo/calibration/numbers.xlsx")


#if only use temp calibration period....
df3_ed <- subset(df2_ed,  DateTime == "3/22/2022 1:00" |
                DateTime == "3/22/2022 2:00" |
                DateTime == "3/22/2022 3:00" |
                DateTime == "3/22/2022 17:00" |
                DateTime == "3/22/2022 18:00" |
                DateTime == "3/22/2022 19:00" |
                DateTime == "3/23/2022 17:00" |
                DateTime == "3/23/2022 18:00" |
                DateTime == "3/23/2022 19:00" |
                DateTime == "3/25/2022 1:00" |
                DateTime == "3/25/2022 2:00" |
                DateTime == "3/25/2022 3:00" |
                DateTime == "3/26/2022 17:00" |
                DateTime == "3/26/2022 18:00" |
                DateTime == "3/26/2022 19:00" |
                DateTime == "3/27/2022 17:00" |
                DateTime == "3/27/2022 18:00" |
                DateTime == "3/27/2022 19:00" |
                DateTime == "3/29/2022 1:00" |
                DateTime == "3/29/2022 2:00" |
                DateTime == "3/29/2022 3:00" |
                DateTime == "3/30/2022 1:00" |
                DateTime == "3/30/2022 2:00" |
                DateTime == "3/30/2022 3:00" |
                DateTime == "3/31/2022 1:00" |
                DateTime == "3/31/2022 2:00" |
                DateTime == "3/31/2022 3:00" |
                DateTime == "4/1/2022 1:00" |
                DateTime == "4/1/2022 2:00" |
                DateTime == "4/1/2022 3:00" |
                DateTime == "4/2/2022 1:00" |
                DateTime == "4/2/2022 2:00" |
                DateTime == "4/2/2022 3:00" |
                DateTime == "4/3/2022 1:00" |
                DateTime == "4/3/2022 2:00" |
                DateTime == "4/3/2022 3:00"
)


numbers2 <- df3_ed %>%
  select(hobo, Temp_cal, Humid_cal, DP_cal) %>%
  group_by(hobo) %>%
  summarise(temp_cal_avg=mean(Temp_cal), temp_cal_sd=sd(Temp_cal), RH_cal_avg=mean(Humid_cal), RH_cal_sd=sd(Humid_cal),DP_cal_avg=mean(DP_cal), DP_cal_sd=sd(DP_cal))
#not much different for those small difference hobos, but various for the large difference hobo i.e.#2.#5.
#I am going to use more general difference, which is df2_ed for the calibration. 


#apply to the field data----
#1. pooled field csv together by hobo
#2. ass/subtract numbers based on "numbers", which the numbers baseline is hobo#1.
#    For temperature, Relative humidity, and dewpoint. Every five minutes. 
#    then out put to an individual excel file. 
#3. pooled all 24 hobos together.


