#' Reads HOBO data in CSV format
#' 
#' Functions that cleans the original data downloaded from the HOBO software,
#' cleans the data and removes duplicates creating a continuous file from all .csv's
#' @author Ricardo I Alcala Briseno, \email{alcalabr@@oregonstate.edu}
#' 
#' @param file Get the binded CSV file from `hobinder` and remove duplicates to merge the data.
#' @param format Choose between month, day, and year (mdy) or year, month, and day (ymd) or
#'               year two digits, month and day (yymd)
#' @param na.rm TRUE or FALSE to remove NAs, TRUE is default    
#'            
#' @return data frame without duplicate values 
#' 
#' @importFrom lubridate mdy_hms ymd_hms
#' @importFrom dplyr arrange

#' @examples 
#' path_to_csvs <- "~/Documents/"
#' loadAllcsvs <- hobinder(path_to_csvs)
#' file <- hobocleaner(loadAllcsvs)
#' @export

hobocleaner <- function(file, format = "ymd", na.rm = T){
  temp <- file[,-1]
  temp <- temp[,apply(temp, 2, 
              function(col) !any(col %in% c("", "Logged")))]
  init <- dim(file)[1]
  if (format == "mdy"){ 
  # formating hobo dates to UTC
  temp$Date <- lubridate::mdy_hms(temp$Date, truncated = 1)
  }
  if (format == "ymd"){
  # formating hobo dates to UTC
  temp$Date <- lubridate::ymd_hms(temp$Date, truncated = 1)
  }
  if (format == "yymd"){
  # formating hobo dates to UTC ymd
  temp$Date <- gsub(":", "-", temp$Date)
  temp$Date <- gsub(" ", "-", temp$Date)
  temp$Date <- gsub("^", "20", temp$Date)
  temp$Date <- lubridate::ymd_hms(temp$Date, truncated = 1)
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
  #dat$By.Day <- as.Date(dat$Date)
  clean <- dim(dat)[1]
  cat(paste0(" proccesed: ", init, " all entries", "\n cleaned: ", init-clean, " duplicated entries", 
             "\n   total: ", clean, " unique entries \n" ))
  return(dat)
}
