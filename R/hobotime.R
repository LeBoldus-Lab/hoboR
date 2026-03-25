
#' Summarise HOBO data by time intervals
#'
#' This function calculates hobo weather by minutes 
#' HOBO software
#' @author Ricardo I Alcala Briseno, \email{ria5282@psu.edu}
#' @name hobotime
#' @param data a data frame with the hobo data and a `Date` column  
#' @param summariseby a time interval in minmutes
#' @param na.rm logical vector TRUE or FALSE
#' @param na.action na.omit remove rows with NA's, na.pass keeps NA's 
#' @return a data frame summarized by minutes  
#'
#' @importFrom lubridate as_datetime
#' @importFrom stats aggregate
#'
#' @examples 
#' 
#' path <- system.file("extdata", package = "hoboR")
#' 
#' csvfiles <- hobinder(path, header = TRUE, skip = 1, channels = "OFF") 
#' 
#' subset <- hobotime(csvfiles, summariseby = 5, 
#'                     na.rm = TRUE, na.action = na.pass)
#' 
#' head(subset)
#' 
#' @export

hobotime <- function(data, summariseby = "5 mins", 
                     na.rm = TRUE, na.action = na.omit){
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

utils::globalVariables(c("Date"))