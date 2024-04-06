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
#' @param round Logical indicating whether to round the results (not used in the example, consider removing or implementing).
#' @param na.rm A logical value indicating whether NA values should be removed before calculation.
#' @return A subset of the original data frame limited to the specified date range.
#'
#' @importFrom lubridate as_datetime
#'
#' @examples 
#' samples <- read.cvs(sampling.data)
#' site.ranges <- ho.range(samples, start = "1910/09/16",  end = "1920/12/01")
#' @export
#' 

ho.range <- function(data, start = "1910-09-16 06:00", end = "1920-12-01 12:00", na.rm = T ){
  # Convert start and end to POSIXct, assuming data$Date is already in POSIXct or coerced it
  if (!is.Date(lubridate::as_datetime(start, format = "%Y-%m-%d")) == F){
    print("Provided dates are out of range")
  } else {
  x <- which(data$Date %in% lubridate::as_datetime(start, format = "%Y-%m-%d"))|>
        min()
  }
  if (!is.Date(lubridate::as_datetime(end, format = "%Y-%m-%d")) == F){
    print("Provided dates are out of range")
  } else {
  y <- which(data$Date %in% lubridate::as_datetime(end, format = "%Y-%m-%d")) |>
        max()
  }
  
  #- Calculating means
  rango <- data[y:x,]
  
  if (nrow(rango) == 0) {
    warning("No data found in the provided range.")
  }
  return(rango)
}

