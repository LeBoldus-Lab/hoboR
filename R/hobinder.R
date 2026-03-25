
#' Reads HOBO data in CSV format
#' 
#' Two functions that read the original data downloaded from HOBO software
#' adding file names as metadata for each .csv file and cleans the data
#' from duplicates creating a continuous file from all .csv's
#'
#' @author Ricardo I Alcala Briseno, \email{ria5282@psu.edu}
#' @param path select the path to the directory with the csv files
#' @param channels turn on or off additional channels in HOBO data logger, default "OFF"
#' @param ... arguments to be passed to methods
#'
#' @return large csv file 

#' @importFrom tidyr separate
#' @importFrom utils read.csv
#' @importFrom stats setNames
#' @examples 
#' 
#' path <- system.file("extdata", package = "hoboR")
#' 
#' csvfiles <- hobinder(path, header = TRUE, skip = 1, channels = "OFF") 
#' 
#' head(csvfiles)
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
    tidyr::separate(files, into=c("names", "ext"), sep= "\\.(?=[^.]+$)")
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
  
  # cleaning and formatting 
  hobos <- Map(stats::setNames, hobos, col.names)
  hobo <- lapply(hobos, function(x) {
    na.omit(x[, head(seq_along(names(x)), max(which(names(x) != "X"))), 
      drop = FALSE])
  })
  # merging df
  hobo <- reshape::merge_all(hobo, keep.all = TRUE)
  hobo[,1] <- rownames(hobo)
  return(hobo[, !is.na(colnames(hobo))])
}
