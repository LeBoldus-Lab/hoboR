#' Reads HOBO data in CSV format
#' 
#' Two functions that read the original data downloaded from HOBO software
#' adding file names as metadata for each .csv file and cleans the data
#' from duplicates creating a continuous file from all .csv's
#' @author Ricardo I Alcala Briseno, \email{alcalabr@@oregonstate.edu}
#' @param path to indicate the path to the csv files
#' @param files get the bind csv file, remove duplicates and merge the data 
#' @return large csv file
#' 
#' @examples 
#' path_to_csvs <- '~mydirectory/myfiles.csv/'
#' loadAllcsvs <- hobinderSpecial(path_to_csvs) # to order site 6, 11, 14, 19, 29 
#' finalcsv <- hobocleaner(loadAllcsvs)

#' @importFrom tidyr separate
#' @export

hobinderSpecial <- function(path){
  # read files from working directory
  files <- list.files(path=path, pattern = "\\.csv", full.names = T)
  # get names from files
  names <- as.data.frame(files) |>
    separate(files, into=c("names", "ext"), sep= "[.]")
  # load all .csv files
  hobos <- do.call(rbind,
                   lapply(files, function(x) {
                     read.csv(x, header =F, skip = 2)
                   })
  )
  colnames(hobos) <- c("tID","Date.Time", "Temp", "RH", "Wetness", "Rain")
  hobos <- hobos |> 
        select(tID, Date.Time, Wetness, Temp, RH, Rain)
  return(hobos)
}
