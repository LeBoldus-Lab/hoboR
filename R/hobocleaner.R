
#' Reads HOBO data in CSV format
#' 
#' Functions that cleans the original data downloaded from the HOBO software
#' cleans the data and removes duplicates creating a continuous file from all .csv's
#' @author Ricardo I Alcala Briseno, \email{alcalabr@@oregonstate.edu}
#' @param file get the binded csv file from `hobinder`, and remove duplicates and merge the data 
#' @param format choose between month, day and year (mdy) or year, month and day (ymd) or
#'               year two digits, month and day (yymd)
#' @param na.rm TRUE or FALSE to remove NAs, TRUE is default               
#' @return dataframe with no duplicate values 
#' 
#' #' @importFrom lubridate ymd_hms
#' #' @importFrom dplyr

#' @examples 
#' path_to_csvs <- '~mydirectory/myfiles.csv/'
#' loadAllcsvs <- hobinder(path_to_csvs)
#' finalcsv <- hobocleaner(loadAllcsvs)
#' @export

hobocleaner <- function(file, format="ymd", na.rm = T){
  temp <- file[,-1]
  init <- dim(file)[1]
  if (format == "mdy"){ 
  # formating hobo dates to UTC
  temp$Date.Time <- lubridate::mdy_hms(temp$Date.Time, truncated = 1)
  }
  if (format == "ymd"){
  # formating hobo dates to UTC
  temp$Date.Time <- lubridate::ymd_hms(temp$Date.Time, truncated = 1)
  }
  if (format == "yymd"){
  # formating hobo dates to UTC ymd
  temp$Date.Time <- gsub(":", "-", temp$Date.Time)
  temp$Date.Time <- gsub(" ", "-", temp$Date.Time)
  temp$Date.Time <- gsub("^", "20", temp$Date.Time)
  temp$Date.Time <- lubridate::ymd_hms(temp$Date.Time, truncated = 1)
  }
  # rounding time and in order
  temp$Date.Time <- round(temp$Date.Time, units = "mins")
  temp = temp |> 
          dplyr::arrange(Date.Time)
  # get col names to construct function summarise
  cols <- colnames(temp)
  n <- 1:(length(cols)-1)
  m <- cols[1+n]
  writ <- capture.output(
    cat( "temp |> dplyr::group_by(Date.Time) |>",
       "dplyr::summarise(", 
                paste0(paste0(m, " = mean(", m, ", na.rm = ", na.rm, "),"  
                             )
                       )
        )
   )
  cmd <- gsub(",$", ")", writ)
  cmd <- str2expression(cmd)
  # evaluating command
  dat <- eval(cmd) 
  dat$Date <- as.Date(dat$Date.Time)
  clean <- dim(dat)[1]
  cat(paste0(" proccesed: ", init, " all entries", "\n cleaned: ", init-clean, " duplicated entries", 
             "\n   total: ", clean, " unique entries"))
  return(dat)
}
