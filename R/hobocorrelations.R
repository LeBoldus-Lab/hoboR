#' Correlation plot for variables within a time range
#' 
#' This function provides a time point for a specified number of days.
#' HOBO software
#' 
#' @author Ricardo I Alcala Briseno, \email{alcalabr@@oregonstate.edu}
#' @name hobocorrelations
#' @param data A data frame with the HOBO data and a `Date` column
#' @param summariseby Provide the interval date to present (e.g., "month")
#' @param by Summary function for aggregation (e.g., "mean")
#' @param na.rm Logical, whether to remove NAs from the result
#' @return A ggplot object representing the correlation heatmap
#' 
#' @importFrom reshape2 melt
#' @importFrom ggplot2 ggplot geom_tile scale_fill_gradient2 theme_minimal labs
#' @importFrom stats aggregate
#' 
#' @examples 
#' files <- hobinder(path)
#'
#' cleaned <- hobocleaner(files, format = "ymd")
#'
#' hobocorrelation(cleaned, summariseby = "month", by = "mean", na.rm = FALSE)
#' 
#' @export

utils::globalVariables(c("Var1", "Var2", "value", "Date"))

hobocorrelations <- function(data, summariseby = "month", by = "mean", na.rm = FALSE){
  # if data frame is empty
  if (nrow(data) == 0) {
    warning("Empty input")
    return(file) 
  }
  # summarized data
  data <- transform(data, Date = cut(Date, summariseby)) |>
            aggregate(.~Date, by, na.rm = na.rm)
  if (na.rm){
    c <- cor(as.matrix(data[,2:ncol(data)])) |>
          na.omit(c)
  } else {
    c <- cor(as.matrix(data[,2:ncol(data)]))
  }
  m <- reshape2::melt(c)
  q <- ggplot2::ggplot(m, ggplot2::aes(x = Var1, y = Var2, fill = value)) +
    ggplot2::geom_tile() +
    ggplot2::scale_fill_gradient2(low = "#0F52BA", high = "#D22B2B", mid = "beige", midpoint = 0) +
    ggplot2::theme_minimal() +
    ggplot2::labs(title = "Correlation Heatmap",
         x = NULL,
         y = NULL)
  return(q)
}
