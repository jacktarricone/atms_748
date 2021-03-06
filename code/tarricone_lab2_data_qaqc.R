# jack tarricone
# atms 748 lab 2
# script for formatting all 5 groups time series data for plotting
# plots will be attached in a markdown


library(ggplot2) # for plotting
library(dplyr) # for data manipulation
library(lubridate) # for dates and times
library(chron)


#############################
##### our data (group 3) ####
#############################

# read in csv and make room for colnames
hmp_csv_data <-read.csv("/Users/jacktarricone/atms_748/lab2_data/Group_3/CSV_21490.SlowResponse_0_1.dat",
                        header = FALSE)
head(hmp_csv_data) # check

# read in ascii for information provided in the header
hmp_ascii_data <-readLines("/Users/jacktarricone/atms_748/lab2_data/Group_3/TOA5_21490.SlowResponse_0.dat")

# rename columns using information in the ascii header
colnames(hmp_csv_data) <- c("year","day","hour_min","sec","BattV_Min",
                            "PTemp_C","RH","AirTC_Avg","windSpeed","windDirection","gustWindSpeed","AirTemp")

hmp_csv_data$day <-hmp_csv_data$day -31
head(hmp_csv_data) # check, looks good
tail(hmp_csv_data)

# add in month column
month <-rep(2,nrow(hmp_csv_data)) # only 2 because it's all in feb
hmp_csv_data <-cbind(hmp_csv_data, month) # bind

# create date col
date <-mdy(paste0(hmp_csv_data$month,"-",hmp_csv_data$day,"-",hmp_csv_data$year))
hmp_csv_data$date <-date # data to big dataframe

#format time and paste, assuming all second values are 00
time <- sprintf("%04d", as.numeric(as.character(hmp_csv_data$hour_min)))
hmp_csv_data$time <-times(gsub("(..)(..)", "\\1:\\2:00", time))

# combine into one date and time columb using lubridate
hmp_csv_data$date_time <- ymd_hms(paste(hmp_csv_data$date, hmp_csv_data$time))
head(hmp_csv_data)

# filter off bad begining data
hmp_csv_data <-filter(hmp_csv_data, date_time  >= "2022-02-01 18:50:00") 
#write.csv(hmp_csv_data, "/Users/jacktarricone/atms_748/data-code/lab2_data/csvs/jack_eric.csv")


# read data back in and format date_time back to a date
hmp_csv_data <-read.csv("/Users/jacktarricone/atms_748/data-code/lab2_data/csvs/jack_eric.csv")
hmp_csv_data$date_time <-ymd_hms(hmp_csv_data$date_time)

# quick test plot
theme_set(theme_classic(12))
ggplot(hmp_csv_data) +
  geom_line(aes(x = date_time, y = AirTC_Avg), size =.6, color = "red")

##########################
######## group 1 #########
##########################

g1 <-read.csv("/Users/jacktarricone/atms_748/data-code/lab2_data/Lab_2/Group_1/CSV_21491.SlowResponse_1_2022_01_25_1647.dat",
              header = TRUE)

g1_ascii <-readLines("/Users/jacktarricone/atms_748/data-code/lab2_data/Lab_2/Group_1/TOA5_21491.SlowResponse_1_2022_01_25_1647.dat") 
head(g1_ascii)

# remove first unwanted col
g1 <- g1[-c(1)]
head(g1)

# rename columns using information in the ascii header from g1
colnames(g1) <- c("year","day","hour_min","sec","BattV_Min","PTemp_C","AirTC_Avg",
                  "RH","windSpeed","windDirection","gustWindSpeed","AirTemp")

# turn day into dom
# g1$day <-g1$day -28
# head(g1) # check, looks good
# tail(g1)

# add in month column, switch months
nday_janv1 <-filter(g1, day <= 31)
nday_jan <-as.integer(nrow(nday_janv1))

month_jan <-rep(1, nday_jan) 
month_feb <-rep(2, nrow(g1) - nday_jan)
month <-c(month_jan, month_feb)
g1 <-cbind(g1, month) # bind

### add new day col
# jan
day_janv1 <-filter(g1, day <= 31)
day_jan <-day_janv1$day

