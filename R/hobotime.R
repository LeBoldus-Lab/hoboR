
#'
#' Summarise HOBO data by time intervals
#'
#' This function calculates hobo weather by minutes
#' HOBO software
#' @author Ricardo I Alcala Briseno, \email{alcalabr@@oregonstate.edu}
#' @param data a data frame with the hobo data and a `Date` column  
#' @param summariseby a time interval in minmutes
#' @param na.rm logical vector TRUE or FALSE
#' @return a data frame summarised by minutes  
#'
#' @importFrom lubridate as_datetime
#'
#' @examples 
#' hobocleaned <- hobocleaner(files, format = "ymd")
#'
#' hobosubset <- hobotime(cleaned, summariseby = 5)

#' @export

hobotime <- function(data, summariseby = "5 mins", na.rm = T){
  t <- transform(data, Date = cut(Date, summariseby))
  data <- aggregate(.~Date, t, mean, na.rm = na.rm)
  data$Date <- lubridate::as_datetime(data$Date)
  return(data)
}