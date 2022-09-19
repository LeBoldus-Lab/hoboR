
#' calcula sampling bate rates temperature using weather data and
#' sampling rates for data collection
#' This function calculates hobo weather means for sampling rates 
#' Ex: phytophthora collected on dates for baited and removed leaves
#' HOBO software
#' @author Ricardo I Alcala Briseno, \email{alcalabr@@oregonstate.edu}
#' @param samples a csv with the format 
#' incidence calculated from a csv table designed for baiting Phytophtora
#' @return smaller data frame with incidence and rates
#'
#' @importFrom purrr is_empty 
#' @importFrom dplyr group_by
#' @importFrom dplyr mutate
#' @importFrom dplyr select
#' @importFrom lubridate ymd



#' @examples 
#' samples <- read.cv(sampling.data)
#' samp.rates <- samplingrates(samples)
#' @export
#' 

sampling.trends <- function(hobomeans, samp.rates, round){
  rows = NULL
  for (k in 1:nrow(hobomeans)){
    if (is_empty(which(hobomeans$Date == samp.rates$Leaves.In[k])) == TRUE){ 
      print(paste0("row ", k, ": Missing sample in hobo, about date : ", samp.rates$Leaves.In[k-1]))
    } else {
      y <- which(hobomeans$Date == samp.rates$Leaves.In[k])
    }
    if (is_empty(which(hobomeans$Date == samp.rates$Leaves.Out[k])) == TRUE){
      print(paste0("row ", k, ": Missing sample in hobo, about date: ", samp.rates$Leaves.Out[k-1]))
    } else {
      x <- which(hobomeans$Date == samp.rates$Leaves.Out[k])
    }
    #- Calculating means
    rango <- hobomeans[y:x,]
    nT <- nrow(rango)
    rows  <- data.frame(ID = k,
                        Sites = samp.rates$Sites[k], 
                        Location = samp.rates$Location[k], 
                        Treatment = samp.rates$Treatment[k], 
                        collection = samp.rates$Leaves.Out[k],
                        mean.wet = round(mean(rango$x.Wetness), round),
                        se.wet = round(sd(rango$x.Wetness)/
                                         sqrt(length(rango$x.Wetness)), round),
                        mean.temp = round(mean(rango$x.Temp), round),
                        se.temp = round(sd(rango$x.Temp)/
                                          sqrt(length(rango$x.Temp)), round),
                        mean.RH = round(mean(rango$x.RH), round),
                        se.RH = round(sd(rango$x.RH)/sqrt(length(rango$x.RH)), round),
                        mean.rain = round(mean(rango$x.Rain), round),
                        se.rain = round(sd(rango$x.Rain)/
                                          sqrt(length(rango$x.Rain)), round),
                        Incidice = samp.rates$Incidence[k],
                        Incidice.rate = samp.rates$Incidence.Rate[k]
    )
    if (k == 1){
      dat <- rows
    } else {
      dat <- rbind(dat, rows)
    }
  }
  return(dat)
}
