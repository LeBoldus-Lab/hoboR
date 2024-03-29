
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

times <- c("2022-03-22 01:00", "2022-03-22 02:00", "2022-03-22 03:00", "2022-03-22 04:00",
           "2022-03-22 05:00", "2022-03-22 06:00", "2022-03-22 07:00", "2022-03-22 08:00",
           "2022-03-22 09:00")
# I need to add the same time slot for all hobos used for calibration
# Do the substraction from hobo 1 to the rest of hobos within the same time slot 
# Create a list of input files 

calibrator <- function(list.data=data, formula = "y = a + b", columns= c(2, 7, 12), times = times, round = 7){
  # from character to UTC times
  time=as.POSIXct(times, tz = "UTC")
  # subset by times of interest
  x <- lapply(list.data, function(df) {
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
  # subtracting hobo one from other hobo's for correction
  corr <- lapply(sall, function(df){
              base - df
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
