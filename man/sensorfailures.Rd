% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sensorfailures.R
\name{sensorfailures}
\alias{sensorfailures}
\title{HOBO Remove Values

This function is designed to identify and address values that are likely to
be out of range, such as temperatures exceeding the maximum recorded in your
study area or relative humidity (RH) values exceeding 100\%, which are not
feasible. The \code{sensorfailure()} function allows you to detect and flag these
anomalous readings, facilitating the cleansing of your dataset by replacing
all out-of-range values with NA's, maintaining the integrity and accuracy of
of your data analysis.}
\usage{
sensorfailures(
  data,
  condition = ">",
  threshold = c(34, 8),
  w.var = c("Temp", "Rain")
)
}
\arguments{
\item{data}{Convert to NA the impossible values from HOBO data frame from \verb{original csv}
OR \code{hobocleaner} OR \code{hobotime}}

\item{condition}{The condition for removal, one of (">", "<", "==", ">=", "<=")}

\item{threshold}{Numeric vector specifying the threshold values for removal}

\item{w.var}{weather variables, can be a single or multiple variables}
}
\value{
Returns the data with NAs for the impossible values
}
\description{
HOBO software
}
\examples{
\dontrun{
data <- hobinder(loadAllcsvs)

data_clean <- hobocleaner(data)

sensorfailures(data, condition = ">", threshold = c(50, 3000, 101), opt = c("Temp", "Rain", "Wetness"))

NAdata <- sensorfailures(data, condition = "<", threshold = c(0, 0), opt = c("Rain", "Wetness"))
}
}
\author{
Ricardo I Alcala Briseno, \email{alcalabr@oregonstate.edu}
}
