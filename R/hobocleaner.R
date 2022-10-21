
#' Reads HOBO data in CSV format
#' 
#' Functions that cleans the original data downloaded from the HOBO software
#' cleans the data and removes duplicates creating a continuous file from all .csv's
#' @author Ricardo I Alcala Briseno, \email{alcalabr@@oregonstate.edu}
#' @param file get the binded csv file from `hobinder`, and remove duplicates and merge the data 
#' @return large clean csv file
#' 
#' #' @importFrom lubridate ymd_hms
#' #' @importFrom dplyr

#' @examples 
#' path_to_csvs <- '~mydirectory/myfiles.csv/'
#' loadAllcsvs <- hobinder(path_to_csvs)
#' finalcsv <- hobocleaner(loadAllcsvs)
#' @export

hobocleaner <- function(file){
  temp <- file[,2:6]
  init <- dim(file)[1]
  # formating hobo dates to UTC
  temp$Date.Time <- gsub(":", "-", temp$Date.Time)
  temp$Date.Time <- gsub(" ", "-", temp$Date.Time)
  temp$Date.Time <- gsub("^", "20", temp$Date.Time)
  temp$Date.Time <- lubridate::ymd_hms(temp$Date.Time, truncated = 1)
  temp$Date.Time <- round(temp$Date.Time, units = "mins")
  temp$Date <- as.Date(temp$Date.Time)
  temp = temp |> 
          dplyr::arrange(Date.Time)
  # mean repeated measurements by date
  dat <- temp |>
    dplyr::group_by(Date.Time) |>
    dplyr::summarise(Wetness = mean(Wetness, na.rm = T),
                        Temp = mean(Temp, na.rm = T),
                          RH = mean(RH, na.rm = T),
                        Rain = mean(Rain, na.rm = T))
  clean <- dim(dat)[1]
  cat(paste0(" proccesed: ", init, " all entries", "\n cleaned: ", init-clean, " duplicated entries", 
             "\n   total: ", clean, " unique entries"))
  return(temp)
}
