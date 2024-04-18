---
title: 'HOBOR: An R package to summarize and manipulate weather station data.'
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
 - name: USDA ARS, Horticultural Crops Research Unit, OR, USA
   index: 3
date: 8 April 2024
bibliography: paper.bib

---

# Summary

Meteorological records by weather stations and data loggers can produce large amounts of information, generating big data projects and complex data analysis for non-expert users. Regional and local efforts to create weather station networks, in addition to projects oriented to the study of microclimates and smart agriculture, have increased the use of weather stations in the last couple of decades `[@:Estevez2011; @Lembrechts2021; @Hachimi2023]`. HOBO (ONSET, United Kingdom) is among the most popular weather stations and data loggers. A graphic user interface HOBO software exists but is incompatible with post-process data analysis and big data. To close this gap, we have implemented a series of algorithms to combine and manipulate several csv files, allowing the summary of the data by time, subset by dates, evaluation of sensor failures and impossible values, and calculating the summary statistics of weather data. 

# Statement of need

HoboR is an R package `[@R2024]` for efficiently processing large datasets obtained from. We developed multiple tools designed to import, curate, and summarize weather data in csv format. Packages to analyze weather data exist in Turbo Pascal `[@Pickering1994]`, and current R packages to analyze weather data captured by satellites include NASA Power and rnoa `[@Sparks2018; @Chamberlain2024]`. HOBOR allows users to load csv files into a data frame and is automatically adaptable to HOBO sensor configurations, allowing the removal of duplicate entries, summarizing the data by time intervals (minutes, hours, and/or days), and subset files by date ranges. The package can also address common data quality and accuracy issues related to sensor failures, identify out-of-range entries and time zone discrepancies, and correct data formats. 

Developing software to automate the processing of weather stations and data loggers can facilitate the analysis of local weather and microclimate projects aimed at establishing epidemiological processes, ecological species composition, and smart agriculture, among other small-scale meteorological sciences `[@Hachimi2023; @Dahl2023; @Nikolaou2023; @Wu2023]`. Automating these tasks in HoboR enhances accuracy and significantly reduces the time and effort required for data handling and management, increasing the reproducibility of the analysis. On the other hand, traditional spreadsheet interfaces pose a challenge when handling data from large and complex studies, making managing and curating these datasets time-consuming and error-prone. In many cases, the spreadsheet-based interfaces might not be able to handle an entire dataset at once. The integration of advanced algorithms and user-friendly software makes it accessible to both experienced researchers and program beginners, addressing the current potential for implementing weather variables in plant pathology and disease ecology for effective management `[@Garrett2023]`. To our knowledge, no packages in R are available online for the analysis of weather station and data logger files.

HOBOR tools seamlessly facilitate data manipulation, merging, and summarization, thereby reducing curation time prior to downstream analysis and modeling. Weather station data can be logged at various time intervals for different types of sensors, including rain gauges, temperature, relative humidity (RH), and radiation, among others.  The main functions of HoboR implement dynamic interpretation programming, enabling the processing of spreadsheets independently for any number of sensors, and can transpose data into a range of initial column structures. Among the challenges in recording and collecting data are the errors that occur when the system is saturated, debris blocking the sensors, battery replacement, downloading data, and malfunctioning sensors or loggers. These issues can result in multiple entries that might be challenging and time-consuming to detect, correct, and curate in tabular data. HOBOR was tested using csv files with hundreds to thousands of entries, which facilitate the loading of csv files with variable header column order and dimensions, processing, and summarizing the data. The summary statistics can be rounded to the nearest minute, hour, or day. Outputs include the minimum, maximum, mean, and standard deviation of the data, as well as other functions that can help summarize the data by time intervals and a range of dates. Additionally, we provide functions that can help identify and replace unrealistic values and a framework to calibrate and correct the variation across data loggers \autoref{fig:flowchart}.


![Flowchart hoboR.\label{fig:flowchart}](flowchart-hobor.png)
![Flowillustrating the steps of the recommended HOBOR package. Data parsing, summary and subset of entries, quality checking, and summary statistics results. Optional calibration steps for HOBO data loggers. Discontinuous lines are optional; solid lines represent the recommended pipeline for HOBO data analysis.](flowchart.png){ width=20% }


# Example
A test dataset is provided with the HoboR package. This data set was collected in China
Creek, Brookins, Oregon, between August to December 2021 (Fig. 1). We tested in partial
datasets from different weather stations and data loggers. A full dataset consists of millions of
entries. The code is reproduced below.

```R
library(hobor)
# Standard Analysis
# Add the PATH to your sites for weather data (from hobo)
path = ("./site_A")
files <- hobinder(path, header = T, skip = 1) # loading all hobo files
cleaned <- hobocleaner(files, format = "ymd") # remvoe duplicate entries
sum <- hobotime(cleaned, summariseby = “5 mins”, na.rm = T) # rounds data every 5 minutes
summa <- hoborange(sum, start = "2022-08-04", end = "2022-08-10") # select a time range
summary <- meanhobo(summa, summariseby = "1 day", na.rm = T) # get the summary statistics by "24 h"

# Quality check
impossiblevalues(cleaned, showrows = 3) # show impossible values
sensorfailures(cleaned, condition = ">", threshold = c(50, 3000, 101), opt = c("Temp", "Rain", RH)  # flag impossible values to NA
timestamp(cleaned, stamp = "2022-08-05 00:01", by = "24 hours", days = 100, na.rm = TRUE, plot = TRUE) # shows the trends by time range  .
InstallationL:
```

This package requires R version 4.3.0 or later. It also requires the following packages:
data.table, dplyr, ggplot2, lubridate, plyr. These dependencies should be installed automatically when dependencies = TRUE is set in the command used to install the
package.
```R
> if (!require("devtools")) \\
> install.packages("devtools")\\
> devtools::install_github("leboldus_lab/hobor", dependencies = TRUE)
```

# Authors contribution
Ricardo I. Alcalá Briseño developed the original version of the package, maintained the package, wrote the documentation, debugged the code, and wrote the manuscript. Adam R. Carson collected the data, wrote code implemented in the package, and debugged the code. Sky Lan collected the data, wrote code implemented in the package, and assisted in the user-functionality of the code functions. Ebba Peterson assisted in best practices for post-processing of weather station and data loggers. Niklaus J. Grunwald participated in manuscript preparation, and funding. Jared M. LeBoldus supervised the project, manuscript preparation, and funding.


# Citations

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
![Flowchart hoboR.\label{fig:flowchart}](../docs/images/flowchart-hobor.png)
and referenced from text using \autoref{fig:flowchart}.

Figure sizes can be customized by adding an optional second parameter:
![Caption for example figure.](figure.png){ width=20% }

# Acknowledgements

This project by funded by grants JML and NJG, No. 
