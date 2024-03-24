
#' mean HOBO data in CSV format
#' 
#' Functions that calculate the parameter to correct with calibrated data from the 
#' HOBO software
#' @author Ricardo I Alcala Briseno, \email{alcalabr@@oregonstate.edu}
#' @param data 
#' @return calibrated data frame 
#' 
#' @importFrom dplyr group_by
#' @importFrom dplyr mutate
#' @importFrom dplyr select
#' @importFrom lubridate as_datetime


#' @examples 
#' calibratedcsv <- calibritor(calibration-data)
#' @export

times <- c("2022-03-22 01:00", "2022-03-22 02:00", "2022-03-22 03:00", "2022-03-22 04:00",
           "2022-03-22 05:00", "2022-03-22 06:00", "2022-03-22 07:00", "2022-03-22 08:00",
           "2022-03-22 09:00")
# I need to add the same time slot for all hobos used for calibration
# Do the substraction from hobo 1 to the rest of hobos within the same time slot 
# Create a list of input files 

calibrator <- function(data, formula = "y = a + b", columns= c(2, 7, 12), times = times){
  # from character to UTC times
  time=as.POSIXct(times, tz = "UTC")
  # subset by times of interest
  x <- lapply(data, function(df) {
    df[df$Date %in% time, ]
  })
  # get the base columns - probably to remove
  # base <- lapply(x, function(df){
  #   df[1,columns]
  # })
  base <- x[[1]][,columns]
  # subsampling only columns of interest
  sall <- lapply(x, function(df){
    df[, columns]
  })
  # subtracting hobo one from other hobo's  
  corr <- lapply(sall, function(df){
              base - df
              })
  # get the mean difference by hobo
  res <- lapply(corr, function(df){
          mean <- sapply(df, mean, na.rm = TRUE) 
          as.data.frame(mean)
    })
  res
  # to a dataframe
  calibration <- do.call(cbind, res)
  # present results
  results <- round(t(calibration), 7)
  rownames(results) <- paste0("hobo", 1:length(x))
  return(results)
}rox
