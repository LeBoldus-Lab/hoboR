
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

correction.test <- function(list.data=data, calibrationfile=x, columns = c(2, 7, 12), times = times, threshold = 1){
            # from character to UTC times
            time=as.POSIXct(times, tz = "UTC")
            # subset by times of interest
            y <- lapply(list.data, function(df) {
              df[df$Date %in% time, ]
            })
            # adding the calibration to each csv
            z <- split(calibrationfile, seq(nrow(calibrationfile)))
            new <-  mapply(function(y, z) {
                            y[,columns] +  z 
            }, y, z, SIMPLIFY = FALSE)
            # subtracting hobo one from other hobo's for correction
            base <- y[[1]][,columns]
            corr <- lapply(new, function(df){
              base - df
            })
            res <- lapply(corr, function(df){
              x <- sapply(df, mean, na.rm = TRUE) 
              x < threshold
            })
            res <- t(do.call(cbind, res))
            result <- apply(res, c(1, 2), function(x) if(x) "passed" else "not passed")
            rownames(result) <- paste0("hobo", 1:nrow(result))
            print(result)
            cat(ifelse(all(res), "HOBO's passed the test", 
                       "Warning: Some of your HOBO's did not passed the test"))
}
  