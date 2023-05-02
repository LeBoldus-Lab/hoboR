
#' mean HOBO data in CSV format
#' 
#' Functions that gets the mean by date of the cleaned data downloaded from the 
#' HOBO software
#' @author Ricardo I Alcala Briseno, \email{alcalabr@@oregonstate.edu}
#' @param data cleaned hobo data frame from `hobocleaner`
#' @param na.rm TRUE or FALSE to remove NAs, TRUE is default
#' @return smaller data frame with means and standard deviation
#' 
#' @importFrom dplyr group_by
#' @importFrom dplyr mutate
#' @importFrom dplyr select


#' @examples 
#' cleanedcsv <- hobocleaner(loadAllcsvs)
#' mean.vars <- meanhobo(cleanedcsv)
#' @export

meanhobo <-  function(data, summariseby = "24 hours", na.rm = T){
    # Preparing function content
    data <- transform(data, Date = cut(Date, summariseby))
    # data <- aggregate(.~Date, t, mean, na.rm = na.rm)
    # Getting mean hobo 
    cols <- colnames(data)
    n <- 1:(length(cols)-1)
    m <- cols[1+n]
    # m=m[1:length(m)-1]
    pos <- which(m %in% "Rain") 
    if((length(pos) == 0) == T){pos <-1}
    if (m[pos] == "Rain" ){
    writ <- capture.output(
      cat("dplyr::group_by(data, Date) |>",
          "dplyr::summarise(", 
           paste0(
             paste0(
               paste0("x.", m), " = mean(", m, ", na.rm = ", na.rm, "), ",  
               paste0("sd.", m), " = sd(", m,", na.rm = ", na.rm, "), ",
               paste0("sum.", m[pos]), " = sum(", m[pos],", na.rm = ", na.rm, "),"
               ))))
    } else {
      writ <- capture.output(
        cat("dplyr::group_by(data, Date) |>",
            "dplyr::summarise(", 
             paste0(
               paste0(
                 paste0("x.", m), " = mean(", m, ", na.rm = ", na.rm, "), ",  
                 paste0("sd.", m), " = sd(", m,", na.rm = ", na.rm, "),"
               ))))
    }
    # 
    cmd <- gsub(",$", ")", writ)
    cmd <- str2expression(cmd)
    eval(cmd)
}
