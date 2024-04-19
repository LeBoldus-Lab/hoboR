

#' Test HOBO data for calibration
#' 
#' Check if the times date are present in the list of HOBO files
#' @author Ricardo I Alcala Briseno, \email{alcalabr@@oregonstate.edu}
#' @param data a list of CVS data containing the hobo 
#' @param times a series of times <- c("2022-03-22 01:00", "2022-03-22 02:00", "2022-03-22 03:00")
#' @return a data frame with the total entries and the count of entries present in each data set
#' 
#' @examples 
#' data <- testhobolist(data, times)

#' @export

testhobolist <- function(data, times){
        x <- lapply(data, function(x)  as.POSIXct(x$Date, tz="UTC") %in% as.POSIXct(times, tz="UTC"))
        y <- lapply(x, function(y) table(y))
        results <- do.call(rbind, y)
        results[,1] <- results[,1]+results[,2]
        rownames(results) <- paste0("hobo", 1:length(data))
        colnames(results) <- c("Total entries", "Present entries")
        return(results)
}
