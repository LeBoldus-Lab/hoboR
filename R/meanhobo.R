
#' mean HOBO data in CSV format
#' 
#' Functions that gets the mean by date of the cleaned data downloaded from the 
#' HOBO software
#' @author Ricardo I Alcala Briseno, \email{alcalabr@@oregonstate.edu}
#' @param mean and sd of the cleaned data frame `hobocleaner`
#' @return smaller data frame with means and standar deviation
#' 
#' @importFrom dplyr group_by
#' @importFrom dplyr mutate
#' @importFrom dplyr select


#' @examples 
#' cleanedcsv <- hobocleaner(loadAllcsvs)
#' mean.vars <- meanhobo(cleanedcsv)
#' @export

meanhobo <-
  function(cleandata){
    cleandata |>
      dplyr::group_by(Date) |>
      dplyr::mutate(x.Wetness = mean(na.omit(Wetness)),
             sd.Wetness = sd(na.omit(Wetness)),
             x.Temp = mean(na.omit(Temp)),
             sd.Temp = sd(na.omit(Temp)),
             x.RH = mean(na.omit(RH)),
             sd.RH = sd(na.omit(RH)),
             x.Rain = mean(na.omit(Rain)),
             sd.Rain = sd(na.omit(Rain))) |>
      dplyr::select(Date, x.Wetness, sd.Wetness,x.Temp, sd.Temp, 
             x.RH, sd.RH, x.Rain, sd.Rain) |>
      unique() 
  }
