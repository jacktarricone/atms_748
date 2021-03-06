# plotting time series data from HMP
# jan 26th, 2021
# ATMS 748
# by: Jack Tarricone

#install.packages("ggplot2","dplyr","lubridate","chron")
library(ggplot2) # for plotting
library(dplyr) # for data manipulation
library(lubridate) # for dates and times
library(chron)

# read in csv and make room for colnames
hmp_csv_data <-read.csv("/Users/jacktarricone/atms_748/lab2_data/Group_3/CSV_21490.SlowResponse_0_1.dat",
                        header = FALSE)
head(hmp_csv_data) # check

# read in ascii for information provided in the header
hmp_ascii_data <-read.table("/Users/jacktarricone/atms_748/lab2_data/Group_3/TOA5_21490.SlowResponse_0.dat")

# rename columns using information in the ascii header
colnames(hmp_csv_data) <- c("year","day","hour_min","sec","BattV_Min","PTemp_C","RH","AirTC_Avg")
head(hmp_csv_data) # check, looks good
tail(hmp_csv_data)

# add in observations column
obs <-seq(1,9921,1)
hmp_csv_data <-cbind(hmp_csv_data,obs) #bind to data frame

# add in month column
month <-rep(2,9921) # only 2 because it's all in feb
hmp_csv_data <-cbind(month, hmp_csv_data) # bind

# create date col
date <-mdy(paste0(hmp_csv_data$month,"-",hmp_csv_data$day,"-",hmp_csv_data$year))
hmp_csv_data$date <-date # data to big dataframe

#format time and paste, assuming all second values are 00
time <- sprintf("%04d", as.numeric(as.character(hmp_csv_data$hour_min)))
hmp_csv_data$time <-times(gsub("(..)(..)", "\\1:\\2:00", time))

# combine into one date and time columb using lubridate
hmp_csv_data$date_time <- ymd_hms(paste(hmp_csv_data$date, hmp_csv_data$time))
head(hmp_csv_data)

# test plot using obs number before date/time formatting
theme_set(theme_light(11)) # set theme for plotting

# air temp
ggplot(hmp_csv_data) +
  geom_line(aes(x = date_time, y = AirTC_Avg)) +
  
# RH
ggplot(hmp_csv_data) +
  geom_line(aes(x = date_time, y = RH))

# ptemp
ggplot(hmp_csv_data) +
  geom_line(aes(x = date_time, y = PTemp_C))

# test by filter for first 2000 obs
hmp_filt <-filter(hmp_csv_data, obs <=2000)

# RH filt
ggplot(hmp_filt) +
  geom_line(aes(x = date_time, y = RH))
            