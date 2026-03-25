

#' Test HOBO data for calibration
#' 
#' Check if the times date are present in the list of HOBO files
#' @author Ricardo I Alcala Briseno, \email{ria5282@psu.edu}
#' @param data a list of CVS data containing hobo data 
#' @param times a series of times <- c("2022-03-22 01:00", "2022-03-22 02:00", 
#' "2022-03-22 03:00")
#' @return a data frame with the total entries and the count of entries present 
#' in each data set
#' 
#' @importFrom lubridate parse_date_time
#' 
#' @examples 
#' \dontrun{
#' data <- testhobolist(data, times)
#' }
#' @export

testhobolist <- function(data, times){
  
  time <- as.POSIXct(times, format = "%Y-%m-%d %H:%M", tz = "UTC")
  
  test <- lubridate::parse_date_time(
    data[[1]]$Date,
    orders = c("ymd HMS", "ymd HM", "mdy HMS", "mdy HM"),
    tz = "UTC"
  )
  
  if (!any(test %in% time, na.rm = TRUE)) {
    stop("The specified time ranges do not match any entries")
  }
  
  present <- lapply(data, function(df) {
    d <- lubridate::parse_date_time(df$Date, orders = c("mdy HMS", "mdy HM",
                                                        "ymd HMS", "ymd HM"), 
                                    tz = "UTC")
    d %in% time
  })
  
  tab <- lapply(present, function(p) table(factor(p, levels = c(FALSE, TRUE))))
  results <- do.call(rbind, tab)
  
  # results[,1] is FALSE count, results[,2] is TRUE count (guaranteed to exist)
  total <- results[,1] + results[,2]
  out <- cbind(`Total entries` = total, `Present entries` = results[,2])
  
  rownames(out) <- paste0("hobo", seq_along(data))
  return(out)
}

