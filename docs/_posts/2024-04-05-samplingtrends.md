
Calculate sampling bait rates temperature using weather data and sampling rates for data collection
This function calculates hobo weather means for sampling rates 
Example: phytophthora collected on dates for baited and removed leaves

# reading bucke samples
sampling <- read.csv("Bucket_Results_Adj.csv") 
# Calculate the incidence rate  
# n = is the total number of samples collected
samp.rates <- samplingrates(sampling, n = 9, round= 2)

# Get the summary by baits 
summarybybaits <- sampling.trends(hobomeans, samp.rates, round = 2)

# Write you new combined data with
write.csv(hobocleaned, "new_hobo_combined_file.csv")
