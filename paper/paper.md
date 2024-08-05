---
title: 'hoboR: An R package to summarize and manipulate weather station data.'
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
  - name: Adam R. Carson
    affiliation: "1,2"
  - name: Yung-Hsiang Lan
    affiliation: 1
  - name: Ebba Peterson
    affiliation: 1
  - name: Niklaus J. Grunwald 
    affiliation: "3"
  - name: Jared M. LeBoldus
    corresponding: true # (This is how to denote the corresponding author)
    affiliation: "1,2"

affiliations:
 - name: Botany and Plant Pathology, Oregon State University, OR, USA
   index: 1
 - name: Forest Engineering, Resources and Management, Oregon State University, OR, USA
   index: 2
 - name: Horticultural Crops Disease and Pest Management Research Unit, USDA ARS, Corvallis, OR
   index: 3
date: May 31 2024
bibliography: paper.bib

---

# Summary

Meteorological records from weather stations and data loggers can accumulate large datasets. Efforts to create weather station networks and smart agriculture have increased their use `[@:Estevez2011; @Lembrechts2021; @Hachimi2023]`. These large datasets can be difficult to analyze. HOBO (ONSET, United Kingdom) data loggers are among the most popular, affordable, and easy-to-use weather stations. However, the HOBO graphical interface does not conduct statistical analyses. To address this, we developed hoboR, an R package for reading, combining, and manipulating CSV files downloaded from HOBO weather stations. This package removes redundant data, creates meteorological summaries by time and date, identifies sensor failures and out-of-range values, and calculates summary statistics.

# Statement of need

HoboR is an R package `[@R2024]` for efficiently processing large datasets, by automating the loading of CSV files into a data frame structure specific to HOBO dataloggers. It reduces the time and effort required for data handling and increases the accuracy and reproducibility of analyses. HoboR functions remove duplicate entries, summarize the data by time intervals (minutes, hours, and/or days), and subset files by user-defined ranges. The package identifies and addresses data quality and accuracy issues related to sensor failures, out-of-range entries, time zone discrepancies, and data formats. 

This software facilitates the analysis of local weather and microclimate data. Typically, this data is used to correlate meteorological measurements with weather-dependent biological processes and various agricultural applications `[@Hachimi2023; @Dahl2023; @Nikolaou2023; @Wu2023]`. Traditional spreadsheet interfaces have difficulty handling large datasets, making data management time-consuming and error-prone and redundant data removal difficult. HoboR integrates advanced algorithms and user-friendly software, making it accessible to researchers and programmers with differing experience levels. It facilitates the implementation of meteorological data analysis in ecology, agriculture, and other sciences, improving data manipulation. Other packages to analyze weather data exist in Turbo Pascal `[@Pickering1994]`, and R packages have been developed to analyze weather data captured by satellites, including NASA Power and rnoaa `[@Sparks2018; @Chamberlain2023]`. However, to our knowledge no R package is available for collecting and analyzing large meteorological data sets from HOBO weather stations.

Weather station data is logged at various intervals for different sensors, including rain gauges, temperature, relative humidity (RH), leaf wetness, and solar radiation, among others.  The main functions of hoboR implement dynamic interpretation programming, processing spreadsheets with various HOBO sensors, and arranging the data into a standard column structure. The package outputs summary statistics (i.e., max, min, mean, and standard deviation) that can be summarized into different intervals (minute, hour, or day). Among the challenges when working with meteorological data are errors that occur during data collection. These errors include damage, debris blockage, malfunctioning sensors, and battery replacement resulting in errors that are difficult to detect and correct. HoboR functions can help identify and correct these errors and provide a framework to calibrate data loggers, which is essential for studying microclimates. A schematic representation of the processing pipeline is illustrated in Fig. 1.\autoref{fig:flowchart}.

