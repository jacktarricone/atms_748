# jack tarricone
# april 15th 2020
# atms 748 lab 3
# script for formatting the csv file
# plots will be attached in a markdown


library(ggplot2) # for plotting
library(dplyr) # for data manipulation
library(lubridate) # for dates and times
library(chron)
library(stringr)


#################
##### tiger ####
################

# read in csv and make room for colnames
tiger_data <-read.csv("/Users/jacktarricone/atms_748/atms748_lab3/tiger_data/CSV_21491.SlowResponse_0_2022_03_31_1247.dat",
                        header = FALSE)
head(tiger_data) # check

# read in ascii for information provided in the header
ascii_header <-as.vector(readLines("/Users/jacktarricone/atms_748/atms748_lab3/tiger_data/TOA5_21491.SlowResponse_0_2022_03_29_1527.dat",n=2))
print(ascii_header)


# rename columns using information in the ascii header
col_names <-c("year","doy","hour_min","sec","BattV_Min","PTemp_C","AirTC_Avg","RH","windSpeed","windDirection",
              "gustWindSpeed","AirTemp","DT_Avg","Q_Avg","TCDT_Avg","Rain_mm_Tot","T107_C_Avg",
              "BP_mbar_Avg","BattV_Avg","PTemp_C_Avg","SWin_Avg","SWout_Avg","LWin_Avg","LWout_Avg",
              "SWnet_Avg","LWnet_Avg","SWalbedo_Avg","NR_Avg")

# change col names
colnames(tiger_data) <- col_names
head(tiger_data) # check, looks good
tail(tiger_data)

# add in month column
month <-rep(4,nrow(tiger_data)) # only 4 because it's all in march
tiger_data <-cbind(tiger_data, month) # bind

# add day col by substractiong from doy col
tiger_data$day <-tiger_data$doy-89

# create date col
date <-mdy(paste0(tiger_data$month,"-",tiger_data$day,"-",tiger_data$year))
tiger_data$date <-date # data to big dataframe

#format time and paste, assuming all second values are 00
time <- sprintf("%04d", as.numeric(as.character(tiger_data$hour_min)))
tiger_data$time <-times(gsub("(..)(..)", "\\1:\\2:00", time))

# combine into one date and time columb using lubridate
tiger_data$date_time <- ymd_hms(paste(tiger_data$date, tiger_data$time))
head(tiger_data)

# filter off bad begining data
# tiger_data <-filter(tiger_data, date_time  >= "2022-02-01 18:50:00") 
# write.csv(tiger_data, "/Users/jacktarricone/atms_748/atms748_lab3/tiger_data.csv")


# read data back in and format date_time back to a date
tiger_data <-read.csv("/Users/jacktarricone/atms_748/atms748_lab3/tiger_data.csv")
tiger_data$date_time <-ymd_hms(tiger_data$date_time)

# quick test plot
theme_set(theme_classic(12))
ggplot(tiger_data) +
  geom_line(aes(x = date_time, y = SWin_Avg), size =.6, color = "red")
