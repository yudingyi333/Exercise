library(tidyverse)

ABIA

ggplot(data=ABIA)+
  geom_point(mapping = aes(x = CRSDepTime, y = DepDelay))

ggplot(data=ABIA)+
  geom_point(mapping = aes(x = Month, y = DepDelay))

ggplot(data=ABIA)+
  geom_point(mapping = aes(x = DayofMonth, y = DepDelay))

ABIA[complete.cases(ABIA),]
group_by
ggplot(data=ABIA)+
  geom_point(mapping = aes(x = CRSDepTime, y = DepDelay))

## DepDelay& Distance
by_tailnum <- group_by(ABIA, TailNum)
delay <- summarise(by_tailnum,
                   count = n(),
                   dist = mean(Distance, na.rm = TRUE),
                   delay = mean(DepDelay, na.rm = TRUE))
delay <- filter(delay, count > 20, dist < 2000)

ggplot(delay, aes(dist, delay)) +
  geom_point(aes(size = count), alpha = 1/2) +
  geom_smooth() +
  scale_size_area()


# flights from departure from Austin delay in the daytime & reason for the delay
library(plotly)
src_abia <- ABIA
orig <- subset(src_abia, Cancelled == 0 & Origin == 'AUS')

orig$DepTime[orig$DepTime == 2400] <- 0
orig$DepTime <- orig$DepTime - orig$DepTime %% 100 %% 60
orig$DepTime <- sprintf("%04d", orig$DepTime)
orig$DepTime <- format(strptime(orig$DepTime, '%H%M'), format='%H:%M')
orig[is.na(orig)] <- 0
orig$ArrDelay[orig$ArrDelay < 0] <- 0
orig$OtherDelay <- orig$ArrDelay
orig$OtherDelay[orig$ArrDelay >= 15] <- 0

orig_delay_p <- plot_ly(orig_delay, x=~Group.1, y=~CarrierDelay, type='bar', name='CarrierDelay') %>%
  add_trace(y = ~WeatherDelay, name='WeatherDelay') %>%
  add_trace(y = ~LateAircraftDelay, name='LateAircraftDelay') %>%
  add_trace(y = ~SecurityDelay, name='SecurityDelay') %>%
  add_trace(y = ~NASDelay, name='NASDelay') %>%
  add_trace(y = ~OtherDelay, name='OtherDelay') %>%
  layout(title = "Arrival delay (AUS depart)", xaxis=list(title='DepTime'), yaxis = list(title = 'DelayMinutes'), barmode = 'stack')

print(orig_delay_p)


# flights arrives in Austin delay in the daytime & reasons for the delay
dest <- subset(src_abia , Cancelled == 0 & Dest == 'AUS')

dest$ArrTime[dest$ArrTime == 2400] <- 0
dest$ArrTime <- dest$ArrTime -  dest$ArrTime %% 100 %% 60
dest$ArrTime <- sprintf("%04d", dest$ArrTime)
dest$ArrTime <- format(strptime(dest$ArrTime, '%H%M'), format='%H:%M')
dest[is.na(dest)] <- 0
dest$ArrDelay[dest$ArrDelay < 0] <- 0
dest$OtherDelay <- dest$ArrDelay
dest$OtherDelay[dest$ArrDelay >= 15] <- 0

delay_indices <- c('ArrDelay', 'CarrierDelay', 'WeatherDelay', 'NASDelay', 'SecurityDelay', 'LateAircraftDelay', 'OtherDelay')
dest_delay = aggregate(dest[delay_indices], by=list(dest$ArrTime), FUN=mean)
orig_delay = aggregate(orig[delay_indices], by=list(orig$DepTime), FUN=mean)


dest_delay_p <- plot_ly(dest_delay, x=~Group.1, y=~CarrierDelay, type='bar', name='CarrierDelay') %>%
  add_trace(y = ~WeatherDelay, name='WeatherDelay') %>%
  add_trace(y = ~LateAircraftDelay, name='LateAircraftDelay') %>%
  add_trace(y = ~SecurityDelay, name='SecurityDelay') %>%
  add_trace(y = ~NASDelay, name='NASDelay') %>%
  add_trace(y = ~OtherDelay, name='OtherDelay') %>%
  layout(title = "Arrival delay (AUS dest)", xaxis=list(title='ArrTime'), yaxis = list(title = 'DelayMinutes'), barmode = 'stack')

print(dest_delay_p)