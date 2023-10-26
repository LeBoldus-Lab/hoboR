path = "~/Desktop/Adam/site_12_date_adj2/"
# the path file exist
file.exists(path)

# loading hobo files
hobofiles <- hobinder(path, header = T, skip=1) # header and skip col is a new feature
head(hobofiles)

# cleaning hobo files, add format
hobocleaned <- hobocleaner(hobofiles, format = "yymd")
head(hobocleaned)

plot(density(hobocleaned$Temp))

hobot <- hobotime(hobocleaned, summariseby = "5 mins", na.rm = T)
head(hobot)

meanhobo(hobocleaned, summariseby = "5 mins", na.rm = T)

meanhobo2(hobocleaned, summariseby = "24 h", na.rm = T, minmax = T)


horange(hobocleaned, start="2022-08-04", end="2022-12-06")
