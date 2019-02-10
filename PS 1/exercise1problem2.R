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


#ArrDelay & DepDelay
a1 <- group_by(ABIA, Year, Month, DayofMonth)
a2 <- select(a1, ArrDelay, DepDelay)
a3 <- summarise(a2,
                arr = mean(ArrDelay, na.rm = TRUE),
                dep = mean(DepDelay, na.rm = TRUE))
a4 <- filter(a3, arr > 0 | dep > 0)

ggplot(a4, aes(arr, dep)) +
  geom_point() +
  scale_size_area()+
  geom_smooth()