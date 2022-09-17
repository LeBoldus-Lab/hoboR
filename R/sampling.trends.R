
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
#' @importFrom dplyr group_by
#' @importFrom dplyr mutate
#' @importFrom dplyr select
#' @importFrom lubridate ymd


#' @examples 
#' samples <- read.cv(sampling.data)
#' samp.rates <- samplingrates(samples)
#' @export
#' 


sampling.trends <- function(hobomeans, samp.rates){
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
    rows  <- data.frame(ID = k,
                        Sample.Treatment = paste(paste0("S",samp.rates$Sites[k]), 
                                                 samp.rates$Location[k], 
                                                 samp.rates$Treatment[k], 
                                                 sep = "-"),
                        mean.wet = round(mean(rango$x.Wetness), 2),
                        mean.temp = round(mean(rango$x.Temp), 2),
                        mean.RH = round(mean(rango$x.RH),2),
                        mean.Rain = round(mean(rango$x.Rain), 2)
    )
    if (k == 1){
      dat <- rows
    } else {
      dat <- rbind(dat, rows)
    }
  }
  return(dat)
}
