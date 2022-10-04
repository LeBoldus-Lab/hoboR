
#' calcula sampling bate rates temperature using weather data and
#' sampling rates for data collection
#' This function calculates hobo weather means for sampling rates 
#' Ex: phytophthora collected on dates for baited and removed leaves
#' HOBO software
#' @author Ricardo I Alcala Briseno, \email{alcalabr@@oregonstate.edu}
#' @param hobodata a data frame with the hobo means 
#' @param  samp.rates a data frame with incidence summary of collected dates 
#' for baiting Phytophtora
#' @return A data frame with summarized weather variables by data and location, 
#' as incidence rates
#'
#' @importFrom purrr is_empty 
#' @importFrom dplyr group_by
#' @importFrom dplyr mutate
#' @importFrom dplyr select
#' @importFrom lubridate ymd


#' @examples 
#' samples <- read.cv(sampling.data)
#' hobomeans <- meanhobo(hobocleaned)
#' samp.rates <- samplingrates(samples, n = 9, round = 2)
#' Site <- sampling.trends(hobomeans, samp.rates, round = 2)
#' @export
#' 

sampling.trends <- function(hobomeans, samp.rates, round){
  rows = NULL
  for (k in 1:nrow(samp.rates)){
    if (is_empty(which(hobomeans$Date == samp.rates$Leaves.In[k])) == TRUE){ 
      print(paste0("row ", k, ": Missing sample in hobo at date: ", samp.rates$Leaves.In[k]))
     y <- which(hobomeans$Date <= samp.rates$Leaves.In[k]) |>
           max()
      # y <- which(hobomeans$Date == samp.rates$Leaves.In[k])
    } else {
      y <- which(hobomeans$Date == samp.rates$Leaves.In[k])
    }
    if (is_empty(which(hobomeans$Date == samp.rates$Leaves.Out[k])) == TRUE){
      print(paste0("row ", k, ": Missing sample in hobo at date: ", samp.rates$Leaves.Out[k]))
      print(paste0("Last recorded date: ", max(hobomeans$Date)))
      #### Getting 
      # n = length(samp.rates$Leaves.Out) - k
      # x <- which(hobomeans$Date == samp.rates$Leaves.Out[k-n])
      x <- which(hobomeans$Date <= samp.rates$Leaves.Out[k]) |>
            max()
    } else {
      x <- which(hobomeans$Date == samp.rates$Leaves.Out[k])
    }
    #- Calculating means
    rango <- hobomeans[y:x,]
    nT <- nrow(rango)
    rows  <- data.frame(Sampling = k,
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
