
#' Calibrator HOBO data in CSV format
#' 
#' Additive function to calculate the difference among hobo loggers to calibrate
#' using a base correction to the data
#' @author Ricardo I Alcala Briseno, \email{alcalabr@@oregonstate.edu}
#' @param data a list of CVS data containing the hobo 
#' @param times a series of times <- c("2022-03-22 01:00", "2022-03-22 02:00", "2022-03-22 03:00")
#' @return a data frame with the difrences for data correction, to use with corrector
#' 
#' @importFrom dplyr group_by
#' @importFrom dplyr mutate
#' @importFrom dplyr select
#' @importFrom lubridate as_datetime


#' @examples 
#' path = "~/Desktop/testsky/calibration/originalfiles/"
#'file.exists(path)
#'folder=paste0(rep("canopy", 24), 1:24)
#'pathtoread=calibrationfiles=hobocleaned=data=list()
#'for (i in seq_along(folder)){
#'  pathtoread[[i]] <- paste0(path, folder[i])
#'  calibrationfiles[[i]] <- hobinder(as.character(pathtoread[i]), channels = "ON" ) # channels is a new feature
#'  data[[i]]=hobocleaned[[i]] <- hobocleaner(calibrationfiles[[i]], format = "ymd")
#'}
#' data.calibrated <- calibritor(calibrationfiles)
#' @export

calibrator <- function(list.data=data, formula = "y = a + b", columns= c(2, 7, 12), times = times, round = 7){
  # from character to UTC times
  time=as.POSIXct(times, tz = "UTC")
  # subset by times of interest
  x <- lapply(list.data, function(df) {
    df[as.POSIXct(df$Date, tz = "UTC") %in% time, ]
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
  # subtracting hobo one from other hobo's for correction
  corr <- lapply(sall, function(df){
    tryCatch({ base - df
    }, error = function(cond) {
      # This function is executed if an error occurs
      # Check if the error message matches the specific case you're interested in
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