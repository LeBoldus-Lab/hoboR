
#' Correction Test for HOBO data from calibrator
#' 
#' This function calculates the difference among HOBO loggers, finding the variance
#' and using it as a base correction. It's designed to adjust HOBO data based
#' on calibration files and specified thresholds.
#' 
#' @author Ricardo I Alcala Briseno, \email{alcalabr@@oregonstate.edu}
#' @param list.data A list of CSV data frames containing the HOBO data.
#' @param calibrationfile A data frame representing the calibration file.
#' @param w.var A vector of column indices to be used in the correction.
#' @param times A vector of times for which the data is relevant.
#' @param threshold A vector of threshold values for passing the correction test. The smaller the value the highest precision.
#' @return A data frame with the differences for data correction, to be used with a corrector.
#'
#' @importFrom dplyr group_by
#' @importFrom dplyr mutate
#' @importFrom dplyr select
#' @importFrom lubridate as_datetime
#'
#' @examples 
#' \dontrun{
#' path <- "~/Desktop/testsky/calibration/originalfiles/"
#'
#' calibrationfiles <- read.csv(paste0(path, "your_calibration_file.csv"))
#'
#' corrector(list.data, calibrationfiles, w.var = c("Temp", "Rain", "RH"), 
#'           times = c("2022-03-22 01:00", "2022-03-22 02:00", "2022-03-22 03:00"), 
#'           threshold = c(1, 5, 10))
#' }           
#' @export

correction.test <- function(list.data, calibrationfile, w.var = c("Temp", "Rain", "RH"), times = times, threshold = c(1, 5, 10)){
  
            # Convert times from character to POSIXct UTC times
            time=as.POSIXct(times, tz = "UTC")
            # Subset data by selected times 
            y <- lapply(list.data, function(df) {
              df[as.POSIXct(df$Date, tz = "UTC") %in% time, ]
            })
            
            # check if empty
            if (nrow(y[[1]]) == 0) {
              stop("Empty input")
            }
            # report if variables do not match
            if (!any(colnames(y[[1]]) %in% c("Date", w.var))){
            stop("Weather variables do not match")
            }
            
            # Correct data with calibration file to each CSV
            # z <- split(calibrationfile, seq(nrow(calibrationfile)))
            new <- mapply(function(y, z) {
              ss <- y[, w.var]
            }, y, SIMPLIFY = FALSE)
            
            # Subtract base HOBO from other HOBOs for correction
            base <- y[[1]][,w.var]
            corr <- lapply(new, function(df){
              base - df
            })
            
            # Calculate mean and compare with threshold
            res <- lapply(corr, function(df){
              x <- sapply(df, mean, na.rm = TRUE) 
              })
            
            res <- mapply(function(a, b){
              sapply(a, function(a){
                    ( b * -1 < a) | (a > b)
                  })
              }, res, threshold) |> t()
          
            result <- apply(res, c(1, 2), function(x) if(x) "passed" else "not passed")
            rownames(result) <- paste0("hobo", 1:nrow(result))
            
            # Print message
            testmessage <- ifelse(all(res), "HOBO's passed the test", "Warning: Some of your HOBO's did not pass the test.")
            message(testmessage)
            
            # result and message
            return(list(result = result, message = testmessage))
}
