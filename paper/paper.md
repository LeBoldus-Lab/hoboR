---
title: 'Gala: A Python package for galactic dynamics'
tags:
  - R
  - weather
  - data loggers
  - summary statistics
  - data manipulation
authors:
  - name: Ricardo I. Alcalá Briseño
    orcid: 0000-0002-7031-2195
    equal-contrib: true
    affiliation: 1 # (Multiple affiliations must be quoted)
  - name: Adam R. Carson Peterson E, NJ, Grunwald, and LeBoldus, J.M.
    affiliation: "1,2"
  - name: Yung Hsiang Lan
    affiliation: 1
  - name: Ebba Peterson
    affiliation: 1
  - name: Niklaus J. Grunwald 
    affiliation: "1,3"
  - name: Jared M. LeBoldus
    corresponding: true # (This is how to denote the corresponding author)
    affiliation: "1,2"

affiliations:
 - name: Botany and Plant Pathology, Oregon State University, OR, USA
   index: 1
 - name: Forest Engineering, Resources & Management, Oregon State University, OR, USA
   index: 2
 - name: SDA ARS, Horticultural Crops Research Unit, OR, USA
   index: 3
date: 8 April 2024
bibliography: paper.bib

---

# Summary

HOBOR is an R package for efficiently processing large datasets obtained from HOBO (ONSET, United Kingdom) weather stations and data loggers. We developed multiple tools designed to curate and summarize weather data in various formats. Packages to analyze existing weather data captured by satellites are available in R, including NASA Power and rnoa [@Sparks:2018, @Chamberlain@2023] (Sparks 2018, Chamberlain and Hocking, 2023). Similar packages have not been developed for weather stations and data loggers. HOBOR allows users to load CSV files into a tibble format, eliminate duplicates, summarize data by time interval (minutes, hours, and/or days), and subset files by date ranges. The package can also address common data quality and accuracy issues related to sensor failures, identify out-of-range entries and time zone discrepancies, and correct data formats. Despite its name, HOBOR is adaptable to other weather station output formats with a similar data structure.
Weather station data can be logged at a variety of time intervals from different types of sensors, including rain gages, relative humidity sensors (RH), and light meters. HOBOR main functions implement dynamic interpretation programming, allowing the processing of spreadsheets independently for any number of sensors, and can adjust to a range of initial column structures. Among the difficulties in recording and collecting data are the errors that occur when replacing batteries, downloading data, and from malfunctioning sensors or loggers. These issues can create multiple entries that might be challenging and time-consuming to detect and curate in tabular data interfaces.
HOBOR tools seamlessly facilitate data manipulation, merging, and summarization, reducing curation time prior to downstream analysis and modeling. HOBOR was tested using csv files with hundreds to thousands of entries, facilitating the post-processing, loading csv files with variable header column order and dimensions, and summarizing data within seconds.  The summary statistics can be rounded to the nearest minute, hour, or day. Outputs include minimum, maximum, mean, and standard deviation of the data. Additional functions can help to identify and replace unrealistic values and correct the variation across data loggers. 

# Statement of need

