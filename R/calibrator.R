
#' Calibrator HOBO data in CSV format
#' 
#' Calculates the difference between HOBO devices under controlled conditions. 
#' This additive function calculates the difference among hobo loggers using a 
#' base correction to HOBO loggers.
#' @author Ricardo I Alcala Briseno, \email{ria5282@psu.edu}
#' @param list.data A list containing the HOBO CSV files.
#' @param columns The columns to be used for calibration.
#' @param times The times in a vector of dates to be included in the calibration 
#'              process.
#' @param round The number of decimal places to round the results to.
#' @return a data frame with the differences for data correction, to use with 
#'          corrector
#' 
#' @importFrom dplyr group_by mutate
#' @importFrom lubridate as_datetime
#' 
#' @examples 
#'
#' path <- system.file("extdata/calibration", package = "hoboR")
#'  
#' folder=paste0(rep("canopy", 5), 1:5)
#' 
#' pathtoread = data = list()
#' 
#' for (i in seq_along(folder)){
#'   pathtoread[[i]] <- paste0(path, "/",folder[i])
#'   # Loading all hobo files
#'   data[[i]] <- hobinder(as.character(pathtoread[i]), header = TRUE, skip = 0,
#'    channels = "ON" ) # channels is a new feature
#' }
#' 
#' # Make sure you enter the date & time format with zeros, 
#' # for example 08:00 instead of 8:00 for 8am.
#' times <- c("2022-03-22 01:00", "2022-03-22 02:00", "2022-03-22 03:00", 
#'            "2022-03-22 04:00", "2022-03-22 05:00", "2022-03-22 06:00", 
#'            "2022-03-22 07:00", "2022-03-22 08:00", "2022-03-22 09:00") 
#'            
#' variables <- c(3, 8, 13) # Select the weather variables 
#'            
#' calibrationmeans <- calibrator(data, columns= variables, times = times) 
#'
#' @export

calibrator <- function(list.data, columns= c(2, 7, 12), times, round = 7){
  # from character to UTC times
  time=as.POSIXct(times, tz = "UTC")
  # format Date
  list.data <- lapply(list.data, \(x) { names(x)[grep("^Date", 
                                                      names(x))] <- "Date"; x })
  
  # subset by times of interest
  x <- lapply(list.data, function(df) {
    df[as.POSIXct(df$Date,  format = "%m-%d-%Y %H:%M:%S", 
                            tz = "UTC") %in% time, ]
  })
  
  
  # get the base columns
  base <- x[[1]][,columns]
  # subsampling only columns of interest
  sall <- lapply(x, function(df){
    df[, columns]
  })
  # subtracting hobo one from other hobo's for correction
  corr <- lapply(sall, function(df){
    tryCatch({ base - df
    }, error = function(cond) {
      # This execute an error
      if(grepl("'-' only defined for equally-sized data frames", cond$message))
      {
      warning("Input Error: Attempting to subtract data frames of unequal size. 
              Please make sure all hobo files have the same number of records.")
      } else {
        # If it's a different error, redo it
        stop(cond)
      }
      # Return a sensible default or NA to continue
      NA
    })
})
  # get the mean difference by hobo
  res <- lapply(corr, function(df){
          x <- sapply(df, mean, na.rm = TRUE) 
          as.data.frame(x)
    })
  res
  # to a dataframe
  calibration <- do.call(cbind, res)
  # present results
  results <- round(t(calibration), round)
  rownames(results) <- paste0("hobo", 1:length(x))
  return(results)
}
