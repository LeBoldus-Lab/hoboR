#' Correlation plot for variables within a time range
#' 
#' This function provides a time point for a specified number of days.
#' HOBO software
#' 
#' @author Ricardo I Alcala Briseno, \email{alcalabr@@oregonstate.edu}
#' 
#' @param data A data frame with the HOBO data and a `Date` column
#' @param summariseby Provide the interval date to present (e.g., "month")
#' @param by Summary function for aggregation (e.g., "mean")
#' @param na.rm Logical, whether to remove NAs from the result
#' @return A ggplot object representing the correlation heatmap
#' 
#' @importFrom lubridate cut
#' @importFrom reshape2 melt
#' @importFrom ggplot2 ggplot geom_tile scale_fill_gradient2 theme_minimal labs
#' @importFrom dplyr transform aggregate
#' 
#' @examples 
#' files <- hobinder(path)
#' cleaned <- hobocleaner(files, format = "ymd")
#' correlation(cleaned, summariseby = "month", by = "mean", na.rm = FALSE)
#' 
#' @export


horrelation <- function(data, summariseby = "month", by = "mean", na.rm = F){
  data <- dplyr::transform(data, Date = lubridate::cut(Date, summariseby)) |>
            dplyr::aggregate(.~Date, by, na.rm = na.rm)
  if (na.rm){
    c <- cor(as.matrix(data[,2:ncol(data)])) |>
          na.omit(c)
  } else {
    c <- cor(as.matrix(data[,2:ncol(data)]))
  }
  m <- reshape2::melt(c)
  q <- ggplot(m, aes(x = Var1, y = Var2, fill = value)) +
    geom_tile() +
    scale_fill_gradient2(low = "#0F52BA", high = "#D22B2B", mid = "beige", midpoint = 0) +
    theme_minimal() +
    labs(title = "Correlation Heatmap",
         x = NULL,
         y = NULL)
  return(q)
}