`Developing automated software for preprocessing weather station and data logger information may facilitate the analysis of epidemiological surveillance and microbiome across disciplines [@Dahl:2023, @Nikolauo:2023, @Wu:2023] (Dahl et al., 2023; Nikolauo et al., 2023; Wu et al., 2023 ). Traditional spreadsheet interfaces pose a challenge when handling data from large and complex studies. The management and curation of these datasets are time-consuming and error-prone if done by hand. In many cases, the spreadsheet-based interfaces might not be able to handle an entire dataset at once. Automation of these tasks in HOBOR enhances accuracy and significantly reduces the time and effort required for data handling and management. The integration of advanced algorithms and user-friendly software makes it accessible to both experienced researchers and program beginners, addressing the current potential for implementing weather variables in plant pathology and disease ecology for effective management (Garrett et al., 2023). To our knowledge, no packages in R are available online for the analysis of weather station and data logger files. A graphic user interface for HOBO exists but is incompatible with data postprocessing and data manipulation.

# Example
A test dataset is provided with the HOBOR package. This data set was collected in China
Creek, Brookins, Oregon, between August to December 2021 (Fig. 1). We tested in partial
datasets from different weather stations and data loggers and a full dataset of millions of
entries. The test was carried out on a Dell PC (2016, 8 GB, Intel 5), a MacBook Pro (2022, 16 GB RAM, M2) and Ubuntu 22, Linux (2022, 128 Gb, RTX A4000) . The code and results are reproduced below:
```R
library(hobor)
# Add the PATH to your sites for weather data (from hobo)
path = ("Documents/site_1")
files <- hobinder(path, header = T, skip = 1) # loading all hobo files
cleaned <- hobocleaner(files, format = "ymd") # remvoe duplicate entries
summary <- meanhobo(cleaned, summariseby = "1 day", na.rm = T) # get the summary statistics by "1 day"
# data quality assessment
hobotime(cleaned, summariseby = "5 mins", na.rm = T) # rounds data every 5 minutes
hoborange(cleaned, start = "2022-08-04", end = "2022-08-10") # select a time window
impossiblevalues(cleaned, showrows = 3) # show impossible values
sensorfailures(cleaned, condition = ">", threshold = c(50, 3000, 101), opt = c("Temp", "Rain", RH)  # flag impossible values to NA
timestamp(cleaned, stamp = "2022-08-05 00:01", by = "24 hours", days = 100, na.rm = TRUE, plot = TRUE) # shows the trends by time range  .
InstallationL:
This package requires R version 4.3.0 or later. It also requires the following packages:
data.table, dplyr, ggplot2, lubridate, plyr, purrr. These dependencies should be installed
automatically when dependencies = TRUE is set in the command used to install the
package.
> if (!require("devtools")) \\
> install.packages("devtools")\\
> devtools::install_github("leboldus_lab/hobor", dependencies = TRUE)
```

# Authors contribution
Ricardo I. Alcalá Briseño developed the original version of the package, maintained the
package, wrote the documentation, debugged the code, and wrote the manuscript. Adam R.
Carson collected the data, wrote code implemented in the package, and debugged the code.
Sky Lan collected the data, wrote code implemented in the package, and assisted in the user-functionality of the code functions. Ebba Peterson assisted in best practices for post-processing. Jared M. LeBoldus supervised the project and participated in the manuscript drafting process.


# Citations

Sparks A (2018). “nasapower: A NASA POWER Global Meteorology, Surface Solar Energy
and Climatology Data Client for R.” The Journal of Open Source Software, ∗ 3 ∗
(30), 1035.doi : 10.21105/joss.01035 < https : //doi.org/10.21105/joss.01035 > .
Chamberlain, S., Hocking, D. (2023). rnoaa: ’NOAA’ Weather Data from R (Version
1.4.0). Retrieved from https://CRAN.R-project.org/package=rnoaa
Garrett et al., 2023 https://doi.org/10.1146/annurev-phyto-021021-042636
Dahl et al., 2023, https://doi.org/10.1111/1462-2920.16347
Nikolauo et al., 2023, https://doi.org/10.1016/j.envres.2023.117173
Wu et al., 2023, https://doi.org/10.1093/aob/mcad195


Citations to entries in paper.bib should be in
[rMarkdown](http://rmarkdown.rstudio.com/authoring_bibliographies_and_citations.html)
format.

If you want to cite a software repository URL (e.g. something on GitHub without a preferred
citation) then you can do it with the example BibTeX entry below for @fidgit.

For a quick reference, the following citation commands can be used:
- `@author:2001`  ->  "Author et al. (2001)"
- `[@author:2001]` -> "(Author et al., 2001)"
- `[@author1:2001; @author2:2001]` -> "(Author1 et al., 2001; Author2 et al., 2002)"

# Figures

Figures can be included like this:
![Caption for example figure.\label{fig:example}](figure.png)
and referenced from text using \autoref{fig:example}.

Figure sizes can be customized by adding an optional second parameter:
![Caption for example figure.](figure.png){ width=20% }

# Acknowledgements

Grant money No. 1234567890

