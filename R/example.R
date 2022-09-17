# install.packages("devtools")
# library("devtools")
# devtools::install_github("LeBoldus-Lab/hoboR")
library(hoboR)
library(purrr)
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
hobomeans |> as_tibble()


ss <- samp.rates[which(samp.rates$Leaves.out < max(hobomeans$Date)),]
rows = NULL#<-matrix(nrow = 1, ncol = 6)
for (k in 1:nrow(hobomeans)){
  print(k)
  y=which(hobomeans$Date == ss$Leaves.In[k])  
  x=which(hobomeans$Date == ss$Leaves.out[k])
  rango <- hobomeans[y:x,]
  rows  <- data.frame(ID = k,
                bucket = paste0("bucket_", k),
                meanwet = round(mean(rango$x.Wetness), 2),
                meantem = round(mean(rango$x.Temp), 2),
                meanRH = round(mean(rango$x.RH),2),
                meanRai = round(mean(rango$x.Rain), 2)
 )
  if (k == 1){
  dat <- rows
  } else {
  dat <- rbind(dat, rows)
  }
}
# reading bucke samples
sampling <- read.csv("Bucket_Results_Adj.csv") |>
  as_tibble()
 
samp.rates <- # generating incidence and incidence rates
  sampling |>
  group_by(Site, Location, Tree.,Treatment, Leaves.out) |>
  mutate(incidence = sum(na.omit(ramorum.positive))) |>
  select(Site, Tree., Location, Treatment, Week, 
         Leaves.In, Leaves.out,incidence)|>
  unique() |>
  mutate(incidence.rate = round(incidence/9, 2)) 

samp.rates$Leaves.In <- lubridate::ymd(samp.rates$Leaves.In)
samp.rates$Leaves.out <- lubridate::ymd(samp.rates$Leaves.out)

## Plotting incidence and  
#Make colorblind pallets:
cbp1 <- c("#999999", "#E69F00", "#56B4E9", "#009E73",
          "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

cbp2 <- c("#000000", "#56B4E9", "#009E73",
          "#F0E442", "#0072B2", "#D55E00", "#CC79A7")


ggplot(samp.rates, aes(Week, incidence.rate))+
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
