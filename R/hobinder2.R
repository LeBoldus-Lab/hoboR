
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
#' loadAllcsvs <- hobinder(path_to_csvs)
#' finalcsv <- hobocleaner(loadAllcsvs)
#' @importFrom tidyr separate
#' @export
  
hobinder <- function(path, channels="OFF",...){
  # read files from working directory
  files <- list.files(path=path, pattern = "\\.csv", full.names = T)
  # get names from files
  names <- as.data.frame(files) |>
    tidyr::separate(files, into=c("names", "ext"), sep= "[.]")
  # load all .csv files
  hobos <- do.call(list,
               lapply(files, function(x) {
               read.csv(x, ...) #header = T, skip = 1)
               })
               )
  #hobocn <- lapply(hobos, colnames)
  
  # hobinder habilitate channels = on, default channels = off
  
  if (channels == "ON" ) {
    col.names <- lapply(hobos, colnames)
    col.names <- lapply(col.names, function(x) gsub("\\.+", ".", x))
  } else {
    col.names <- lapply(lapply(hobos, colnames), 
                        function(x) sapply(strsplit(x, "[.]"), "[", 1))
  }
  
  hobos <- Map(setNames, hobos, col.names)
  hobo <- reshape::merge_all(hobos, keep.all = T)
  hobo[,1] <- rownames(hobo)
  
  if (!lubridate::is.Date(hobo[, 2])) {
    # Convert text to POSIXct with the specified format
    hobo[,2] <- as.POSIXct(hobo[, 2], format = "%m/%d/%Y %H:%M:%S")
  }
  colnames(hobo)[2] <- "Date"
  # hobos <- Map(setNames, hobos, col.names)
  # hobo <- reshape::merge_all(hobos, keep.all = T)
  # hobo$X <- rownames(hobo)
  return(hobo[, !is.na(colnames(hobo))])
}
