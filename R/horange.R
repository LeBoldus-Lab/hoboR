
#' calculate date range temperature using hobo data
#' This function calculates hobo weather means for sampling rates 
#' HOBO software
#' @author Ricardo I Alcala Briseno, \email{alcalabr@@oregonstate.edu}
#' @param data a data frame with the hobo data and a `Date` column  
#' @param start an early date in yyyy/mm/dd format
#' @param end a late date in yyyy/mm/dd format 
#' @return A data frame subset from start to end hobo range  
#'
#' @importFrom lubridate is.Date


#' @examples 
#' samples <- read.cvs(sampling.data)
#' site.ranges <- ho.range(samples, start = "2021/11/02",  end = "2021/11/23")
#' @export
#' 

horange <- function(data, start = "yyyy/mm/dd", end = "yyyy/mm/dd", round, na.rm = T ){
  if (lubridate::is.Date(as.Date(start)) == F){
    print("date out of range")
  } else {
  x <- which(as.Date(hobocleaned$Date) == start)|>
        min()
  }
  if (lubridate::is.Date(as.Date(end)) == F){
    print("date out of range")
  } else {
  y <- which(as.Date(hobocleaned$Date) == end) |>
        max()
  }
  #- Calculating means
  rango <- hobocleaned[y:x,]
  return(rango)
}
