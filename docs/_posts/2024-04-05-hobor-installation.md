# Installing HOBOR

`HOBOR` installation via `devtools`, and in the process of submit it to CRAN. 

First, install `devtools` and dependency libraries
```R
install.packages("devtools")
library("devtools")
 devtools::install_github("LeBoldus-Lab/hoboR", force = TRUE)
library(hoboR)
```
Recommended dependencies

```R
library(lubridate)
library(tidyr)
library(dplyr)
library(reshape2)
library(ggplot2)i
library(scales)
```
## HOBOR components
| Function | Description | Features |
|--        |--           |--        |
|hobinder()| loads all CSV files | some columns in hobo files start at position 2, use `skip=1` to skip col 1|
|hobocleaner()| clean duplicate entries| choose the format = "ymd" output from your HOBO |
|hobomeans()| summarise the data by a time interval | you can select summariseby = "5 min", "12 h" or "1 day"| 
|horange() | selects a reange of dates | choose existing dates within your hobo files  start="2022-06-04" and  end="2022-10-22"|
|hobotime() | summarise time in minutes, hours or days |  summariseby = "5 mins" or "24 h"|
|impossiblevalues() | shows the maximum and minimum values | Select the number of rows to displya showrows = 3|
|NAsensorfailures() | detect the sensor failures and impossible values | select the conditional if values bigger than a threshold in the measurements of election  condition = ">",  threshold = c(50, 3000, 101), opt = c("Temp", "Rain", "Wetness"))|
|timestamp() | get a snapshot and plot the interval of your election for n days | timestamp(hobocleaned, stamp = "2022-08-05 00:01", by = "24 hours", days = 100, na.rm = TRUE, plot = T, var = "Temp") |
|horrelation()| display the correlation between variables) | The data can be summariseby time and by means |

