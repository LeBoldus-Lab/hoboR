
#' calcula sampling rates from a CSV format
#' 
#' This function calculates incidence and rates for baiting 
#' phytophthora collected on dates for baited and removed leaves
#' HOBO software
#' @author Ricardo I Alcala Briseno, \email{alcalabr@@oregonstate.edu}
#' @param samples a csv with the format 
#' incidence calculated from a csv table designed for baiting Phytophtora
#' @return smaller data frame with incidence and rates
#' 
#' @importFrom dplyr group_by
#' @importFrom dplyr mutate
#' @importFrom dplyr select
#' @importFrom lubridate ymd


#' @examples 
#' samples <- read.cv(sampling.data)
#' samp.rates <- samplingrates(samples)
#' @export
#' 
 
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
  samples$Leaves.In <- lubridate::ymd(samples$Leaves.In)
  samples$Leaves.Out <- lubridate::ymd(samples$Leaves.Out)
  return(Incidence)
}
