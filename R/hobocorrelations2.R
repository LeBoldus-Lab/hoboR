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
#' @importFrom stats aggregate na.omit cor
#' 
#' @examples 
#' \dontrun{
#' files <- hobinder(path)
#'
#' cleaned <- hobocleaner(files, format = "ymd")
#'
#' hobocorrelation(cleaned, summariseby = "month", by = "mean", na.rm = FALSE)
#' }
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
  
  #-- process by months 
  
  time_factor <- format(as.POSIXct(data$Date), "%Y-%m") |>
    as.factor() 

  data_time <- split_list <- split(data, time_factor)
  
  if( na.rm == T) {
  corr_time <-  lapply(data_time, function(df) {
    cor(df[,2:ncol(df)], use = "pairwise.complete.obs")
  }) 
  corr_time <- lapply(corr_time, na.omit())
  } else {
  corr_time <-  lapply(data_time, function(df) {
    cor(df[,2:ncol(df)], use = "pairwise.complete.obs")
  })
  }
  
  #-- process all
  
  if (na.rm == T){
   all_corr <- cor(as.matrix(data[,2:ncol(data)])) |>
         na.omit(c)
  } else {
    all_corr <- cor(as.matrix(data[,2:ncol(data)]))
  }
  
  #  cor(rbind(dm[[1]][,2:ncol(dm[[1]])], dm[[2]][,2:ncol(dm[[2]])])) # across months
  # c[upper.tri(c)] <- NA
  
  corr_list <- list(corr_time, 
              list(All = all_corr)
              )
  
  corr_list <- c(corr_list[[1]], corr_list[[2]])
  
  corr_mat <- lapply(corr_list, function(df) {
            df[upper.tri(df)] <- NA
            df
              })
  
  corr_mat <- Filter(function(m) length(m) > 0 && any(!is.na(m)), corr_mat)
  
  corr_long <- do.call(rbind, lapply(names(corr_mat), function(month) {
    m <- reshape2::melt(corr_mat[[month]])
    m$Month <- month
    m
  }))
  
  # Plot all as facets
  q <- ggplot(corr_long, aes(x = Var1, y = Var2, fill = value)) +
    geom_tile() +
    scale_fill_gradient2(
      low = "#0F52BA", high = "#D22B2B",
      mid = "beige", midpoint = 0, na.value = "white"
    ) +
    theme_minimal() +
    facet_wrap(~ Month) +
    labs(title = "Monthly Correlation Heatmaps", x = NULL, y = NULL)
  return(q)
} 
