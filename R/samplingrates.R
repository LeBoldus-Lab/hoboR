
#' calcula sampling rates from a CSV format
#' 
#' This function calculates incidence and rates for baiting 
#' phytophthora collected on dates for baited and removed leaves
#' HOBO software
#' @author Ricardo I Alcala Briseno, \email{alcalabr@@oregonstate.edu}
#' @param samples a csv with the format 
#' @param n Mandatory. Specifies the number of replicates of the experiment
#' @param round Optional. Specifies the number of decimal places for rounding the output.
#' incidence calculated from a csv table designed for baiting Phytophtora
#' @return smaller data frame with incidence and rates
#' 
#' @importFrom dplyr group_by mutate select
#' @importFrom lubridate ymd
#' @importFrom utils na.omit
#'
#' @examples 
#' samples <- read.cv(sampling.data)
#'
#' samp.rates <- samplingrates(samples)

#' @export
 
utils::globalVariables(c("Sites", "Location", "Tree", "Treatment", "Leaves.Out", "Count", "Week", "Leaves.In")) 

samplingrates <- function(samples, n, round) {
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
