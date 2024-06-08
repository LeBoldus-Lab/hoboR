
#' Reads HOBO data in CSV format
#' 
#' Two functions that read the original data downloaded from HOBO software
#' adding file names as metadata for each .csv file and cleans the data
#' from duplicates creating a continuous file from all .csv's
#'
#' @author Ricardo I Alcala Briseno, \email{alcalabr@@oregonstate.edu}
#' @param path select the path to the directory with the csv files
#' @param channels turn on or off additional channels in HOBO data logger, default "OFF"
#'
#' @return large csv file
#' 
#' @importFrom tidyr separate

#' @examples 
#' path_to_csvs <- '~mydirectory/myfiles.csv/'
#'
#' loadAllcsvs <- hobinder(path_to_csvs)
#'
#' finalcsv <- hobocleaner(loadAllcsvs)
#' 
#' @export
  
hobinder <- function(path, channels = "OFF", ...){
  if (file.exists(path)) {	
   # read files from working directory
  files <- list.files(path = path, pattern = "\\.csv", full.names = TRUE)
  } else {
	message("No such files in directory")
  return(NULL)
	}
    # get names from files
  names <- as.data.frame(files) |>
    tidyr::separate(files, into=c("names", "ext"), sep= "[.]")
  # load all .csv files
  hobos <- do.call(list,
               lapply(files, function(x) {
               read.csv(x, ...) #header = T, skip = 1)
               })
               )
  testcolumns <- colnames(hobos[[1]])
  if (any(grepl("Ch", testcolumns))){
    # replace Ch ... in some types of data logger
    hobos <- lapply(hobos, function(x) {
      colnames(x) <- gsub("Ch..\\d...", "", colnames(x))
      return(x)
    })
  }
  
  # hobinder habilitate channels = on, default channels = off
  if (channels == "ON" ) {
    col.names <- lapply(hobos, colnames)
    col.names <- lapply(col.names, function(x) gsub("\\.+", ".", x))
  } else {
    col.names <- lapply(lapply(hobos, colnames), 
                        function(x) sapply(strsplit(x, "[.]"), "[", 1))
  }
  
  # cleaning and formating 
  hobos <- Map(setNames, hobos, col.names)
  hobo <- reshape::merge_all(hobos, keep.all = T)
  hobo[,1] <- rownames(hobo)
  return(hobo[, !is.na(colnames(hobo))])
}
