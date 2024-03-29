% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/horrelation.R
\name{horrelation}
\alias{horrelation}
\title{Correlation plot for variables within a time range}
\usage{
horrelation(data, summariseby = "month", by = "mean", na.rm = F)
}
\arguments{
\item{data}{A data frame with the HOBO data and a \code{Date} column}

\item{summariseby}{Provide the interval date to present (e.g., "month")}

\item{by}{Summary function for aggregation (e.g., "mean")}

\item{na.rm}{Logical, whether to remove NAs from the result}
}
\value{
A ggplot object representing the correlation heatmap
}
\description{
This function provides a time point for a specified number of days.
HOBO software
}
\examples{
files <- hobinder(path)
cleaned <- hobocleaner(files, format = "ymd")
correlation(cleaned, summariseby = "month", by = "mean", na.rm = FALSE)

}
\author{
Ricardo I Alcala Briseno, \email{alcalabr@oregonstate.edu}
}
