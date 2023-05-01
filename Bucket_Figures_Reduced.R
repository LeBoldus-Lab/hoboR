

# New dataframe for line plot of incidence by location
Location_sum2 <- data |>
  dplyr::group_by(Sampling, Treatment, Location) |>
  summarise( 
    n=n()*9,
    Sum.Rain=mean(sum.rain*.1),
    Mean.Rain=mean(mean.rain),
    Wet=mean(mean.wet),
    Temp=mean(mean.temp),
    Sum=sum(Incidice, na.rm = TRUE)/n*100)

View(Location_sum2)


# Change sampling from numeric to date for plots
Location_sum2$Sampling[Location_sum2$Sampling == "1"] <- "Oct 26th"
Location_sum2$Sampling[Location_sum2$Sampling == "2"] <- "Nov 4th"
Location_sum2$Sampling[Location_sum2$Sampling == "3"] <- "Nov 10th"
Location_sum2$Sampling[Location_sum2$Sampling == "4"] <- "Nov 18th"
Location_sum2$Sampling[Location_sum2$Sampling == "5"] <- "Nov 30th"
Location_sum2$Sampling[Location_sum2$Sampling == "6"] <- "Dec 7th"
Location_sum2$Sampling[Location_sum2$Sampling == "7"] <- "Dec 14th"
Location_sum2$Sampling[Location_sum2$Sampling == "8"] <- "Dec 21st"
Location_sum2$Sampling[Location_sum2$Sampling == "9"] <- "Jan 7th"
Location_sum2$Sampling[Location_sum2$Sampling == "10"] <- "Jan 17th"
Location_sum2$Sampling[Location_sum2$Sampling == "11"] <- "Feb 2nd"
Location_sum2$Sampling[Location_sum2$Sampling == "12"] <- "Feb 15th"
Location_sum2$Sampling[Location_sum2$Sampling == "13"] <- "Mar 1st"
Location_sum2$Sampling[Location_sum2$Sampling == "14"] <- "Mar 15th"
Location_sum2$Sampling[Location_sum2$Sampling == "15"] <- "Mar 29th"
Location_sum2$Sampling[Location_sum2$Sampling == "16"] <- "Apr 12th"
Location_sum2$Sampling[Location_sum2$Sampling == "17"] <- "Apr 26th"
Location_sum2$Sampling[Location_sum2$Sampling == "18"] <- "May 10th"
Location_sum2$Sampling[Location_sum2$Sampling == "19"] <- "May 24th"
Location_sum2$Sampling[Location_sum2$Sampling == "20"] <- "Jun 7th"
Location_sum2$Sampling[Location_sum2$Sampling == "21"] <- "Jun 21st"
Location_sum2$Sampling[Location_sum2$Sampling == "22"] <- "Aug 1st"
Location_sum2$Sampling[Location_sum2$Sampling == "23"] <- "Aug 24th"
Location_sum2$Sampling[Location_sum2$Sampling == "24"] <- "Sep 15th"


