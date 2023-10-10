# Package Name

[![Build Status](https://travis-ci.org/yourusername/packagename.svg?branch=master)](https://travis-ci.org/yourusername/packagename)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/packagename)](https://cran.r-project.org/package=packagename)
[![codecov](https://codecov.io/gh/yourusername/packagename/branch/master/graph/badge.svg)](https://codecov.io/gh/yourusername/packagename)

## Overview

The `hoboR` package allows you to efficiently analyze weather station data collected from multiple HOBO weather station setup (fixed weather station and portable devices). With hoboR, you can effortlessly import and consolidate data from multiple csv files, perform comprehensive time-based summaries, calculate the mean values for various environmental variables, and conveniently filter data within specified time ranges while identifying and handling any impossible values.


## Installation

You can install the package from CRAN using the following command:

```R
install.packages("packagename")
```

You can also install the package from devtools using the following command:
Install using `devtools`
```R
library("devtools")
devtools::install_github("LeBoldus-Lab/hoboR")
library(hoboR)
```


