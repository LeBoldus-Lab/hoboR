
#' Correction test for HOBO data from calibrator
#' 
#' Additive function to calculate the difference among hobo loggers to calibrate
#' using a base correction to the data
#' @author Ricardo I Alcala Briseno, \email{alcalabr@@oregonstate.edu}
#' @param data a list of CVS data containing the hobo 
#' @param w.var a column to correct the weather variable e.g., Temperature, RH (relative humidity), or FULL, will use the output of calibrator
#' @param calibrate a value to correct the weather variable, must be numeric or USEFILE, will use the output of calibrator 
#' @return a data frame with the differences for data correction, to use with corrector
#' 
#' @importFrom dplyr group_by
#' @importFrom dplyr mutate
#' @importFrom dplyr select
#' @importFrom lubridate as_datetime
#'
#' @examples 
#' \dontrun{
#' path = "~/Desktop/testsky/calibration/originalfiles/"
#'
#' filestocorrect <- calibritor(calibrationfiles)
#'
#' calibratedfiles <- correction(data, calibration, calibrate=)
#' }
#' @export

correction<- function(data, w.var = "FULL", calibrate =calibrate){
  if ( w.var == "FULL" ) {
    if ( all(colnames(calibrate) %in% colnames(data[[1]]))){
    # For each row in calibration results apply the correction to the data list 
      vars <- colnames(calibrate)
      cmd <- capture.output(
        cat( "lapply(seq_along(data), function(i) {\n",
              paste0("data[[i]]$",vars, " <- data[[i]]$", vars, " + calibrate[i,", "'",vars,"'", "]\n"),
             "return(data[[i]])})"
             )
           )
      cmd <- str2expression(cmd)
      # evaluating command
      dat <- eval(cmd)
      return(dat)
    } else {
      warning("Weather variables do not match")
    }
  } else {
    data[w.var] <- data[w.var] + as.numeric(calibrate)
    return(data)
    }
} 
