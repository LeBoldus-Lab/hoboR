install.packages("devtools")
library("devtools")
devtools::install_github("LeBoldus-Lab/hoboR")
library(hoboR)
library(dplyr)
library(ggplot2)

path = "/Users/ricardoialcala/Desktop/site_1_date_adj/"

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
sampling <- read.csv("/Users/ricardoialcala/Desktop/Bucket_Results_Adj.csv") |>
    as_tibble()

# subset your bucket sampling by site 
## Remember to replace the EC,NH and CC 
Site <- sampling[which(sampling$Location == "EC" & sampling$Site == x) ,]
# n is the total number of baited samples 
samp.rates <- samplingrates(Site, n = 9, round= 2)
tail(samp.rates)
# get the weather data summary for samples in and out 
SITE <- sampling.trends(hobomeans, samp.rates, round = 2)
tail(SITE)

# samp.rates <- samplingrates(sampling, n = 9, round= 2)
# sumbybates <- sampling.trends(hobomeans, samp.rates, round = 2)

#collection week - which is leave out
# incidence and incidence rates 

## Plotting incidence and  
#Make colorblind pallets:
cbp1 <- c("#999999", "#E69F00", "#56B4E9", "#009E73",
          "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

cbp2 <- c("#000000", "#56B4E9", "#009E73",
          "#F0E442", "#0072B2", "#D55E00", "#CC79A7")


ggplot(samp.rates, aes(Week, Incidence.Rate))+
  geom_line(aes(color = Treatment), size=1)+
  geom_point(aes(fill = Treatment), size=2)+
  facet_wrap(vars(Location),
             nrow = 4,
            labeller = labeller(Lineage = NULL), 
             scales = "free_x")+
  labs(y= "Percent positve leaves")+labs(x= "Collection week")+theme_classic() +
  scale_color_manual(values = cbp1) + theme(panel.spacing.x = unit(.5,"line"))+
  theme(strip.background = element_blank())+theme(strip.text.x = element_text(size = 15), panel.border = element_rect(colour = "black", fill=NA, size=.4))+
  scale_y_continuous(expand = expansion(mult = c(.1, .1)))
  

Location_sum2 <- sampling %>%
  group_by(Location, Treatment, Week) %>%
  summarise(n=n()*3,
    Sum=sum(ramorum.positive, na.rm = TRUE)/n*100)

ggplot(Location_sum2, aes(Week, Sum))+
  geom_line(aes(color = Treatment), size=1)+
  geom_point(
    aes(fill = Treatment), size=2)+
  facet_wrap(vars(Location),nrow = 4,
             labeller = labeller(Lineage = NULL), 
             scales = "free_x")+
  labs(y= "Percent positve leaves")+labs(x= "Collection week")+theme_classic() +
  scale_color_manual(values = cbp1) + theme(panel.spacing.x = unit(.5,"line"))+
  theme(strip.background = element_blank())+theme(strip.text.x = element_text(size = 15), panel.border = element_rect(colour = "black", fill=NA, size=.4))+
  scale_y_continuous(expand = expansion(mult = c(.1, .1)))


## This is to get the means for hobo measurements

hobocleaned |> 
  mutate(x.Wetness = mean(Wetness)) |>
  mutate(x.Temp = mean(Temp)) |>
  mutate(x.RH = mean(RH)) 

library(dplyr)
x.Wetness <- hobocleaned[which(hobocleaned$Date == "2022-01-06"),] |>
  select(Wetness)
  mean(x.Wetness$Wetness)

# Write you new combined data with
write.csv(hobocleaned, "new_hobo_combined_file.csv")