# feb
day_feb <-filter(g1, day > 31)
day_feb <-day_feb$day - 31

# add col
new_day <-c(day_jan, day_feb)
head(new_day)
g1$new_day <-new_day

# create date col
date <-mdy(paste0(g1$month,"-",g1$new_day,"-",g1$year))
g1$date <-date # data to big dataframe

#format time and paste, assuming all second values are 00
time <- sprintf("%04d", as.numeric(as.character(g1$hour_min)))
g1$time <-times(gsub("(..)(..)", "\\1:\\2:00", time))

# combine into one date and time columb using lubridate
g1$date_time <- ymd_hms(paste(g1$date, g1$time))
head(g1)

# filter off bad data in beginning
# g1 <-filter(g1, date_time  >= "2022-01-25 17:05:00") 

ggplot(g1) +
  geom_line(aes(x = date_time, y = RH), size =.6)

head(g1)
write.csv(g1, "/Users/jacktarricone/atms_748/data-code/lab2_data/csvs/lab2_g1.csv")



##########################
######## group 2 #########
##########################


g2 <-read.csv("/Users/jacktarricone/atms_748/data-code/lab2_data/Lab_2/Group_2/CSV_21494.SlowResponse_1_2022_01_25_1705.txt",
              header = TRUE)

g2_ascii <-readLines("/Users/jacktarricone/atms_748/data-code/lab2_data/Lab_2/Group_2/TOA5_21494.SlowResponse_1_2022_01_25_1705.dat") 
head(g2_ascii)

# remove first unwanted col
# g2 <- g2[-c(1)]
head(g2)

# rename columns using information in the ascii header from g2
colnames(g2) <- c("year","day","hour_min","sec","BattV_Min","PTemp_C",
                  "AirTC_Avg","RH","windSpeed","windDirection","gustWindSpeed","AirTemp")

# turn day into dom
# g2$day <-g2$day -28
# head(g2) # check, looks good
# tail(g2)

# add in month column, switch months
nday_janv1 <-filter(g2, day <= 31)
nday_jan <-as.integer(nrow(nday_janv1))
month_jan <-rep(1, nday_jan) 
month_feb <-rep(2, nrow(g2) - nday_jan)
month <-c(month_jan, month_feb)
g2 <-cbind(g2, month) # bind

### add new day col
# jan
day_jan <-filter(g2, day <= 31)
day_jan <-day_jan$day

# feb
day_feb <-filter(g2, day > 31)
day_feb <-day_feb$day - 31

# add col
new_day <-c(day_jan, day_feb)
tail(new_day)
g2$new_day <-c(day_jan, day_feb)

# create date col
date <-mdy(paste0(g2$month,"-",g2$new_day,"-",g2$year))
g2$date <-date # data to big dataframe

#format time and paste, assuming all second values are 00
time <- sprintf("%04d", as.numeric(as.character(g2$hour_min)))
g2$time <-times(gsub("(..)(..)", "\\1:\\2:00", time))

# combine into one date and time columb using lubridate
g2$date_time <- ymd_hms(paste(g2$date, g2$time))
head(g2)

# filter off bad data in beginning
# g2 <-filter(g2, date_time  >= "2022-01-25 17:05:00") 

ggplot(g2) +
  geom_line(aes(x = date_time, y = RH), size =.6)


# write.csv(g2, "/Users/jacktarricone/atms_748/data-code/lab2_data/csvs/lab2_g2.csv")

tail(g5)


##########################
######## group 4 #########
##########################


g4 <-read.csv("/Users/jacktarricone/atms_748/data-code/lab2_data/Lab_2/Group_4/Lab2/Data/CSV_21492.SlowResponse_2_2022_01_25_1651.dat",
              header = TRUE)
head(g4)

g4_ascii <-readLines("/Users/jacktarricone/atms_748/data-code/lab2_data/Lab_2/Group_4/Lab2/Data/TOA5_21492.SlowResponse_2_2022_01_25_1651.dat") 
head(g4_ascii)

# remove first unwanted col
g4 <- g4[-c(1)]
head(g4)

