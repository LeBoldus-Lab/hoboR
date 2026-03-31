
#' Correction Test for HOBO data from calibrator
#' 
#' This function calculates the difference among HOBO loggers, finding the 
#' variance and using it as a base correction. It's designed to adjust HOBO 
#' data based on calibration files and specified thresholds.
#' 
#' @author Ricardo I Alcala Briseno, \email{ria5282@psu.edu}
#' @param list.data A list of CSV data frames containing the HOBO data.
#' @param calibrationfile A data frame representing the calibration file.
#' @param w.var A vector of column indices to be used in the correction.
#' @param times A vector of times for which the data is relevant.
#' @param threshold A vector of threshold values for passing the correction test. 
#'                  The smaller the value the highest precision.
#' @return A data frame with the differences for data correction, to be used 
#'        with a corrector.
#'
#' @importFrom dplyr group_by
#' @importFrom dplyr mutate
#' @importFrom dplyr select
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
#' # Double-check you enter the same date format
#' times <- c("2022-03-22 01:00", "2022-03-22 02:00", "2022-03-22 03:00", 
#'             "2022-03-22 04:00","2022-03-22 05:00", "2022-03-22 06:00", 
#'             "2022-03-22 07:00", "2022-03-22 08:00","2022-03-22 09:00") 
#'             
#' variables <- c(3, 8, 13) # Select the weather variables 
#' 
#' meanvars <- calibrator(data, columns = variables, times = times)
#'  
#' correction.test(list.data = data, calibrationfile =  meanvars, 
#'                 w.var = variables, 
#'                 times = times, 
#'                 threshold = c(1, 5, 10))
#' @export

correction.test <- function(list.data, calibrationfile, 
                            w.var =c(3, 8, 13), 
                            times = times, threshold = c(1, 5, 10)){
  
            # Convert times from character to POSIXct UTC times
            time=as.POSIXct(times, tz = "UTC")
            # format Date
            list.data <- lapply(list.data, \(x) { 
                              names(x)[grep("^Date", names(x))] <- "Date"; x })
            
            # # Subset data by selected times 
            # y <- lapply(list.data, function(df) {
            #   df[as.POSIXct(df$Date,
            #       #format = "%m-%d-%Y %H:%M:%S", 
            #                   tz = "UTC") %in% time, ]
            # })
            
            y <- lapply(list.data, function(df) {
              idx <- lubridate::parse_date_time(
                df$Date,
                orders = c("ymd HMS", "ymd HM",
                           "mdy HMS", "mdy HM",
                           "dmy HMS", "dmy HM",
                           "ymdHMS", "mdyHMS", "dmyHMS"),
                tz = "UTC"
              )
              df[idx %in% time, , drop = FALSE]
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
            
            # Prepare a list for comparison
            thres <- rep(list(threshold), length(res))
            # Compare both     
            pass <- mapply(function(a, b){
                  ( b * -1 < a) | (a > b)
            }, res, thres) |> t()
            
            result <- apply(pass, c(1, 2), function(x) 
                                              if(x) "passed" else "not passed")
            rownames(result) <- paste0("hobo", 1:nrow(result))
            
            # Print message
            testmessage <- ifelse(all(pass), 
                                  "HOBO's passed the test", 
                        "Warning: Some of your HOBO's did not pass the test.")
            message(testmessage)
            
            # result and message
            return(list(result = result, message = testmessage))
}

