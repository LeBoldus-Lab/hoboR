
#' calculate date range temperature using hobo data
#' This function calculates hobo weather means for sampling rates 
#' HOBO software
#' @author Ricardo I Alcala Briseno, \email{alcalabr@@oregonstate.edu}
#' @param data a data frame with the hobo data and a `Date` column  
#' @param start an early date in yyyy/mm/dd format
#' @param end a late date in yyyy/mm/dd format 
#' @return A data frame subset from start to end hobo range  
#'
#' @importFrom lubridate as_datetime


#' @examples 
#' samples <- read.cvs(sampling.data)
#' site.ranges <- ho.range(samples, start = "2021/11/02",  end = "2021/11/23")
#' @export
#' 

ho.range <- function(data, start = "1910-09-16 06:00", end = "1920-12-01 12:00", round, na.rm = T ){
  if (!is.Date(lubridate::as_datetime(start, format = "%Y-%m-%d %H:%M")) == F){
    print("date out of range")
  } else {
  x <- which(data$Date %in% lubridate::as_datetime(start, format = "%Y-%m-%d %H:%M"))|>
        min()
  }
  if (!is.Date(lubridate::as_datetime(end, format = "%Y-%m-%d %H:%M")) == F){
    print("date out of range")
  } else {
  y <- which(data$Date %in% lubridate::as_datetime(end, format = "%Y-%m-%d %H:%M")) |>
        max()
  }
  #- Calculating means
  rango <- data[y:x,]
  return(rango)
}
