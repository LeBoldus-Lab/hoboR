#'  HOBO Remove Values
#'  
#' This function is designed to identify and address values that are likely to 
#' be out of range, such as temperatures exceeding the maximum recorded in your 
#' study area or relative humidity (RH) values exceeding 100%, which are not 
#' feasible. The `sensorfailure()` function allows you to detect and flag these 
#' anomalous readings, facilitating the cleansing of your dataset by replacing 
#' all out-of-range values with NA's, maintaining the integrity and accuracy of 
#' of your data analysis. 
#' 
#' HOBO software
#' 
#' @param data Convert to NA the impossible values from HOBO data frame from `original csv` 
#'             OR `hobocleaner` OR `hobotime`
#' @param condition The condition for removal, one of (">", "<", "==", ">=", "<=")
#' @param threshold Numeric vector specifying the threshold values for removal
#' @param w.var weather variables, can be a single or multiple variables

#' @return Returns the data with NAs for the impossible values
#' 
#' @author Ricardo I Alcala Briseno, \email{alcalabr@@oregonstate.edu}
#' 
#' @importFrom dplyr group_by
#' 
#' @examples 
#' data <- hobinder(loadAllcsvs)
#' 
#' data_clean <- hobocleaner(data)
#' 
#' sensorfailures(data, condition = ">", threshold = c(50, 3000, 101), opt = c("Temp", "Rain", "Wetness"))
#' 
#' NAdata <- sensorfailures(data, condition = "<", threshold = c(0, 0), opt = c("Rain", "Wetness"))

#' @export


sensorfailures <- function(data, condition = ">", threshold = c(34, 8), w.var = c("Temp", "Rain")){
  if (!all(w.var %in% names(data))) {
    stop("One or more weather variables do not exist")
  }
  # functions 
  # replace with NA's greather than 
  greater_than <- function(a, b) {
    return(a > b )
  }
  # replace with NA's less than
  less_than <- function(a, b) {
    return(a < b)
  }
  # replace with NA's equal to 
  equal_to <- function(a, b) {
    return(a == b)
  }
  # replace with NA's equal or greather than
  equal_greater_than <- function(a, b) {
    return(a >= b)
  }
  # replace with NA's equal or less than
  equal_less_than <- function(a, b) {
    return(a <= b)
  }
  # main function to replace hobo values out of ranges 
  compare_numbers <- function(a, b, condition) {
    switch(condition,
           ">"  = greater_than(a, b),
           "<"  = less_than(a, b),
           "==" = equal_to(a, b),
           ">=" = equal_greater_than(a, b),
           "<=" = equal_less_than(a, b),
           stop("Invalid comparison operator")
    )
  }
  # Get the list of weather variable (columns)
  opt <- unlist(w.var)
  threshold <- unlist(threshold)
  # Loop through optional columns and apply the condition
  for (col in opt) {
    # print(col)
    if (col %in% names(data)) {
      val <- which(col == opt)
      sel <- which(col == names(data))
      # function
      data[sel][compare_numbers(data[sel], threshold[val], condition)] <- NA
      # data[col] <- comparison
    } else {
      warning(paste("Column", col, "not found in the dataset. Skipping..."))
    }
  }
  res <-  count_NAs(data, w.var)
  cat("Number of NA's removed:\n")
  sapply(names(res), function(col) {
    cat(col, ":", res[[col]], "\n")
  })
  return(data)
}