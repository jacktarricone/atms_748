# lab 2

### HMP temperature plot
# 1. add +/- standard deviation shaded area
# 2. ensamable average of all 5 groups
# 3. line with our data

### HMP RH PLOT
# same thing as first plot

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

ggplot(hmp_csv_data) +
  geom_line(aes(x = date_time, y = RH))
