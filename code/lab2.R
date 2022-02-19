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

# •Acquire data with your program on data card
# •Copy data table to your PC in CSV format (Loggernet: <Data><CardConvert>)
# •Copy your CSV data to UNR Box
# •Copy other lab teams’ CSV data files from Box
# •Write a program to read the data and make time series plots
# •Turn in plot of timeseries of your  HMP-155 temperature measurements and ensemble-averaged temperature measurements with standard deviation (error bars or patch)
# •Turn in plot of timeseries of your HMP-155 relative humidity measurements and ensemble-averaged relative humidity measurements with standard deviation (error bars or patch)
# •Turn in windrose plot of your wind measurements (wind speed and direction)
# •Turn in electronic copy of program

#############################
##### our data (group 3) ####
#############################

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

# filter off bad begining data
hmp_csv_data <-filter(hmp_csv_data, date_time  >= "2022-02-01 18:50:00") 
# write.csv(hmp_csv_data, "/Users/jacktarricone/atms_748/data-code/lab2_data/csvs/jack_eric.csv")

# quick test plot
theme_set(theme_classic(12))
ggplot(hmp_csv_data) +
  geom_line(aes(x = date_time, y = PTemp_C), size =.6) + 
  geom_line(aes(x = date_time, y = AirTC_Avg), size =.6, color = "red")

##########################
######## group 1 #########
##########################
