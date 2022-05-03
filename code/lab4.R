library(dplyr)
library(ggplot2)
library(lubridate)


# bring in data
eddy <-read.csv("/Users/jacktarricone/atms_748/lab4/output/eddypro_full_output_r.csv")
head(eddy)

# format date and time cols
eddy$date <-mdy(eddy$date)
eddy$time <-hm(eddy$time)

# create date time
eddy$date_time <-ymd_hms(paste(eddy$date, eddy$time))

# filter out -7999 values
eddy <-filter(eddy, LE == -7999)

ggplot(eddy) +
  geom_line(aes(x = date_time, y = LE), col = "black") + 
  scale_x_datetime(breaks = "2 day", date_labels="%b %d", limits = ymd_hm(c("2020-02-12 01:00", "2020-03-04 23:00")))+
  #scale_y_continuous(breaks = seq(0,1,.2))+
  xlab("Date") + ylab("Flux (W/m^2)")