view(Location_sum2)
#Make colorblind pallets:
cbp1 <- c("#999999", "#E69F00", "#56B4E9", "#009E73",
          "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

cbp2 <- c("#000000", "#56B4E9", "#009E73",
          "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

cbp3 <-("red")

# Barplots faceted by location with Line plots overlayed
# Percent positive positive leaves & leaf wetness faceted by location
# remove labels from pannels 
Empty.facet.labels <- c("", "", "")
names(Empty.facet.labels) <- c("CC", "EC", "NH")


#barplot of leaf bait with line plot of mean leaf wetness by location
Bp <-ggplot(Location_sum2) + geom_bar(aes(x=fct_inorder(Sampling), y=Sum, fill = Treatment), stat="identity", position=position_dodge())+
  facet_wrap(vars(Location),ncol = 1,labeller = labeller(Location =Empty.facet.labels), scales = "fixed")+
  labs(y= "percent positive leaf baits")+labs(x= "sampling period")+theme_classic()+ 
  theme(axis.title.y = element_text(vjust = +4),
        axis.title.x = element_text(vjust = -4)) +
  scale_fill_manual(values = cbp1) + theme(strip.background = element_blank())+ 
  theme(strip.text.x = element_text(size = 15),  panel.border = element_rect(colour = "black", fill=NA, size=.4), plot.margin = margin(1, 1, 1, 1, "cm"))+
  theme(axis.text.x = element_text(angle = 60, vjust = 0.5, hjust=0.5))+
  geom_line(aes(x=fct_inorder(Sampling), y = Wet, colour = Wet), group = 1, size = 1)+ 
  theme(axis.title.y.right = element_text(vjust=+4))+ scale_color_gradient(low = "Green", high = "Black")
Bp+scale_y_continuous(sec.axis = sec_axis(~.+0, name = "mean percent leaf wetness"), expand = c(0, 0))

# barplot of leaf bait with line plot of mean rain by location
Bp <-ggplot(Location_sum2) + geom_bar(aes(x=fct_inorder(Sampling), y=Sum, fill = Treatment), stat="identity", position=position_dodge())+
  facet_wrap(vars(Location),ncol = 1,labeller = labeller(Location =Empty.facet.labels), scales = "fixed")+
  labs(y= "percent positive leaf baits")+labs(x= "sampling period")+theme_classic()+ 
  theme(axis.title.y = element_text(vjust = +4),
        axis.title.x = element_text(vjust = -4)) +
  scale_fill_manual(values = cbp1) + theme(strip.background = element_blank())+ 
  theme(strip.text.x = element_text(size = 15),  panel.border = element_rect(colour = "black", fill=NA, size=.4), plot.margin = margin(1, 1, 1, 1, "cm"))+
  theme(axis.text.x = element_text(angle = 60, vjust = 0.5, hjust=0.5))+
  geom_line(aes(x=fct_inorder(Sampling), y = Mean.Rain, colour = Mean.Rain), group = 1, size = 1)+ 
  theme(axis.title.y.right = element_text(vjust=+4))+ scale_color_gradient(low = "Cyan", high = "Black")
Bp+scale_y_continuous(sec.axis = sec_axis(~.+0, name = "mean rain (mm)"), expand = c(0, 0))

# barplot of leaf bait with line plot of sum rain by location
Bp <-ggplot(Location_sum2) + geom_bar(aes(x=fct_inorder(Sampling), y=Sum, fill = Treatment), stat="identity", position=position_dodge())+
  facet_wrap(vars(Location),ncol = 1,labeller = labeller(Location =Empty.facet.labels), scales = "fixed")+
  labs(y= "percent positive leaf baits")+labs(x= "sampling period")+theme_classic()+ 
  theme(axis.title.y = element_text(vjust = +4),
        axis.title.x = element_text(vjust = -4)) +
  scale_fill_manual(values = cbp1) + theme(strip.background = element_blank())+ 
  theme(strip.text.x = element_text(size = 15),  panel.border = element_rect(colour = "black", fill=NA, size=.4), plot.margin = margin(1, 1, 1, 1, "cm"))+
  theme(axis.text.x = element_text(angle = 60, vjust = 0.5, hjust=0.5))+
  geom_line(aes(x=fct_inorder(Sampling), y = Sum.Rain, colour = Sum.Rain), group = 1, size = 1)+ 
  theme(axis.title.y.right = element_text(vjust=+4))
Bp+scale_y_continuous(sec.axis = sec_axis(~.+0, name = "sum rain (cm)"), expand = c(0, 0)) 
  
# barplot of leaf bair with line plot of mean temp by location
Bp <-ggplot(Location_sum2) + geom_bar(aes(x=fct_inorder(Sampling), y=Sum, fill = Treatment), stat="identity", position=position_dodge())+
  facet_wrap(vars(Location),ncol = 1,labeller = labeller(Location =Empty.facet.labels), scales = "fixed")+
  labs(y= "percent positive leaf baits")+labs(x= "sampling period")+theme_classic()+ 
  theme(axis.title.y = element_text(vjust = +4),
        axis.title.x = element_text(vjust = -4)) +
  scale_fill_manual(values = cbp1) + theme(strip.background = element_blank())+ 
  theme(strip.text.x = element_text(size = 15),  panel.border = element_rect(colour = "black", fill=NA, size=.4), plot.margin = margin(1, 1, 1, 1, "cm"))+
  theme(axis.text.x = element_text(angle = 60, vjust = 0.5, hjust=0.5))+
  geom_line(aes(x=fct_inorder(Sampling), y = Temp, colour = Temp), group = 1, size = 1)+ 
  theme(axis.title.y.right = element_text(vjust=+4))+ scale_color_gradient(low = "Blue", high = "Red")
Bp+scale_y_continuous(sec.axis = sec_axis(~.+0, name = "mean temperature (C)"), expand = c(0, 0))


# code junk box:
Bp+scale_y_continuous(expand = c(0, 0), limits=c(0, 35) )
+ scale_color_gradient(low = "Cyan", high = "Black")