
#'  HOBO impossible values
#' 
#' Functions that gets the mean by date of the cleaned data downloaded from the 
#' HOBO software
#' @author Ricardo I Alcala Briseno, \email{alcalabr@@oregonstate.edu}
#' @param data cleaned hobo data frame from `original csv` or `hobocleaner` and `hobotime`
#' @param na.rm TRUE or FALSE to remove NAs, TRUE is default
#' @return gives the rows with impossible values
#' 
#' @importFrom dplyr group_by


#' @examples 
#' data <- hobocleaner(loadAllcsvs)
#' impossiblevalues(data)
#' @export

impossiblevalues <- function(data, ...){
  top_vals <- matrix(NA, nrow = 10, ncol = ncol(data), dimnames = list(NULL, names(data)))
  maxs <- apply(data[-1], 2, function(x) {
              top_vals[, names(x)] <<- rbind(head(sort(x, decreasing = TRUE), 10), 
                                             head(sort(x), 10))
        })
  maxsor <- data.frame(apply(maxs, 2, sort, decreasing = T))
  return(maxsor)
}