# rename columns using information in the ascii header from g4
colnames(g4) <- c("year","day","hour_min","sec","AirTC_Avg",
                  "RH","windSpeed","windDirection","gustWindSpeed","AirTemp")
head(g4)

# turn day into dom
# g4$day <-g4$day -28
# head(g4) # check, looks good
# tail(g4)

# add in month column, switch months
nday_janv1 <-filter(g4, day <= 31)
nday_jan <-as.integer(nrow(nday_janv1))
month_jan <-rep(1, nday_jan) 
month_feb <-rep(2, nrow(g4) - nday_jan)
month <-c(month_jan, month_feb)
g4 <-cbind(g4, month) # bind

### add new day col
# jan
day_jan <-filter(g4, day <= 31)
day_jan <-day_jan$day

# feb
day_feb <-filter(g4, day > 31)
day_feb <-day_feb$day - 31

# add col
new_day <-c(day_jan, day_feb)
tail(new_day)
g4$new_day <-c(day_jan, day_feb)

# create date col
date <-mdy(paste0(g4$month,"-",g4$new_day,"-",g4$year))
g4$date <-date # data to big dataframe

#format time and paste, assuming all second values are 00
time <- sprintf("%04d", as.numeric(as.character(g4$hour_min)))
g4$time <-times(gsub("(..)(..)", "\\1:\\2:00", time))

# combine into one date and time columb using lubridate
g4$date_time <- ymd_hms(paste(g4$date, g4$time))
head(g4)

# filter off bad data in beginning
# g4 <-filter(g4, date_time  >= "2022-01-25 17:05:00") 

ggplot(g4) +
  geom_line(aes(x = date_time, y = RH), size =.6)

# write.csv(g4, "/Users/jacktarricone/atms_748/data-code/lab2_data/csvs/lab2_g4.csv")
?geom_ribbon
##########################
######## group 5 #########
##########################


g5 <-read.csv("/Users/jacktarricone/atms_748/data-code/lab2_data/Lab_2/Group_5/CSV_21489.SlowResponse_3_2022_01_25_1719.dat",
              header = TRUE)
head(g5)

g5_ascii <-readLines("/Users/jacktarricone/atms_748/data-code/lab2_data/Lab_2/Group_5/TOA5_21489.SlowResponse_3_2022_01_25_1719.dat") 
head(g5_ascii)

# remove first unwanted col
# g5 <- g5[-c(1)]
# head(g5)

# rename columns using information in the ascii header from g5
colnames(g5) <- c("year","day","hour_min","sec","BattV_Min","PTemp_C",
              "AirTC_Avg","RH","windSpeed","windDirection","gustWindSpeed","AirTemp")
head(g5)

# turn day into dom
# g5$day <-g5$day -28
# head(g5) # check, looks good
# tail(g5)

# add in month column, switch months
nday_janv1 <-filter(g5, day <= 31)
nday_jan <-as.integer(nrow(nday_janv1))
month_jan <-rep(1, nday_jan) 
month_feb <-rep(2, nrow(g5) - nday_jan)
month <-c(month_jan, month_feb)
g5 <-cbind(g5, month) # bind

### add new day col
# jan
day_jan <-filter(g5, day <= 31)
day_jan <-day_jan$day

# feb
day_feb <-filter(g5, day > 31)
day_feb <-day_feb$day - 31

# add col
new_day <-c(day_jan, day_feb)
tail(new_day)
g5$new_day <-c(day_jan, day_feb)

# create date col
date <-mdy(paste0(g5$month,"-",g5$new_day,"-",g5$year))
g5$date <-date # data to big dataframe

#format time and paste, assuming all second values are 00
time <- sprintf("%04d", as.numeric(as.character(g5$hour_min)))
g5$time <-times(gsub("(..)(..)", "\\1:\\2:00", time))

# combine into one date and time columb using lubridate
g5$date_time <- ymd_hms(paste(g5$date, g5$time))
head(g5)

# filter off bad data in beginning
# g5 <-filter(g5, date_time  >= "2022-01-25 17:05:00") 

ggplot(g5) +
  geom_line(aes(x = date_time, y = RH), size =.6)

# write.csv(g5, "/Users/jacktarricone/atms_748/data-code/lab2_data/csvs/lab2_g5.csv")





