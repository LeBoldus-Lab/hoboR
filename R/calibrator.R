
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

calibrator <- function(data, formula = "y = a + b", times = c(12:00, 13:00, 14:00)){
  
}

# plot(1:dim(hobocleaned)[1], hobocleaned$Temperature, pch=4)

