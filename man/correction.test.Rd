% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/correction.test.R
\name{correction.test}
\alias{correction.test}
\title{Correction Test for HOBO data from calibrator}
\usage{
correction.test(
  list.data,
  calibrationfile,
  w.var = c("Temp", "Rain", "RH"),
  times = times,
  threshold = c(1, 5, 10)
)
}
\arguments{
\item{list.data}{A list of CSV data frames containing the HOBO data.}

\item{calibrationfile}{A data frame representing the calibration file.}

\item{w.var}{A vector of column indices to be used in the correction.}

\item{times}{A vector of times for which the data is relevant.}

\item{threshold}{A vector of threshold values for passing the correction test. The smaller the value the highest precision.}
}
\value{
A data frame with the differences for data correction, to be used with a corrector.
}
\description{
This function calculates the difference among HOBO loggers, finding the variance
and using it as a base correction. It's designed to adjust HOBO data based
on calibration files and specified thresholds.
}
\examples{
\dontrun{
path <- "~/Desktop/testsky/calibration/originalfiles/"

calibrationfiles <- read.csv(paste0(path, "your_calibration_file.csv"))

corrector(list.data, calibrationfiles, w.var = c("Temp", "Rain", "RH"), 
          times = c("2022-03-22 01:00", "2022-03-22 02:00", "2022-03-22 03:00"), 
          threshold = c(1, 5, 10))
}           
}
\author{
Ricardo I Alcala Briseno, \email{alcalabr@oregonstate.edu}
}
