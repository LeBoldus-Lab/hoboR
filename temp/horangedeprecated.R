#' Subset data within a date range
#' 
#' This function subsets data within a specified date range.
#' HOBO software
#' 
#' @author Ricardo I Alcala Briseno, \email{alcalabr@@oregonstate.edu}
#' 
#' @param data A data frame with the HOBO data and a `Date` column
#' @param start Start date for the subset (in "yyyy/mm/dd" format)
#' @param end End date for the subset (in "yyyy/mm/dd" format)
#' @param round Logical, whether to round the start and end dates to the nearest available dates in the data
#' @param na.rm Logical, whether to remove NAs from the result
#' 
#' @return A subset of the original data frame within the specified date range
#' 
#' @importFrom lubridate is.Date


#' @examples 
#' cleaned <- hobocleaner(data, format = "yymd")
#' site.ranges <- horange(cleaned, start = "2021/11/02",  end = "2021/11/23")
#' @export
#' 

horange <- function(data, start = "yyyy/mm/dd", end = "yyyy/mm/dd", round, na.rm = T ){
  # 
  start <- as.Date(start)
  end <- as.Date(end)
  #
  if (!lubridate::is.Date(start)){
    warning("start date is not a value format")
    return(NULL)
  } else {
    if (!any(as.Date(data$Date) == start)) {
      warning("start date is out of range")
    } else {
  x <- which(as.Date(data$Date) == start)|>
        min()
    }
  }  
  if (!lubridate::is.Date(as.Date(end))){
    warning("end date is not a value format")
    if (!any(as.Date(data$Date) == end)) {
      warning("end date is out of range")
  } else {
  y <- which(as.Date(data$Date) == end) |>
        max()
    }
  }  
  # subsetting range
  rango <- data[x:y,]
  return(rango)
}