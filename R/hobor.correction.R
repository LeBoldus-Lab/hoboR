
#' Correction test for HOBO data from calibrator
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
#' data.calibrated <- calibritor(calibrationfiles)
#' @export
#' 

hobor.correction <- function(data, calibrationfile, columns = c(2, 7, 12)){
  
}