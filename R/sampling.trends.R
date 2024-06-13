#'
#' Calculate the sampling rates using the baiting incidence and weather data
#' This function calculates hobo weather means for sampling rates 
#' Ex: phytophthora collected on dates for baited and removed leaves
#' @author Ricardo I Alcala Briseno, \email{alcalabr@@oregonstate.edu}
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
#' \dontrun{
#' samples <- read.cv(sampling.data)
#'
#' hobomeans <- meanhobo(hobocleaned)
#'
#' samp.rates <- samplingrates(samples, n = 9, round = 2)
#'
#' Site <- sampling.trends(hobomeans, samp.rates, round = 2)
#' }

sampling.trends <- function(hobomeans, samp.rates, round, na.rm = T ){
  rows = NULL
  for (k in 1:nrow(samp.rates)){
    if (purrr::is_empty(which(hobomeans$Date == samp.rates$Leaves.In[k])) == TRUE){ 
      cat(paste0("Missing in row ", k, ", start date: ", samp.rates$Leaves.In[k], '\r\n'))
     y <- which(hobomeans$Date <= samp.rates$Leaves.In[k]) |>
           max()
      # y <- which(hobomeans$Date == samp.rates$Leaves.In[k])
    } else {
      y <- which(hobomeans$Date == samp.rates$Leaves.In[k])
    }
    if (purrr::is_empty(which(hobomeans$Date == samp.rates$Leaves.Out[k])) == TRUE){
      cat(paste0("Missing in row ", k, ", end date: ", samp.rates$Leaves.Out[k], '\r\n'))
      cat(paste0("        Last recorded date: ", max(hobomeans$Date), '\r\n', 
                 "    NA's may be present as a result of missing dates, proceed with caution", '\r\n'))
      #### Getting 
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
                        mean.wet = mean(ifelse(test = isFALSE(na.rm) == T, 
                                                yes = round(mean(rango$x.Wetness), round), 
                                                 no = round(mean(rango$x.Wetness, na.rm = na.rm), round))),
                          # round(mean(rango$x.Wetness), round),
                        se.wet = round(stats::sd(rango$x.Wetness, na.rm = na.rm)/
                                         # sqrt(length(na.omit(rango$x.Wetness))), round),
                                         sqrt(ifelse(test = isFALSE(na.rm) == T, 
                                                yes = length(rango$x.Wetness), 
                                                 no = length(na.omit(rango$x.Wetness)))), round),
                        mean.temp = mean(ifelse(test = isFALSE(na.rm) == T, 
                                                yes = round(mean(rango$x.Temp), round), 
                                                 no = round(mean(rango$x.Temp, na.rm = na.rm),  round))),
                          # round(mean(rango$x.Temp), round),
                        se.temp = round(stats::sd(rango$x.Temp, na.rm = na.rm)/
                                          # sqrt(length(na.omit(rango$x.Temp))), round),
                                          sqrt(ifelse(test = isFALSE(na.rm) == T, 
                                                      yes = length(rango$x.Temp), 
                                                      no = length(na.omit(rango$x.Temp)))), round),
                        mean.max.temp = round(mean(rango$max.Temp), round),
                        mean.min.temp = round(mean(rango$min.Temp), round),
                        mean.RH = mean(ifelse(test = isFALSE(na.rm) == T, 
                                              yes = round(mean(rango$x.RH), round), 
                                               no = round(mean(rango$x.RH, na.rm = na.rm), round))),
                          #round(mean(rango$x.RH), round),
                        se.RH = round(stats::sd(rango$x.RH, na.rm = na.rm)/
                                        #sqrt(length(rango$x.RH)), round),
                                          sqrt(ifelse(test = isFALSE(na.rm) == T, 
                                                       yes = length(rango$x.RH), 
                                                        no = length(na.omit(rango$x.RH)))), round),
                        sum.rain = round(sum(rango$sum.Rain, na.rm = na.rm), round),
                        mean.max.rain = max(rango$sum.Rain, na.rm = na.rm),
                        mean.min.rain = min(rango$sum.Rain, na.rm = na.rm),
                        mean.rain = round(mean(rango$sum.Rain, na.rm = na.rm), round),
                        sd.rain = round(stats::sd(rango$sum.Rain, na.rm = na.rm)), #/
                                          # sqrt(length(na.omit(rango$x.Rain))), round),
                                          # sqrt(ifelse(test = isFALSE(na.rm) == T, 
                                          #            yes = length(rango$x.Rain), 
                                          #            no = length(na.omit(rango$x.Rain)))), round),
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