![Flowchart hoboR.\label{fig:flowchart}](../docs/images/flowchart-hobor.png)
![A workflow for the hoboR package, describing the steps for effective data analysis using HOBO weather stations and data loggers. The process initiates by aggregating CSV files, summarizing duplicate entries, and parsing data chronologically. Subsequent steps include data analysis or further manipulation by time and range, complemented by a quality assessment to detect impossible values or other sensor failures. Optional calibration steps to enhance data accuracy. Solid lines indicate the standard workflow for HOBO data analysis, while discontinuous lines represent the optional calibration process.](flowchart.png){ width=80% }


# Example
The following example cleans and summarizes the test dataset collected in Brookings, Oregon, between August and December 2021 (Fig. 2)\autoref{fig:hobo-daynight} as part of  Carson (2022) thesis at the Botany and Plant Pathology Department at Oregon State University. We tested the package using partial datasets from different weather stations and data loggers. The code is reproduced below.

```R
# load library
library(hoboR)
# Analysis
# Select PATH to HOBO files
path = paste0("~/site_12_date_adj2/")
# load files
hobofiles <- hobinder(path, skip = 1)
hobocleaned <- hobocleaner(hobofiles, format = "yymd")
head(hobocleaned)
# get means summary by time
hobot5 <- hobotime(hobocleaned, summariseby = "30 mins", na.rm = T)
hobomeans5 <- meanhobo(hobot5, summariseby = "1 day",  na.rm = T)
head(hobomeans5)

# get means by date
hobomeans <- meanhobo(hobocleaned, summariseby = "24 h",  na.rm = T)
head(hobomeans)
# Specify range
timerange <- hoborange(hobocleaned, start="2022-08-08", end="2022-12-12")
head(timerange)
# get time interval 
a <- timestamp(hobocleaned, stamp = "2022-08-05 00:01", by = "24 hours",
               days = 100, na.rm = FALSE, plot = F, var = "Temp")
a$Group <- rep("night", nrow(a))
b <- timestamp(hobocleaned, stamp = "2022-08-05 12:01", by = "24 hours",
               days = 100, na.rm = FALSE, plot = F, var = "Temp")
b$Group <- rep("day", nrow(b))
daynight <- rbind(a, b)
# plot day and night 
ggplot(daynight, aes(x = Date, y = Temp, group = Group, color = Group)) +
  geom_line() +
  scale_x_datetime() +
  scale_y_continuous(limits = c(0, 30)) +
  scale_color_manual(values = c("orange", "black")) +
  labs(color = "Source") +
  scale_y_continuous(name = "Temperature °C")+
  scale_x_datetime(name = "Months")+
  theme_minimal()
```

![HOBO-daynight.\label{fig:hobo-daynight}](../docs/images/hobo-daynight.png)
![Figure 2: Temperature trends from August to December in Brookings, Oregon, processed using the hoboR package. The graph displays day and night temperatures recorded by HOBO weather stations, with the orange line representing daytime temperatures and the black line representing nighttime temperatures, demonstrating the diurnal temperature variations](figure.png){ width=80% }

This package requires R version 4.3.0 or later and the following packages:
data.table, dplyr, ggplot2, lubridate, plyr. These dependencies should be installed automatically when dependencies = TRUE is set in the command used to install the
package.

```R
> if (!require("devtools")) \\
> install.packages("devtools")\\
> devtools::install_github("leboldus_lab/hoboR", dependencies = TRUE)
```

# Authors contribution
Alcalá Briseño developed and maintained the package, wrote the documentation, debugged the code, and wrote the manuscript. Carson collected data, wrote and debugged the code. Lan collected the data, wrote code, and assisted with user-functionality. Peterson assisted in post-processing best practices. Grunwald assisted with manuscript preparation and funding. LeBoldus supervised the project, manuscript preparation, and funding.


# Citations


# Acknowledgements

United States Department of Agriculture Cooperative agreement number: 58-2072-1-039.

# Disclosure

None of the author's declare any conflict of interest.
