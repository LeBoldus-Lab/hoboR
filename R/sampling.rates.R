
#' Calculates sampling rates from a CSV format
#' 
#' This function calculates incidence and rates for baiting 
#' Phytophthora collected on dates for baited and removed leaves
#' HOBO software
#' 
#' @author Ricardo I Alcala Briseno, \email{ria5282@psu.edu}
#' @param samples a csv with the format 
#' @param n Mandatory. Specifies the number of replicates of the experiment
#' @param round Optional. Specifies the number of decimal places for rounding 
#' the output incidence calculated from a csv table designed for baiting 
#' Phytophthora
#' 
#' @return smaller data frame with incidence and rates
#' 
#' @importFrom dplyr group_by mutate select
#' @importFrom lubridate ymd
#' @importFrom stats na.omit
#'
#' @examples 
#' 
#' path <- system.file("extdata/sampling", package = "hoboR")
#' #' 
#' samples <- read.csv(paste0(path, "/", "sampling.csv"))
#'  
#' samp.rates <- sampling.rates(samples, n = 9, round = 2)
#' 
#' @export
 

sampling.rates <- function(samples, n, round) {
  colnames(samples) <- c("Sites", "Bucket", "Tree", "Location", "Treatment", 
                         "Week", "Leaves.In", "Leaves.Out", "Count")
  Incidence <- # generating incidence and incidence rates
    samples |>
    dplyr::group_by(Sites, Location, Tree, Treatment, Leaves.Out) |>
    dplyr::mutate(Incidence = sum(na.omit(Count))) |>
    dplyr::select(Sites, Tree, Location, Treatment, Week, 
                  Leaves.In, Leaves.Out, Incidence) |>
           unique() |>
    dplyr::mutate(Incidence.Rate = round(Incidence/n, round)) 
  Incidence$Leaves.In <- lubridate::ymd(Incidence$Leaves.In)
  Incidence$Leaves.Out <- lubridate::ymd(Incidence$Leaves.Out)
  return(Incidence)
}


utils::globalVariables(c("Sites", "Location", "Tree", "Treatment", "Leaves.Out",
                         "Count", "Week", "Leaves.In"))