[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/hoboR)](https://CRAN.R-project.org/package=hoboR)

# hoboR
An R package for the analysis of  HOBO weather station data.
The HOBO files as CSV, time formats accepted: DD/MM/YYYY, MM/DD/YYYY, YY/MM/DD

## [Documentation](https://leboldus-lab.github.io/hoboR/)

[**manual.github.io/hoboR**](https://leboldus-lab.github.io/hoboR/)

## Install using devtools

This project is available on GitHub at `https://github.com/LeBoldus-Lab/hoboR` and can be installed using `devtools`. CRAN pending.

> For Windows
'install from R cran', then you need to install from the [Rtools45 installer](https://cran.r-project.org/bin/windows/Rtools/) or [64-bit ARM Rtools45 installer](https://cran.r-project.org/bin/windows/Rtools/).

> ggplo2 (4.0.1) incompatible with rlang, use ggplot2 4.0.0.

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
path <- "~/directory/csv_files"
```

```R
# Important data structure formsy, ypu may need to skip some rows
#  channels must bet set on OFF, unless you are calibrating [see calibration](https://leboldus-lab.github.io/hoboR//2024/04/05/hobor-calibration.html)
hobofiles <- hobinder(path, header = T, skip = 1, channels = "OFF") 
cleanfiles <- hobocleaner(hobofiles, format = "ymd")

# get summary statistics
hobodata <- meanhobo(cleanfiles, summariseby = "5 mins", na.rm = T)
```

Read the [**Manual**](https://leboldus-lab.github.io/hoboR/)


## License

This work is subject to the [MIT License](https://github.com/LeBoldus-Lab/hoboR/blob/main/LICENSE.md)

## Acknowledgements

United States Department of Agriculture Co-operative agreement number: 58-2072-1-039

## Contributors and Errors

Welcome pull submission through Github [pull request](https://github.com/LeBoldus-Lab/hoboR/pulls).
Please report errors or requests using GitHub [issues](https://github.com/LeBoldus-Lab/hoboR/issues).
