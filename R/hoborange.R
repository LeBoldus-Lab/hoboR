#'
#' Calculate Date Range Temperature Using HOBO Data
#'
#' This function calculates the means for weather data collected by HOBO loggers
#' over a specified date range. It's designed for use with data exported from HOBO software.
#'
#' @author Ricardo I Alcala Briseno, \email{alcalabr@@oregonstate.edu}
#' @param data A data frame containing the HOBO data, including a `Date` column in POSIXct format.
#' @param start The start of the date range in "yyyy-mm-dd HH:MM" format.
#' @param end The end of the date range in "yyyy-mm-dd HH:MM" format.
#' @param na.rm A logical value indicating whether NA values should be removed before calculation.
#' @return A subset of the original data frame limited to the specified date range.
#'
#' @importFrom lubridate as_datetime
#'
#' @examples 
#' \dontrun{
#' samples <- read.cvs(sampling.data)
#'
#' site.ranges <- ho.range(samples, start = "1910/09/16",  end = "1920/12/01")
#' }
#' @export

hoborange <- function(data, start = "1910-09-16 06:00", end = "1920-12-01 12:00", na.rm = T ){

  # convert start and end to POSIXct
  start <- try(as.POSIXct(start, tz = "UTC"), silent = TRUE)
  end <- try(as.POSIXct(end, tz = "UTC"), silent = TRUE)
  
  # Convert start and end to POSIXct, assuming data$Date is already in POSIXct or coerced it
  if ( any(as.Date(data$Date) %in%  start) == F){
    stop("Provided dates are out of range")
  } else {
  x <- which(as.Date(data$Date) %in% start)|>
        min()
  }
  if (any(as.Date(data$Date) %in%  end) == F){
    stop("Provided dates are out of range")
  } else {
  y <- which(as.Date(data$Date) %in% end) |>
        max()
  }
  
  #- Calculating means
  rango <- data[y:x,]
  
  if (nrow(rango) == 0) {
    warning("No data found in the provided range.")
  }
  return(rango[order(rango$Date, decreasing = F),])
}
