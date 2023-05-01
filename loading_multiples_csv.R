# Example to load all te CSV for experiment 
## Manual 
SITE1 <- read.csv(paste0("site_", x, "_inc_results_by_site.csv"))
SITE2 <- read.csv(paste0("site_", x, "_inc_results_by_site.csv"))
SITE3 <- ...

BIGdataFRAME <- rbind(SITE1, SITE2, SITE3... SITE30)

## Automized 
# path to your CSV folders - only results sites
path="results_folder"
files <- list.files(path = path, pattern = "\\.csv", full.names = T)
# this function reads all CSVs in the directory and bind them ALL
BIGdataFRAME <- do.call(rbind, lapply(files, function(x) {
  read.csv(x, header = T)
}))[-1]
  
  