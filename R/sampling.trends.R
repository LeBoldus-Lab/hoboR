#'
#' Calculate the sampling rates using the baiting incidence and weather data
#' This function calculates hobo weather means for sampling rates 
#' Ex: phytophthora collected on dates for baited and removed leaves
#' @author Ricardo I Alcala Briseno, \email{ria5282@psu.edu}
#' @param hobomeans a data frame with the hobo means 
#' @param samp.rates a data frame with incidence summary of collected dates 
#' @param round Optional. Specifies the number of decimal places for rounding the output. 
#' @param na.rm remove NA's from data

#' @return A data frame with summarized weather variables by data and location, 
#' as incidence rates
#'
#' @importFrom purrr is_empty 
#' @importFrom dplyr group_by mutate select
#' @importFrom lubridate ymd
#' @importFrom stats sd na.omit
#' @examples 
#' 
#' path <- system.file("extdata/sampling", package = "hoboR")
#' 
#' hobomeans <- read.csv(paste0(path, "/", "hobomeans.csv"), as.is = TRUE) 
#' 
#' samples <- read.csv(paste0(path, "/", "sampling.csv"))
#'  
#' samp.rates <- sampling.rates(samples, n = 9, round = 2)
#' 
#' results <- sampling.trends(hobomeans, samp.rates, round = 2, na.rm = TRUE)
#' 
#' @export
    
sampling.trends <- function(hobomeans, samp.rates, round, na.rm = T ){
  
  hobomeans$Date <- as.POSIXct(hobomeans$Date, tz = "UTC")
  
  samp.rates$Leaves.In <- as.POSIXct(samp.rates$Leaves.In, tz = "UTC")
  samp.rates$Leaves.Out <- as.POSIXct(samp.rates$Leaves.Out, tz = "UTC")
  
  dat <- list()
  
  for(k in seq_len(nrow(samp.rates))){
    
    start <- samp.rates$Leaves.In[k]
    end   <- samp.rates$Leaves.Out[k]
    
    if(is.na(start) || is.na(end) || end < start){
      warning("Skipping row ", k, ": invalid date range")
      next
    }
    
    if(start > max(hobomeans$Date, na.rm = TRUE)){
      warning("Skipping row ", k, ": start date is after last HOBO record")
      next
    }
    
    y <- which(hobomeans$Date >= start)[1]
    x <- max(which(hobomeans$Date <= end))
    
    if(is.na(y) || is.infinite(x) || x < y){
      warning("Skipping row ", k, ": no HOBO data in this interval")
      next
    }
    
    rango <- hobomeans[y:x, ]
    nT <- nrow(rango)
    rows  <- data.frame(Sampling = k,
                        Sites = samp.rates$Sites[k], 
                        Location = samp.rates$Location[k], 
                        Treatment = samp.rates$Treatment[k], 
                        collection = samp.rates$Leaves.Out[k],
                        mean.wet = mean(ifelse(test = isFALSE(na.rm) == T, 
                                               yes = round(mean(rango$x.Wetness), 
                                                           round), 
                                               no = round(mean(rango$x.Wetness, 
                                                               na.rm = na.rm), round))),
                        
                        se.wet = round(stats::sd(rango$x.Wetness, 
                                                 na.rm = na.rm)/
                                         sqrt(ifelse(test = isFALSE(na.rm) == T, 
                                                     yes = length(rango$x.Wetness), 
                                                     no = length(na.omit(
                                                       rango$x.Wetness)))), round),
                        mean.temp = mean(ifelse(test = isFALSE(na.rm) == T, 
                                                yes = round(mean(rango$x.Temp), 
                                                            round), 
                                                no = round(mean(rango$x.Temp, 
                                                                na.rm = na.rm),  
                                                           round))),
                        
                        se.temp = round(stats::sd(rango$x.Temp, na.rm = na.rm)/
                                          
                                          sqrt(ifelse(test = isFALSE(na.rm) == T, 
                                                      yes = length(rango$x.Temp), 
                                                      no = length(na.omit(
                                                        rango$x.Temp)))), round),
                        #mean.max.temp = round(mean(rango$max.Temp), round),
                        #mean.min.temp = round(mean(rango$min.Temp), round),
                        mean.RH = mean(ifelse(test = isFALSE(na.rm) == T, 
                                              yes = round(mean(rango$x.RH), 
                                                          round), 
                                              no = round(mean(rango$x.RH, 
                                                              na.rm = na.rm), 
                                                         round))),
                        
                        se.RH = round(stats::sd(rango$x.RH, na.rm = na.rm)/
                                        
                                        sqrt(ifelse(test = isFALSE(na.rm) == T, 
                                                    yes = length(rango$x.RH), 
                                                    no = length(na.omit(
                                                      rango$x.RH)))), round),
                        sum.rain = round(sum(rango$sum.Rain, na.rm = na.rm), 
                                         round),
                        #mean.max.rain = max(rango$sum.Rain, na.rm = na.rm),
                        #mean.min.rain = min(rango$sum.Rain, na.rm = na.rm),
                        mean.rain = round(mean(rango$sum.Rain, na.rm = na.rm), 
                                          round),
                        sd.rain = round(stats::sd(rango$sum.Rain, 
                                                  na.rm = na.rm)),
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
