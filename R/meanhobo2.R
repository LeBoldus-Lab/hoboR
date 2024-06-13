
#' mean HOBO data in CSV format
#' 
#' Functions that gets the summary statistics by summarizing by date the cleaned data downloaded from the HOBO software
#' @author Ricardo I Alcala Briseno, \email{alcalabr@@oregonstate.edu}
#' @name meanhobo
#' @param data cleaned hobo data frame from `hobocleaner`i
#' @param summarisedby select a time interval 60 min, 24 hours, 1 day 
#' @param na.rm TRUE or FALSE to remove NAs, TRUE is default
#' @param minmax TRUE or FALSE to retain min and max temperatures
#' @return smaller data frame with means and standard deviation
#' 
#' @importFrom dplyr group_by
#' @importFrom dplyr mutate
#' @importFrom dplyr select
#' @importFrom lubridate as_datetime
#' @importFrom utils capture.output
#' 
#' @examples 
#' \dontrun{
#' hoboclean <- hobocleaner(loadAllcsvs)
#' 
#' hobomeans <- meanhobo(cleanedcsv)
#' }

#' @export

utils::globalVariables("Date")

meanhobo <-  function(data, summariseby = "24 hours", na.rm = T, minmax=F){
  # if data frame is empty
  if (nrow(data) == 0) {
    warning("Empty input")
    return(file) 
  }
  
  # Preparing function content
  data <- transform(data, Date = cut(Date, summariseby))
  # Getting mean hobo 
  cols <- colnames(data)
  # parsing columns
  n <- 1:(length(cols)-1) 
  m <- cols[1+n]
  pos <- which(m %in% "Rain") 
  if((length(pos) == 0) == T){pos <-1}
  
  if (minmax == F){
    if (m[pos] == "Rain" ){
      operations <- capture.output(
        cat("dplyr::group_by(data, Date) |>",
            "dplyr::summarise(", 
            paste0(
              paste0(
                paste0("x.", m), " = mean(", m, ", na.rm = ", na.rm, "), ",  
                paste0("sd.", m), " = sd(", m,", na.rm = ", na.rm, "), ",
                paste0("sum.", m[pos]), " = sum(", m[pos],", na.rm = ", na.rm, "),"
              ))))
    } else {
      operations <- capture.output(
        cat("dplyr::group_by(data, Date) |>",
            "dplyr::summarise(", 
            paste0(
              paste0(
                paste0("x.", m), " = mean(", m, ", na.rm = ", na.rm, "), ",  
                paste0("sd.", m), " = sd(", m,", na.rm = ", na.rm, "),"
              ))))
    }
  } else {
    if (m[pos] == "Rain" ){
      operations <- capture.output(
        cat("dplyr::group_by(data, Date) |>",
            "dplyr::summarise(", 
            paste0(
              paste0(
                paste0("x.", m), " = mean(", m, ", na.rm = ", na.rm, "), ", 
                paste0("sd.", m), " = sd(", m,", na.rm = ", na.rm, "), ",
                paste0("sum.", m[pos]), " = sum(", m[pos],", na.rm = ", na.rm, "),",
                paste0("min.", m[m=="Temp"]), " = min(", m[m=="Temp"], ", na.rm = ", na.rm, "), ",
                paste0("max.", m[m=="Temp"]), " = max(", m[m=="Temp"], ", na.rm = ", na.rm, "),"
              ))))
    } else {
      operations <- capture.output(
        cat("dplyr::group_by(data, Date) |>",
            "dplyr::summarise(", 
            paste0(
              paste0(
                paste0("x.", m), " = mean(", m, ", na.rm = ", na.rm, "), ",  
                paste0("sd.", m), " = sd(", m,", na.rm = ", na.rm, "),",
                paste0("min.", m[m=="Temp"]), " = min(", m[m=="Temp"], ", na.rm = ", na.rm, "), ",
                paste0("max.", m[m=="Temp"]), " = max(", m[m=="Temp"], ", na.rm = ", na.rm, "),"
              ))))
    }
  }
  # 
  cmd <- gsub(",$", ")", operations)
  cmd <- str2expression(cmd)
  output <- eval(cmd)
  output$Date <- lubridate::as_datetime(output$Date)
  return(output)
}
