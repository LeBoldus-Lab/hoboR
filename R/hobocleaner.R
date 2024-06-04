#' Reads HOBO data in CSV format
#' 
#' Functions that cleans the original data downloaded from the HOBO software,
#' cleans the data and removes duplicates creating a continuous file from all .csv's
#' @author Ricardo I Alcala Briseno, \email{alcalabr@@oregonstate.edu}
#' 
#' @param file CSV from `hobinder`
#' @param format Select the time format, month, day, and year (mdy), year, month, and day (ymd) or
#'               year two digits, month and day (yymd)
#' @param na.rm TRUE or FALSE to remove NAs, TRUE is default    
#'            
#' @return formatted data frame and duplicate values removed 
#' 
#' @importFrom lubridate mdy_hms ymd_hms dmy_hms
#' @importFrom dplyr arrange
#'
#' @examples 
#' path_to_csvs <- "path/to/hobo.csv"
#'
#' csvs <- hobinder(path_to_csvs)
#'
#' cleancsvs <- hobocleaner(csvs)
 
#' @export

hobocleaner <- function(file, format = "ymd", na.rm = T){
  temp <- file[,-1]  
  temp <- temp[,apply(temp, 2, 
              function(col) !any(col %in% c("", "Logged")))]
  init <- dim(file)[1]
  if (format == "mdy"){ 
  # formating hobo dates to UTC mdy
  temp$Date <- lubridate::mdy_hms(temp$Date, truncated = 1, tz = "UTC")
  }
  if (format == "ymd"){
  # formating hobo dates to UTC ymd
  temp$Date <- lubridate::ymd_hms(temp$Date, truncated = 1, tz = "UTC")
  }
  if (format == "dmy"){
    # formating hobo dates to UTC dmy
    temp$Date <- lubridate::dmy_hms(temp$Date, truncated = 1, tz = "UTC")
  }  
  if (format == "yymd"){
  # formating hobo dates to UTC yymd
  temp$Date <- gsub(":", "-", temp$Date)
  temp$Date <- gsub(" ", "-", temp$Date)
  temp$Date <- gsub("^", "20", temp$Date)
  temp$Date <- lubridate::ymd_hms(temp$Date, truncated = 1, tz = "UTC")
  }
  # rounding time and in order
  temp$Date <- round(temp$Date, units = "mins")
  temp = temp |> 
          dplyr::arrange(Date)
  # get col names to construct function summarise
  cols <- colnames(temp)
  n <- 1:(length(cols) - 1)
  m <- cols[1 + n]
  operations <- capture.output(
    cat( "temp |> dplyr::group_by(Date) |>",
       "dplyr::summarise(", 
                paste0(paste0(m, " = mean(", m, ", na.rm = ", na.rm, "),"  
                )
            )
        )
   )
  cmd <- gsub(",$", ")", operations)
  cmd <- str2expression(cmd)
  # evaluating command
  dat <- eval(cmd) 
  clean <- dim(dat)[1]
  cat(paste0(" proccesed: ", init, " all entries", "\n cleaned: ", init-clean, " duplicated entries", 
             "\n   total: ", clean, " unique entries \n" ))
  return(dat)
}
