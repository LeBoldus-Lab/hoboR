#' HOBO count NA's
#'  
#' This function counts the number of NA's in your data set
#' 
#' HOBO software
#' 
#' @param data dataframe with suspected NA's
#' @param w.var weather variables to test
#' @return Returns the numbers of  NAs for the impossible values
#' 
#' @author Ricardo I Alcala Briseno, \email{alcalabr@@oregonstate.edu}
#' 
#'  
#' @examples 
#' df <- hobocleaner(df)
#' 
#' sensorfailures(data, condition = ">", threshold = c(50, 3000, 101), w.var = c("Temp", "Rain", "Wetness"))

#' NAdata <- sensorfailures(data, condition = "<", threshold = c(0, 0), w.var = c("Rain", "Wetness"))

#' @export

count_NAs <- function(data, w.var) {
    # Clause to stop if conditions do not match
    if (!all(w.var %in% names(data))) {
      stop("One or more columns do not exist in the data frame")
    }
    na_count = list()
    # Count NA values in the specified column
    for( col in w.var){
    na_count[[col]] <- sum(is.na(data[[col]]))
    }
    # Return the count of NA values
    return(na_count)
  }
