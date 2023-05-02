
#' summarise date by specified intervals
#' This function calculates hobo weather by minutes
#' HOBO software
#' @author Ricardo I Alcala Briseno, \email{alcalabr@@oregonstate.edu}
#' @param data a data frame with the hobo data and a `Date` column  
#' @param summariseby= a time interval in minmutes
#' @return a data frame summarised by minutes  
#'
#' @importFrom lubridate is.Date


#' @examples 
#' files <- hobinder(path)
#' cleaned <- hobocleaner(files, format = "ymd")

#' cleanesum <- hobotime(cleaned, summariseby = 5)
#' @export
#' 

hobotime <- function(data, summariseby = "5 mins", na.rm = T){
  x <- data
  t <- transform(x, Date = cut(Date, summariseby))
  data <- aggregate(.~Date, t, mean, na.rm = na.rm)
  return(data)
}
