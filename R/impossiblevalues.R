
#'  HOBO impossible values
#' 
#' Functions that gets the mean by date of the cleaned data downloaded from the 
#' HOBO software
#' @author Ricardo I Alcala Briseno, \email{alcalabr@@oregonstate.edu}
#' @param data Cleaned hobo data frame from `original csv` or `hobocleaner` and `hobotime`
#' @param showrows Number of rows to show for maximum values, default is 10
#' @return Gives the rows with impossible values
#' 
#' @importFrom dplyr group_by


#' @examples 
#' data <- hobocleaner(loadAllcsvs)
#' impossiblevalues(data)
#' @export

impossiblevalues <- function(data, showrows = 10, ...){
  top_vals <- matrix(NA, nrow = showrows, ncol = ncol(data), dimnames = list(NULL, names(data)))
  maxs <- apply(data[-1], 2, function(x) {
             rbind(head(sort(x, decreasing = TRUE), showrows), 
                        head(sort(x), showrows))
        })
  maxsor <- data.frame(apply(maxs, 2, sort, decreasing = T))
  # Adding five rows of NAs between head and tail
  na_rows <- matrix(".", nrow = 3, ncol = ncol(maxsor))|>
                    as.data.frame()
  colnames(na_rows) <- colnames(maxsor)
  maxsor <- rbind(head(maxsor, showrows), na_rows, tail(maxsor, showrows))
  for (i in colnames(maxsor)) {
    cat(paste("The max value for", i, "is", maxsor[1, i]), "- if uncertain, check for outliers or errors in your data.",  "\n")
  }
  
  return(maxsor)
}
