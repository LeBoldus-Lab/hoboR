# HOBOR::samplingtrends
This function is used to calculate hobo weather means for a given period of non-wether data collection. For example, in studies that implement baiting and/or traps for biological detection, such as insect traps or soil baiting for plant pathogens, the collected weather data can be summarized by the period of bating. 

In this example, weather data was collected at baiting sites for the oomycete pathogen _Phytophthora ramorum_. At each site, three buckets were filled with deionized water and baited with three tanoak leaves. Once launched, the data loggers collected weather data every minute continuously, and data was downloaded at the time of leaf bait collection. Leaves were deployed and collected every 7 to 28 days, and the baiting duration was based on seasonal weather predictions. 
# Reading bait sampling results
Import the bait data as a CSV file
```R
sampling <- read.csv("Bucket_Results_Adj.csv")
```
# Calculate the incidence rate
Now that the baiting results are loaded, samp.rates() calculates the incidence of occurence and rate of indidence per collection. In this example, there are 3 buckets containing 3 leaf baits for a total of 9 baits per site & collection. Thus, incidence will be returned on a scale of 0-9, and incidence rate on a scale of 0-1.    
```R
# n = is the total number of samples collected
samp.rates <- samplingrates(sampling, n = 9, round= 2)
```
# Get the summary by baits 
In order to optain a summary of the weather data by baiting period, the bait data file must include columns for bait deployment and collection, labeled "Leaves.In", "Leaves.out".
```R
# get the weather data summary for samples in and out 
summarybybaits <- sampling.trends(hobomeans, samp.rates, round = 2)
```
# Write you new combined data with
Now that your weather data is summarized by baiting period and combined with the baiting results, you can write a compreshensive .csv file for analysis. 
```R
write.csv(hobocleaned, "new_hobo_combined_file.csv")
```


<p>Funded by:</p>
<img src="../images/osu-usda-logo.png" alt="OSU Logo" style="width: 900px;"/>
