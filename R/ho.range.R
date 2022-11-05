
#' calculate date range temperature using hobo data
#' This function calculates hobo weather means for sampling rates 
#' HOBO software
#' @author Ricardo I Alcala Briseno, \email{alcalabr@@oregonstate.edu}
#' @param data a data frame with the hobo data and a Date column  
#' @param start a data frame with incidence summary of collected dates 
#' @param end a data frame with incidence summary of collected dates 
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
# 
# start = "2021/11/02"
# end = "2021/11/23"

ho.range <- function(data, start = "yyyy/mm/dd", end = "yyyy/mm/dd", round, na.rm = T ){
  rows = NULL
  x <- which(hobocleaned$Date == start)|>
        min()
  y <- which(hobocleaned$Date == end) |>
        max()
    #- Calculating means
  rango <- hobocleaned[y:x,]
  return(dat)
}
