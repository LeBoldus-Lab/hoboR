
#' Summarise HOBO data by time intervals
#'
#' This function calculates hobo weather by minutes 
#' HOBO software
#' @author Ricardo I Alcala Briseno, \email{alcalabr@@oregonstate.edu}
#' @name hobotime
#' @param data a data frame with the hobo data and a `Date` column  
#' @param summariseby a time interval in minmutes
#' @param na.rm logical vector TRUE or FALSE
#' @param na.action na.omit remove rows with NA's, na.pass keeps NA's 
#' @param ... arguments to be passed to methods
#' @return a data frame summarized by minutes  
#'
#' @importFrom lubridate as_datetime
#' @importFrom stats aggregate
#'
#' @examples 
#' \dontrun{
#' hobocleaned <- hobocleaner(files, format = "ymd")
#'
#' hobosubset <- hobotime(cleaned, summariseby = 5, na.rm = TRUE, na.action = na.pass)
#' }
#' @export

utils::globalVariables(c("Date"))

hobotime <- function(data, summariseby = "5 mins", na.rm = TRUE, na.action = TRUE){
  # check Date
  if (!"Date" %in% colnames(data)) {
    stop("Date not found")
  }
  
  # Check if empty
  if (nrow(data) == 0) {
    warning("Empty input")
    return(data) 
  }
  # transform to intervals
  int <- transform(data, Date = cut(Date, summariseby))
  
  # Aggregate data by 'Date' using the custom summary function
  data <- aggregate(. ~ Date, int, mean, na.rm = na.rm, na.action = na.action)
  
  data$Date <- lubridate::as_datetime(data$Date)
  return(data)
}
