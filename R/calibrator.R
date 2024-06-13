
#' Calibrator HOBO data in CSV format
#' 
#' Calculates the difference between HOBO devices under controlled conditions. This additive function calculates the difference among hobo loggers using a base correction to HOBO loggers.
#' @author Ricardo I Alcala Briseno, \email{alcalabr@@oregonstate.edu}
#' @param list.data A list containing the HOBO CSV files.
#' @param columns The columns to be used for calibration.
#' @param times The times in a vector of dates to be included in the calibration process.
#' @param round The number of decimal places to round the results to.
#' @return a data frame with the difrences for data correction, to use with corrector
#' 
#' @importFrom dplyr group_by mutate
#' @importFrom lubridate as_datetime


#' @examples 
#' path = "/Desktop//calibration/files/"

#'file.exists(path)

#'folder=paste0(rep("canopy", 24), 1:24)

#'a=b=d=list()

#'for (i in seq_along(folder)){
#'  a[[i]] <- paste0(path, folder[i])
#'  b[[i]] <- hobinder(as.character(a[i]), channels = "ON" )
#'  d[[i]] <- hobocleaner(b[[i]], format = "ymd")
#'}

#' data.calibrated <- calibritor(calibrationfiles)

#' @export

calibrator <- function(list.data, columns= c(2, 7, 12), times, round = 7){
  # from character to UTC times
  time=as.POSIXct(times, tz = "UTC")
  # subset by times of interest
  x <- lapply(list.data, function(df) {
    df[as.POSIXct(df$Date, tz = "UTC") %in% time, ]
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
      if(grepl("‘-’ only defined for equally-sized data frames", cond$message)) {
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
