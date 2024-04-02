
#' Correction Test for HOBO data from calibrator
#' 
#' This function calculates the difference among HOBO loggers to calibrate
#' the data using a base correction. It's designed to adjust HOBO data based
#' on calibration files and specified thresholds.
#' 
#' @author Ricardo I Alcala Briseno, \email{alcalabr@@oregonstate.edu}
#' @param list.data A list of CSV data frames containing the HOBO data.
#' @param calibrationfile A data frame representing the calibration file.
#' @param columns A vector of column indices to be used in the correction.
#' @param times A vector of times for which the data is relevant.
#' @param threshold A vector of threshold values for passing the correction test.
#' @return A data frame with the differences for data correction, to be used with a corrector.
#'
#' @importFrom dplyr group_by
#' @importFrom dplyr mutate
#' @importFrom dplyr select
#' @importFrom lubridate as_datetime
#'
#' @examples 
#' path <- "~/Desktop/testsky/calibration/originalfiles/"
#' calibrationfiles <- read.csv(paste0(path, "your_calibration_file.csv"))
#' corrector(list.data, calibrationfiles, columns = c(2, 7, 12), 
#'           times = c("2022-03-22 01:00", "2022-03-22 02:00", "2022-03-22 03:00"), threshold = c(1, 5, 10))
#' @export
#'


correction.test <- function(list.data=data, calibrationfile=x, columns = c(2, 7, 12), times = times, threshold = c(1, 5, 10)){
            # Convert times from character to POSIXct UTC times
            time=as.POSIXct(times, tz = "UTC")
            # Subset data by selected times 
            y <- lapply(list.data, function(df) {
              df[df$Date %in% time, ]
            })
            
            # Correct data with calibration file to each CSV
            z <- split(calibrationfile, seq(nrow(calibrationfile)))
            new <-  mapply(function(y, z) {
                            y[,columns] +  z 
            }, y, z, SIMPLIFY = FALSE)
            
            # Subtract base HOBO from other HOBOs for correction
            base <- y[[1]][,columns]
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
            
            print(result)
            
            cat(ifelse(all(res), "\033[32mHOBO's passed the test\033[39m\n", 
                       "\033[31mWarning: Some of your HOBO's did not passed the test.\033[39m\n"))
}
  