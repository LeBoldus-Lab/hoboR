#'
#' Calculate Date Range Temperature Using HOBO Data
#'
#' This function calculates the means for weather data collected by HOBO loggers
#' over a specified date range. It's designed for use with data exported from HOBO software.
#'
#' @author Ricardo I Alcala Briseno, \email{ria5282@psu.edu}
#' @param data A data frame containing the HOBO data, including a `Date` column in POSIXct format.
#' @param start The start of the date range in "yyyy-mm-dd HH:MM" format.
#' @param end The end of the date range in "yyyy-mm-dd HH:MM" format.
#' @param na.rm A logical value indicating whether NA values should be removed before calculation.
#' @return A subset of the original data frame limited to the specified date range.
#'
#' @importFrom lubridate as_datetime
#'
#' @examples 
#' 
#' path <- system.file("extdata", package = "hoboR")
#' 
#' csvfiles <- hobinder(path, header = TRUE, skip = 1, channels = "OFF") 
#' 
#' cleancsv <- hobocleaner(csvfiles)
#'
#' site.ranges <- hoborange(cleancsv, start = "2022-08-04 09:05",  
#'                           end = "2022-10-04 09:05")
#' 
#' @export

hoborange <- function(data, start = "2022-08-04 09:05", 
                      end = "2022-10-04 09:05", 
                      na.rm = TRUE ){

  # convert start and end to POSIXct
  start <- try(as.POSIXct(start, tz = "UTC"), silent = TRUE)
  end <- try(as.POSIXct(end, tz = "UTC"), silent = TRUE)
  
  # Convert start and end to POSIXct
  if ( any(as.Date(data$Date) %in%  as.Date(start)) == FALSE){
    stop("Provided dates are out of range")
  } else {
  x <- which(as.Date(data$Date) %in% as.Date(start))|>
        min()
  }
  if (any(as.Date(data$Date) %in%  as.Date(end)) == FALSE){
    stop("Provided dates are out of range")
  } else {
  y <- which(as.Date(data$Date) %in% as.Date(end)) |>
        max()
  }
  
  #- Calculating means
  rango <- data[y:x,]
  
  if (nrow(rango) == 0) {
    warning("No data found in the provided range.")
  }
  return(rango[order(rango$Date, decreasing = FALSE),])
}
