# hoboR
An R package for the analysis of  HOBO weather station data.
The HOBO files as CSV, time formats accepted: DD/MM/YYYY, MM/DD/YYYY, YY/MM/DD

## [Documentation](https://leboldus-lab.github.io/hoboR/)

[**manual.github.io/hoboR**](https://leboldus-lab.github.io/hoboR/)

## Install using devtools

This project is available on GitHub at `http://github.com/LeBoldus` and can be installed using `devtools`. We are working on a CRAN version.

> For Windows
'install from R cran', then you need to install from the [Rtools45 installer](https://cran.r-project.org/bin/windows/Rtools/rtools45/files/rtools45-6536-6492.exe) or [64-bit ARM Rtools45 installer](https://cran.r-project.org/bin/windows/Rtools/rtools45/files/rtools45-aarch64-6536-6492.exe).


```R
install.packages("devtools")
library("devtools")
# Installing hoboR through devtools
devtools::install_github("LeBoldus-Lab/hoboR")
library(hoboR)
```


Required dependencies if not installed
```r
install.packages("dplyr")
install.packages("plyr")
install.packages("lubridate")
install.packages("reshape")
install.packages("ggplot2")
install.packages("devtools")
```

------ 
HoboR usage

Download the `csv` files from `inst/extdata/`

```
path <- "~/inst/exdata"
```

```R
hobofiles <- hobinder(path)
cleanfiles <- hobocleaner(hobofiles, format = "ymd")
# get summary statistics
hobodata <- meanhobo(cleanfiles, summariseby = "5 mins", na.rm = T)
```
[**Manual**](https://leboldus-lab.github.io/hoboR/)


## License

This work is subject to the [MIT License](https://github.com/LeBoldus-Lab/hoboR/blob/main/LICENSE.md)

## Acknowledgements

United States Department of Agriculture Co-operative agreement number: 58-2072-1-039

## Contributors and Errors

Welcome pull submission through Github [pull request](https://help.github.com/articles/using-pull-requests/).
Please report errors or requests using GitHub [issues](https://github.com/LeBoldus_Lab/hoboR/issues).
