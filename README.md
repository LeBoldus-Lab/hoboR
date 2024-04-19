# hoboR
An R package for the analysis of  HOBO weather station data.
The HOBO files as CSV, time formats accepted: DD/MM/YYYY, MM/DD/YYYY, YY/MM/DD

## [Documentation](https://leboldus-lab.github.io/hoboR/)

[**manual.github.io/hoboR**](https://leboldus-lab.github.io/hoboR/)

## Install using devtools

This project is available on GitHub at `http://github.com/LeBoldus` and can be installed using `devtools`. We are working on a CRAN version.

```R
install.packages("devtools")
library("devtools")
# Installing hoboR through devtools
devtools::install_github("LeBoldus-Lab/hoboR")
library(hobor)
```

Required dependencies
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

Grant 123456, and XYZ.

## Contributors and Errors

Welcome pull submission through Github [pull request](https://help.github.com/articles/using-pull-requests/).
Please report any errors or requests using GitHub [issues](https://github.com/LeBoldus_Lab/hoboR/issues).
