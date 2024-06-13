#' Timestamp for Specific Intervals
#' 
#' This function provides a time point for a specified number of days.
#' HOBO software
#' 
#' @author Ricardo I Alcala Briseno, \email{alcalabr@@oregonstate.edu}
#' @name timestamp
#' @param data A data frame with the HOBO data and a `Date` column
#' @param stamp Provide a date
#' @param by Provide the interval date to present (e.g., "24 hours")
#' @param days Number of days for the interval
#' @param na.rm Logical, whether to remove NAs from the result
#' @param plot Logical, whether to generate a plot
#' @param var Variable to plot (default is "Temp")
#' 
#' @return A data frame summarized by minutes
#' 
#' @importFrom lubridate as_datetime
#' @importFrom lubridate is.Date
#' @importFrom scales date_format
#' @importFrom dplyr select
#' @importFrom ggplot2 ggplot geom_line scale_y_continuous ggtitle theme scale_x_datetime theme_bw
#' 
#' @examples 
#' \dontrun{
#' files <- hobinder()
#'
#' cleaned <- hobocleaner(files, format = "ymd")
#' 
#' timestamp <- timestamp(cleaned, stamp = "yyyy/mm/dd: ss", by = "24 hours", days = 100, na.rm = TRUE, plot = TRUE, var = "Temp")
#' }
#' @export 

utils::globalVariables(c("Date", "y"))

timestamp <- function(data, stamp = "yyyy/mm/dd: ss", by = "24 hours", days = 100, na.rm = T, plot = TRUE, var = "Temp") {
  stamptime <- as.POSIXct(stamp, format = "%Y-%m-%d %H:%M", tz = "UTC")
  range <- seq(from = stamptime, by = lubridate::duration(by), length.out = days )
  # select range
  if (!lubridate::is.Date(as.Date(stamptime))) {
    warning("value is not a Date")
  } else {
    if (!any(data$Date == stamptime)) {
      warning("Date out of range")
    } else {
      sstamp <- data[data$Date %in% range, ]
    }
  }  
  
  if (plot) {
   toplot <- sstamp |>
      dplyr::select(Date, y=`var`)
   
   # to plot
  plot <- ggplot2::ggplot(toplot, ggplot2::aes(x = as.POSIXct(Date), y = y )) +
       ggplot2::geom_line(alpha = 0.9, color = "orange") +
        ggplot2::scale_y_continuous(name = paste(var, "every", by)) +
        ggplot2::ggtitle(paste(var, "from", as.Date(toplot$Date[1]), 
          "to", as.Date(toplot$Date[days]))) +
        ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1)) +
        ggplot2::scale_x_datetime(labels = scales::date_format(format = "%Y-%m-%d"))+
        ggplot2::theme_bw() 
  } else {
  print("No plot")
  }
  return(list(data=sstamp, plot=plot))
}
