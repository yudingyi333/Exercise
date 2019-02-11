#Problem1
newdata<-greenbuildings[which(greenbuildings$stories<18&greenbuildings$stories>12&
                                greenbuildings$size<350000&greenbuildings$size>150000),] 

newdata1<-greenbuildings[which(greenbuildings$stories<18&greenbuildings$stories>12&
                                 greenbuildings$size<350000&greenbuildings$size>150000&
                                 greenbuildings$amenities==1),] 


ggplot(newdata,aes(size,Rent)) + 
  geom_point(aes(color=amenities))+ geom_smooth(se = FALSE)+
  labs(title = "After-filtering data divided by amenitites")

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) +
  labs(title = "Fuel efficiency generally decreases with engine size")
newdata2<-greenbuildings[which(greenbuildings$stories<18&greenbuildings$stories>12&
                                 greenbuildings$size<350000&greenbuildings$size>150000&
                                 greenbuildings$amenities==0),] 
amen1<-newdata1$Rent
mean(amen1)
median(amen1)
amen2<-newdata2$Rent
mean(amen2)
median(amen2)
47#no size
ggplot(data=greenbuildings)+ geom_point(mapping = aes(x=size,y = Rent))
lmsize1=lm(Rent~size,data=greenbuildings)
abline(lmsize1)
ggplot(data=newdata)+ geom_point(mapping = aes(x=size,y = Rent))
ggplot(data=newdata1)+ geom_point(mapping = aes(x=size,y = Rent)) 

cor(greenbuildings$Rent,greenbuildings$size)                      
cor(greenbuildings$Rent,greenbuildings$stories)                      


green<-newdata[which(newdata$green_rating==1&newdata$amenities==1), ]

nongreen<-newdata[which(newdata$green_rating==0&newdata$amenities==1),]

greenrent=green$Rent
nongreenrent=nongreen$Rent

### Guru's boxplot

boxplot(greenbuildings$Rent,col = c("lightblue"), main="Outliers of all buildings rent by Guru")
summary(greenbuildings$Rent)#7894 observation
allQL <- quantile(greenbuildings$Rent, probs = 0.25)
allQU <- quantile(greenbuildings$Rent, probs = 0.75)
allQU_QL <- allQU-allQL
Guru<-greenbuildings[which(greenbuildings$Rent < allQU + 1.5*allQU_QL&
                             greenbuildings$Rent>allQL-1.5*allQU_QL),]#286 outliers

Gurudown<-greenbuildings[which(greenbuildings$Rent>allQL-1.5*allQU_QL),]#no outliers downward
Guruup<-greenbuildings[which(greenbuildings$Rent < allQU + 1.5*allQU_QL),]#all obervation upward
### Green
boxplot(greenrent,col = c("lightblue"), main="Greenbuildings rent Outliers")
summary(greenrent)
QL <- quantile(greenrent, probs = 0.25)
QU <- quantile(greenrent, probs = 0.75)
QU_QL <- QU-QL
greenwithoutoutlier<-greenrent[which(greenrent < QU + 1.5*QU_QL&greenrent>QL-1.5*QU_QL)]


### Nongreen
boxplot(nongreenrent,col = c("red"), main="non-Greenbuildings Rent Outliers")
summary(nongreenrent)
nonQL <- quantile(nongreenrent, probs = 0.25)
nonQU <- quantile(nongreenrent, probs = 0.75)
nonQU_QL <- nonQU-nonQL
nongreenwithoutoutlier<-nongreenrent[which(nongreenrent < nonQU + 1.5*nonQU_QL&nongreenrent
                                           >nonQL-1.5*nonQU_QL)]
nongreendown<-nongreenrent[which(nongreenrent < nonQU + 1.5*nonQU_QL)]
nongreenup<-nongreenrent[which(nongreenrent>nonQL-1.5*nonQU_QL)]
### mean
a=mean(greenwithoutoutlier)
b=mean(nongreenwithoutoutlier)
a
b
3#total revenue
revenue1=a*mean(green$leasing_rate)*250000*0.01#leasing rate is not represent in percentage
revenue2=b*mean(nongreen$leasing_rate)*250000*0.01
revenue1
revenue2
### yrs return
yrs1=105000000/revenue1
yrs2=100000000/revenue2
yrs1
yrs2
yrsdifference=5000000/(revenue1-revenue2)
yrsdifference
cor(greenbuildings$Rent,greenbuildings$stories)   



### others
plot(Electricity_Costs~Rent,data=green)
lmgreen1=lm(Electricity_Costs~Rent,data=green)  
abline(lmgreen1,col="red")

plot(Electricity_Costs~Rent,data=nongreen)
lmnongreen1=lm(Electricity_Costs~Rent,data=nongreen)  
abline(lmnongreen1)
lines(x==30)


### electricity and gas
ggplot(newdata,aes(Electricity_Costs,Rent)) + 
  geom_point(aes(color=green_rating))+ geom_smooth(se = FALSE)+
  labs(title = "rent and electricity relationship by greenrating ")
ggplot(newdata,aes(Gas_Costs,Rent)) + 
  geom_point(aes(color=green_rating))+ geom_smooth(se = FALSE)+
  labs(title = "rent and gas relationship by greenrating ")
mean(green$Gas_Costs)
mean(nongreen$Gas_Costs)

Part I
Comparing with analysis by “data guru”, one of the mistake we think is the data he uses is too general, even if his data is big (has many observations), but it cannot reflect the exact result that the developer needs, so before analysis the data, it is better to find out the data which is more suitable and proper for the project. The detailed to filtrate data in our model is shown below:

Austin real-estate developer focuses on 15-story mixed-use building, according to the information, our model limits the range of the stories from 12 to 18, the aim is to use the data which is similar as the developer’s goal. And to test our limitation is right, we run the correlation between Rent and size from all data (includes both green and nongreen buildings) through R. The correlation is 0.116 which means when the stories is higher the rent is bigger, so it is necessary to limit the stories. Same as the size of the building, from the staff’s word, the size of the targeted building is 250,000 square feet, and correlation between size and rent is 0.138, so in our model, we limited size of the building between 150000 feet and 350000 feet. Another filter to the data is because the project located around downtown, and from the google map, we double check about this, it is located in a convenient place. As the graph below shows:
![](https://i.imgur.com/Wjq4XKU.png)
 
From the detailed of the google map (the above graph does not show), this area has bar, gym, restaurant and so on. So as for the “amenities” indicator, it should be 1. (dummy variable) After the filtering, the rest of data which has 367 buildings will be used for analyzed in our model. And before filtering the amenities, the data is bellowed, the blue one is amenities=1, and black one is amenities=0.
![](https://i.imgur.com/lIQihFb.png)
 
 
The data shows most of the data comes from the building which possesses good amenities. And mean of the blue point rent is 28.16 dollar(amenity=1), the other one is 30.02dollar. So it is necessary to move out the data which amenity=0.


Part II
There is one point we strongly disagree with the “data guru”. He uses difference between the rent between green house and none green house, and work out their total revenue difference each year. And work out how many years can green house recuperate the cost difference.
But personally, we think this only using this method is too limited. Developer wants to know “will investing in a green building be worth it, from an economic perspective value.” There are several possible results should analysis think about:
1.	If the net profit of greenhouse >0 (Suppose the renting year is at least 30 years , the rest possible results are same) and net profit of the greenhouse> net profit of non-green house,(from economics perspective) investing greenhouse
2.	If the net profit of greenhouse>0 but net profit of greenhouse< net profit of non-greenhouse, better not invest greenhouse
3.	If the net profit of green house<0 , definitely not consider green house, may consider nongreen house if net profit of it>0

So in our model, we not only analysis the how long can we recuperate the cost difference if we choose green house. And how long can we recuperate the cost if we choose to invest green house. And how long can we recuperate the cost if we choose to invest nongreen house. 

Part III
When analyzing the data, guru uses the median of the data to predict its rent, because he thinks there will be many outliers that influence the prediction of the data, so mean cannot be used. The direction that he thinks is right, however, using median still cannot solve the problem. If the outlier only focusses on one side, (outliers are all lying in the high rent or all in low rent, the prediction still has a big problem) Our group using “boxplot” method to find out outliers of the overall data (no filter as guru’s data), the graph is shown below: 
 ![](https://i.imgur.com/jTQwmqx.png)
The graph illustrates that all the outliers are upper, and using R for calculation, we work out that the data has 289 outliers, and all the outliers are bigger than upper quartile+1.5IQR and no outlier is smaller than lower quartile-1.5IQR. Consequently, the estimation method that guru uses is not right. Because all the outliers come from upper side, so the estimation uses median will be bigger than the estimation without outliers. In this case, in order to make an improvement, our group uses boxplot to remove all the outliers and using the rest of data’s mean to estimate the rent. 

After using the boxplot for green building and non-green building using the after-filter data. The two box plots are shown as below respectively. 
  
![](https://i.imgur.com/viTmTQ7.png)
![](https://i.imgur.com/VQ4ZNWC.png)

As the graph shows above, the green buildings data does not have any outliers, and non-green buildings has 7 outliers from the observations. And in our model, we remove the 7 outliers. And finally, our model calculates the average mean in each data group respectively. And our result shows mean of the green house rent is 31.74 dollar per square foot per calendar year, and the mean of the non green house rent is 26.77 dollar per square foot per calendar year. So the revenue calculation for each group is shown below:
(rent rate using  mean of each data sets’ rent rate, working process is in R)
Green house revenue each year = 722679564 , construction cost=105000000
Non Green house revenue each year = 559281853 , construction cost=100000000
So unlevered cash on cash return for green house is 105000000/722679564=14.53 years, this means in 14.53 years the investor’s rent revenue will cover its investment cost.  And for non green house revenue, unlevered cash on cash return for the non green house is 100000000/559281853= 17.88 years. So comparing to the these two number, it shows that investing green house is better, because the cost can be covered in 14.53 years which is shorter than nongreenhouse. And also, it is necessary to calculate for how long, can green house recuperate 5 million dollars which is the difference between cost of green-house and non green house. So using5000000/(722679564-559281853)=3.06 years. 

Furthermore, for the variable cost. The electricity cost and relationship is shown as below using the “after filtering data”:
 
We can see that after the rent is more than maybe 20 dollars ,the more the rent is and the more the electricity fee is. And the average rent for non green house is greater than green house, and it is more than 20 dollars, so this means green house’s electricity total cost should be less than non green house. (By green house’s definition, it should also be like that), but the same conclusion can not give to gas cost, which is shown as the graph below:
 
Because around 27dollars rent we cannot say if the rent is raised by gas or decreased by gas. So Our group aim to calculate its means by different group, the mean of gas cost in green house is 0.0108 and in non-green house is 0.011. So green house’s cost is a bit cheaper. 


From the data above, our group conclusion is if investors want to invest, definitely the greenhouse is better than the non green house. Because only 3.06 years is needed to recuperate the cost difference, and I think investor definitely will not choose less than 3.06 years project, because if the project  is less than 14.53 years for green house, investor will make a loss. And also, according to gas and electricity cost calculation, green house has a cheaper costs in these two area. So definitely greenhouse is the better choice. And if the project is more than 14.53 years, then green house can make profit and more economic than non green house.(cost does not count). If the project is less than 14.53 years, investors will make a loss. 

#Problem 2

## explanation
We want to study some interesting things about delay in ABIA so that we can make more wise choice about choosing the time whether in the daytime or in the day for the week for flight without so much delay.
First, we check whether the delay is positive related to the distance. However, according to the picture we draw using the data of ABIA.csv, there is not an obvious positive relation.
Secondly, we check the data for delay of each hour. Because the data is combined by the flight for departure and arrival, we separate each flight into two groups—'dest’ which means flights arrives in Austin; ‘orig’ which means flights departure from Austin. Moreover, we add the reasons for each delay flight. According to two pictures we draw, for departure 15-20 will be the most time to be delayed; for arrival 21-23 will be the most time to be delayed.
Thirdly, we use the data to check the delay times in the week. We find that flights on Monday, and Sunday will be more likely to be delayed while flights on Tuesday and Wednesday will be less likely to be delayed whether departs or arrives.


library(tidyverse)

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

##flights delay in a day & reason for delay
library(plotly)
src_abia <- ABIA
src_abia <- subset(src_abia, Cancelled == 0 & !is.na(CRSDepTime))
orig <- subset(src_abia, Origin == 'AUS')
dest <- subset(src_abia, Dest == 'AUS')

dest$CRSDepTime[dest$CRSDepTime == 2400] <- 0
dest$CRSDepTime <- dest$CRSDepTime - dest$CRSDepTime %% 100
dest$CRSDepTime <- sprintf("%04d", dest$CRSDepTime)
dest$CRSDepTime <- format(strptime(dest$CRSDepTime, '%H%M'), format='%H:%M')
dest[is.na(dest)] <- 0
dest$ArrDelay[dest$ArrDelay < 0] <- 0
dest$OtherDelay <- dest$ArrDelay
dest$OtherDelay[dest$ArrDelay >= 15] <- 0

orig$CRSDepTime[orig$CRSDepTime == 2400] <- 0
orig$CRSDepTime <- orig$CRSDepTime - orig$CRSDepTime %% 100
orig$CRSDepTime <- sprintf("%04d", orig$CRSDepTime)
orig$CRSDepTime <- format(strptime(orig$CRSDepTime, '%H%M'), format='%H:%M')
orig[is.na(orig)] <- 0
orig$ArrDelay[orig$ArrDelay < 0] <- 0
orig$OtherDelay <- orig$ArrDelay
orig$OtherDelay[orig$ArrDelay >= 15] <- 0

delay_indices <- c('ArrDelay', 'CarrierDelay', 'WeatherDelay', 'NASDelay', 'SecurityDelay', 'LateAircraftDelay', 'OtherDelay')
dest_delay = aggregate(dest[delay_indices], by=list(DepTime=dest$CRSDepTime), FUN=mean)
orig_delay = aggregate(orig[delay_indices], by=list(DepTime=orig$CRSDepTime), FUN=mean)


dest_delay_p <- plot_ly(dest_delay, x=~DepTime, y=~CarrierDelay, type='bar', name='CarrierDelay') %>%
  add_trace(y = ~NASDelay, name='NASDelay') %>%
  add_trace(y = ~LateAircraftDelay, name='LateAircraftDelay') %>%
  add_trace(y = ~WeatherDelay, name='WeatherDelay') %>%
  add_trace(y = ~SecurityDelay, name='SecurityDelay') %>%
  
  add_trace(y = ~OtherDelay, name='OtherDelay') %>%
  layout(title = "Delay in a day (AUS dest)", xaxis=list(title='DepartTime'), yaxis = list(title = 'Delay Minutes'), barmode = 'stack')

orig_delay_p <- plot_ly(orig_delay, x=~DepTime, y=~CarrierDelay, type='bar', name='CarrierDelay') %>%
  add_trace(y = ~NASDelay, name='NASDelay') %>%
  add_trace(y = ~LateAircraftDelay, name='LateAircraftDelay') %>%
  add_trace(y = ~SecurityDelay, name='SecurityDelay') %>%
  add_trace(y = ~WeatherDelay, name='WeatherDelay') %>%
  add_trace(y = ~OtherDelay, name='OtherDelay') %>%
  layout(title = "Delay in a day (AUS depart)", xaxis=list(title='DepartTime'), yaxis = list(title = 'Delay Minutes'), barmode = 'stack')

print(orig_delay_p)
print(dest_delay_p)


## flights  delay in a week & reason for the delay
library(ggplot2)
library(ggthemes)

week_idx = c('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday')

src_abia$DayOfWeek <- factor(week_idx[src_abia$DayOfWeek], levels = rev(week_idx))

orig <- subset(src_abia, Origin == 'AUS')
dest <- subset(src_abia, Dest == 'AUS')


dest$CRSDepTime[dest$CRSDepTime == 2400] <- 0
dest$CRSDepTime <- dest$CRSDepTime - dest$CRSDepTime %% 100
dest$CRSDepTime <- sprintf("%04d", dest$CRSDepTime)
dest$CRSDepTime <- format(strptime(dest$CRSDepTime, '%H%M'), format='%H:%M')
dest[is.na(dest)] <- 0
dest$ArrDelay[dest$ArrDelay < 0] <- 0


orig$CRSDepTime[orig$CRSDepTime == 2400] <- 0
orig$CRSDepTime <- orig$CRSDepTime - orig$CRSDepTime %% 100
orig$CRSDepTime <- sprintf("%04d", orig$CRSDepTime)
orig$CRSDepTime <- format(strptime(orig$CRSDepTime, '%H%M'), format='%H:%M')
orig[is.na(orig)] <- 0
orig$ArrDelay[orig$ArrDelay < 0] <- 0


dest_delay = aggregate(dest['ArrDelay'], by=list(DepTime=dest$CRSDepTime, DayOfWeek=dest$DayOfWeek), FUN=mean)
orig_delay = aggregate(orig['ArrDelay'], by=list(DepTime=orig$CRSDepTime, DayOfWeek=orig$DayOfWeek), FUN=mean)


col1 = "#a0c4a0"
col2 = "#326262"
col3 = "#fdd17a"
col4 = "#ff4242"

p_dest <- ggplot(dest_delay, aes(DepTime, DayOfWeek, fill=ArrDelay)) +
  geom_point() +
  coord_equal() + 
  geom_tile(color = "white", size = 1.6) +
  scale_fill_gradient(low = col1, high = col2) +
  labs(y=NULL, fill="Delay minutes", title = "Delay in a week (AUS dest)") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
  theme_tufte(base_family = "Helvetica")

p_orig <- ggplot(orig_delay, aes(DepTime, DayOfWeek, fill=ArrDelay)) +
  geom_point() +
  coord_equal() + 
  geom_tile(color = "white", size = 1.6) +
  scale_fill_gradient(low = col3, high = col4) +
  labs(y=NULL, fill="Delay minutes", title = "Delay in a week (AUS depart)") +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank()) +
  theme_tufte(base_family = "Helvetica")

print(p_orig)
print(p_dest)

![](https://i.imgur.com/70eUfbj.jpg)
![](https://i.imgur.com/Nc7ji3h.jpg)
![](https://i.imgur.com/Z6LlmB1.jpg)

## flights  delay in a week & reason for the delay
library(ggplot2)
library(ggthemes)

week_idx = c('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday')

src_abia$DayOfWeek <- factor(week_idx[src_abia$DayOfWeek], levels = rev(week_idx))

orig <- subset(src_abia, Origin == 'AUS')
dest <- subset(src_abia, Dest == 'AUS')


dest$CRSDepTime[dest$CRSDepTime == 2400] <- 0
dest$CRSDepTime <- dest$CRSDepTime - dest$CRSDepTime %% 100
dest$CRSDepTime <- sprintf("%04d", dest$CRSDepTime)
dest$CRSDepTime <- format(strptime(dest$CRSDepTime, '%H%M'), format='%H:%M')
dest[is.na(dest)] <- 0
dest$ArrDelay[dest$ArrDelay < 0] <- 0


orig$CRSDepTime[orig$CRSDepTime == 2400] <- 0
orig$CRSDepTime <- orig$CRSDepTime - orig$CRSDepTime %% 100
orig$CRSDepTime <- sprintf("%04d", orig$CRSDepTime)
orig$CRSDepTime <- format(strptime(orig$CRSDepTime, '%H%M'), format='%H:%M')
orig[is.na(orig)] <- 0
orig$ArrDelay[orig$ArrDelay < 0] <- 0


dest_delay = aggregate(dest['ArrDelay'], by=list(DepTime=dest$CRSDepTime, DayOfWeek=dest$DayOfWeek), FUN=mean)
orig_delay = aggregate(orig['ArrDelay'], by=list(DepTime=orig$CRSDepTime, DayOfWeek=orig$DayOfWeek), FUN=mean)


col1 = "#a0c4a0"
col2 = "#326262"
col3 = "#fdd17a"
col4 = "#ff4242"

p_dest <- ggplot(dest_delay, aes(DepTime, DayOfWeek, fill=ArrDelay)) +
  geom_point() +
  coord_equal() + 
  geom_tile(color = "white", size = 1.6) +
  scale_fill_gradient(low = col1, high = col2) +
  labs(y=NULL, fill="Delay minutes", title = "Delay in a week (AUS dest)") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
  theme_tufte(base_family = "Helvetica")

p_orig <- ggplot(orig_delay, aes(DepTime, DayOfWeek, fill=ArrDelay)) +
  geom_point() +
  coord_equal() + 
  geom_tile(color = "white", size = 1.6) +
  scale_fill_gradient(low = col3, high = col4) +
  labs(y=NULL, fill="Delay minutes", title = "Delay in a week (AUS depart)") +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank()) +
  theme_tufte(base_family = "Helvetica")

print(p_orig)
print(p_dest)



#Problem 3

library(tidyverse)

library(FNN)

sclass <- read.csv("~/GitHub/ECO395M/data/sclass.csv")
View(sclass)

s350data<-sclass[which(sclass$trim == 350),]
View(s350data)

ggplot(data = s350data) + 
  
  geom_point(mapping = aes(x = mileage, y = price), color='red') + 
  ylim(0,100000)
  
N = nrow(s350data)

N_train = floor(0.6*N)

N_test = N - N_train

train_ind = sample.int(N, N_train, replace=FALSE)

D_train = s350data[train_ind,]

D_test = s350data[-train_ind,]

D_test = arrange(D_test, mileage)

head(D_test)

X_train = select(D_train, mileage)

y_train = select(D_train, price)

X_test = select(D_test, mileage)

y_test = select(D_test, price)

lm1 = lm(price ~ mileage, data=D_train)

lm2 = lm(price ~ poly(mileage, 2), data=D_train)

knn3 = knn.reg(train = X_train, test = X_test, y = y_train, k=3)

names(knn3)

knn5 = knn.reg(train = X_train, test = X_test, y = y_train, k=5)

names(knn5)

knn10 = knn.reg(train = X_train, test = X_test, y = y_train, k=10)

names(knn10)

knn20 = knn.reg(train = X_train, test = X_test, y = y_train, k=20)

names(knn20)

knn50 = knn.reg(train = X_train, test = X_test, y = y_train, k=50)

names(knn50)

knn100 = knn.reg(train = X_train, test = X_test, y = y_train, k=100)

names(knn100)

rmse = function(y, ypred) {
  
  sqrt(mean(data.matrix((y-ypred)^2)))
  
}

ypred_lm1 = predict(lm1, X_test)

ypred_lm2 = predict(lm2, X_test)

ypred_knn3= knn3$pred


rmse(y_test, ypred_lm1)

rmse(y_test, ypred_lm2)

rmse(y_test, ypred_knn3)

rmse_350K3=rmse(y_test, ypred_knn3)

rmse_350K3

D_test$ypred_lm2 = ypred_lm2

D_test$ypred_knn3 = ypred_knn3



p_test = ggplot(data = D_test) + 
  
  geom_point(mapping = aes(x = mileage, y = price), color='lightgrey') + 
  
  theme_bw(base_size=20) + 
   ylim(0,100000)

p_test



p_test + geom_point(aes(x = mileage, y = ypred_knn3), color='red')

p_test + geom_path(aes(x = mileage, y = ypred_knn3), color='red')

p_test + geom_path(aes(x = mileage, y = ypred_knn3), color='red') + 
  
  geom_path(aes(x = mileage, y = ypred_lm2), color='blue')



ypred_lm1 = predict(lm1, X_test)

ypred_lm2 = predict(lm2, X_test)

ypred_knn5= knn5$pred


rmse(y_test, ypred_lm1)

rmse(y_test, ypred_lm2)

rmse(y_test, ypred_knn5)

rmse_350K5=rmse(y_test, ypred_knn5)

rmse_350K5

D_test$ypred_lm2 = ypred_lm2

D_test$ypred_knn5 = ypred_knn5



p_test = ggplot(data = D_test) + 
  
  geom_point(mapping = aes(x = mileage, y = price), color='lightgrey') + 
  
  theme_bw(base_size=18) + 
  
  ylim(0, 100000)

p_test



p_test + geom_point(aes(x = mileage, y = ypred_knn5), color='red')

p_test + geom_path(aes(x = mileage, y = ypred_knn5), color='red')

p_test + geom_path(aes(x = mileage, y = ypred_knn5), color='red') + 
  
  geom_path(aes(x = mileage, y = ypred_lm2), color='blue')


ypred_lm1 = predict(lm1, X_test)

ypred_lm2 = predict(lm2, X_test)

ypred_knn10= knn10$pred


rmse(y_test, ypred_lm1)

rmse(y_test, ypred_lm2)

rmse(y_test, ypred_knn10)

rmse_350K10=rmse(y_test, ypred_knn10)

rmse_350K10

D_test$ypred_lm2 = ypred_lm2

D_test$ypred_knn10 = ypred_knn10



p_test = ggplot(data = D_test) + 
  
  geom_point(mapping = aes(x = mileage, y = price), color='lightgrey') + 
  
  theme_bw(base_size=18) + 
  
  ylim(0, 100000)

p_test



p_test + geom_point(aes(x = mileage, y = ypred_knn10), color='red')

p_test + geom_path(aes(x = mileage, y = ypred_knn10), color='red')

p_test + geom_path(aes(x = mileage, y = ypred_knn10), color='red') + 
  
  geom_path(aes(x = mileage, y = ypred_lm2), color='blue')
  
ypred_lm1 = predict(lm1, X_test)

ypred_lm2 = predict(lm2, X_test)

ypred_knn20= knn20$pred


rmse(y_test, ypred_lm1)

rmse(y_test, ypred_lm2)

rmse(y_test, ypred_knn20)

rmse_350K20=rmse(y_test, ypred_knn20)

rmse_350K20

D_test$ypred_lm2 = ypred_lm2

D_test$ypred_knn20 = ypred_knn20



p_test = ggplot(data = D_test) + 
  
  geom_point(mapping = aes(x = mileage, y = price), color='lightgrey') + 
  
  theme_bw(base_size=18) + 
  
  ylim(0, 100000)

p_test



p_test + geom_point(aes(x = mileage, y = ypred_knn20), color='red')

p_test + geom_path(aes(x = mileage, y = ypred_knn20), color='red')

p_test + geom_path(aes(x = mileage, y = ypred_knn20), color='red') + 
  
  geom_path(aes(x = mileage, y = ypred_lm2), color='blue')  
  

ypred_lm1 = predict(lm1, X_test)

ypred_lm2 = predict(lm2, X_test)

ypred_knn50= knn50$pred


rmse(y_test, ypred_lm1)

rmse(y_test, ypred_lm2)

rmse(y_test, ypred_knn50)

rmse_350K50=rmse(y_test, ypred_knn0)5

rmse_350K50

D_test$ypred_lm2 = ypred_lm2

D_test$ypred_knn50 = ypred_knn50



p_test = ggplot(data = D_test) + 
  
  geom_point(mapping = aes(x = mileage, y = price), color='lightgrey') + 
  
  theme_bw(base_size=18) + 
  
  ylim(0, 100000)

p_test



p_test + geom_point(aes(x = mileage, y = ypred_knn50), color='red')

p_test + geom_path(aes(x = mileage, y = ypred_knn50), color='red')

p_test + geom_path(aes(x = mileage, y = ypred_knn50), color='red') + 
  
  geom_path(aes(x = mileage, y = ypred_lm2), color='blue')  
  

ypred_lm1 = predict(lm1, X_test)

ypred_lm2 = predict(lm2, X_test)

ypred_knn100= knn100$pred


rmse(y_test, ypred_lm1)

rmse(y_test, ypred_lm2)

rmse(y_test, ypred_knn100)

rmse_350K100=rmse(y_test, ypred_knn100)

rmse_350K100

D_test$ypred_lm2 = ypred_lm2

D_test$ypred_knn100 = ypred_knn100



p_test = ggplot(data = D_test) + 
  
  geom_point(mapping = aes(x = mileage, y = price), color='lightgrey') + 
  
  theme_bw(base_size=18) + 
  
  ylim(0, 100000)

p_test



p_test + geom_point(aes(x = mileage, y = ypred_knn100), color='red')

p_test + geom_path(aes(x = mileage, y = ypred_knn100), color='red')

p_test + geom_path(aes(x = mileage, y = ypred_knn100), color='red') + 
  
  geom_path(aes(x = mileage, y = ypred_lm2), color='blue')  
  
# the trim of 65 AMG
library(tidyverse)

library(FNN)

sclass <- read.csv("~/GitHub/ECO395M/data/sclass.csv")
View(sclass)

s63data <-sclass[which(sclass$trim == "63 AMG"),]
View(s63data)

ggplot(data = s63data) + 
  
  geom_point(mapping = aes(x = mileage, y = price), color='red') 
   ylim(0,200000)
  
 
N = nrow(s63data)

N_train = floor(0.6*N)

N_test = N - N_train

train_ind = sample.int(N, N_train, replace=FALSE)

D_train = s63data[train_ind,]

D_test = s63data[-train_ind,]

D_test = arrange(D_test, mileage)

head(D_test)

X_train = select(D_train, mileage)

y_train = select(D_train, price)

X_test = select(D_test, mileage)

y_test = select(D_test, price)

lm1 = lm(price ~ mileage, data=D_train)

lm2 = lm(price ~ poly(mileage, 2), data=D_train)

knn3 = knn.reg(train = X_train, test = X_test, y = y_train, k=3)

names(knn3)

knn5 = knn.reg(train = X_train, test = X_test, y = y_train, k=5)

names(knn5)

knn10 = knn.reg(train = X_train, test = X_test, y = y_train, k=10)

names(knn10)

knn20 = knn.reg(train = X_train, test = X_test, y = y_train, k=20)

names(knn20)

knn50 = knn.reg(train = X_train, test = X_test, y = y_train, k=50)

names(knn50)

knn100 = knn.reg(train = X_train, test = X_test, y = y_train, k=100)

names(knn100)

rmse = function(y, ypred) {
  
  sqrt(mean(data.matrix((y-ypred)^2)))
  
}

ypred_lm1 = predict(lm1, X_test)

ypred_lm2 = predict(lm2, X_test)

ypred_knn3= knn3$pred


rmse(y_test, ypred_lm1)

rmse(y_test, ypred_lm2)

rmse(y_test, ypred_knn3)

rmse_63K3=rmse(y_test, ypred_knn3)

rmse_63K3

D_test$ypred_lm2 = ypred_lm2

D_test$ypred_knn3 = ypred_knn3



p_test = ggplot(data = D_test) + 
  
  geom_point(mapping = aes(x = mileage, y = price), color='lightgrey') + 
  
  theme_bw(base_size=20) + 
  
  ylim(0, 200000)

p_test



p_test + geom_point(aes(x = mileage, y = ypred_knn3), color='red')

p_test + geom_path(aes(x = mileage, y = ypred_knn3), color='red')

p_test + geom_path(aes(x = mileage, y = ypred_knn3), color='red') + 
  
  geom_path(aes(x = mileage, y = ypred_lm2), color='blue')



ypred_lm1 = predict(lm1, X_test)

ypred_lm2 = predict(lm2, X_test)

ypred_knn5= knn5$pred


rmse(y_test, ypred_lm1)

rmse(y_test, ypred_lm2)

rmse(y_test, ypred_knn5)

rmse_63K5=rmse(y_test, ypred_knn5)

rmse_63K5

D_test$ypred_lm2 = ypred_lm2

D_test$ypred_knn5 = ypred_knn5



p_test = ggplot(data = D_test) + 
  
  geom_point(mapping = aes(x = mileage, y = price), color='lightgrey') + 
  
  theme_bw(base_size=18) + 
  
  ylim(0, 200000)

p_test



p_test + geom_point(aes(x = mileage, y = ypred_knn5), color='red')

p_test + geom_path(aes(x = mileage, y = ypred_knn5), color='red')

p_test + geom_path(aes(x = mileage, y = ypred_knn5), color='red') + 
  
  geom_path(aes(x = mileage, y = ypred_lm2), color='blue')


ypred_lm1 = predict(lm1, X_test)

ypred_lm2 = predict(lm2, X_test)

ypred_knn10= knn10$pred


rmse(y_test, ypred_lm1)

rmse(y_test, ypred_lm2)

rmse(y_test, ypred_knn10)

rmse_63K10=rmse(y_test, ypred_knn10)

rmse_63K10

D_test$ypred_lm2 = ypred_lm2

D_test$ypred_knn10 = ypred_knn10



p_test = ggplot(data = D_test) + 
  
  geom_point(mapping = aes(x = mileage, y = price), color='lightgrey') + 
  
  theme_bw(base_size=18) + 
  
  ylim(0, 200000)

p_test



p_test + geom_point(aes(x = mileage, y = ypred_knn10), color='red')

p_test + geom_path(aes(x = mileage, y = ypred_knn10), color='red')

p_test + geom_path(aes(x = mileage, y = ypred_knn10), color='red') + 
  
  geom_path(aes(x = mileage, y = ypred_lm2), color='blue')
  
  
ypred_lm1 = predict(lm1, X_test)

ypred_lm2 = predict(lm2, X_test)

ypred_knn20= knn20$pred


rmse(y_test, ypred_lm1)

rmse(y_test, ypred_lm2)

rmse(y_test, ypred_knn20)

rmse_63K20=rmse(y_test, ypred_knn20)

rmse_63K20

D_test$ypred_lm2 = ypred_lm2

D_test$ypred_knn20 = ypred_knn20



p_test = ggplot(data = D_test) + 
  
  geom_point(mapping = aes(x = mileage, y = price), color='lightgrey') + 
  
  theme_bw(base_size=18) + 
  
  ylim(0, 200000)

p_test



p_test + geom_point(aes(x = mileage, y = ypred_knn20), color='red')

p_test + geom_path(aes(x = mileage, y = ypred_knn20), color='red')

p_test + geom_path(aes(x = mileage, y = ypred_knn20), color='red') + 
  
  geom_path(aes(x = mileage, y = ypred_lm2), color='blue')  

ypred_lm1 = predict(lm1, X_test)

ypred_lm2 = predict(lm2, X_test)

ypred_knn50= knn50$pred


rmse(y_test, ypred_lm1)

rmse(y_test, ypred_lm2)

rmse(y_test, ypred_knn50)

rmse_63K50=rmse(y_test, ypred_knn50)

rmse_63K50

D_test$ypred_lm2 = ypred_lm2

D_test$ypred_knn50 = ypred_knn50



p_test = ggplot(data = D_test) + 
  
  geom_point(mapping = aes(x = mileage, y = price), color='lightgrey') + 
  
  theme_bw(base_size=18) + 
  
  ylim(0, 200000)

p_test



p_test + geom_point(aes(x = mileage, y = ypred_knn50), color='red')

p_test + geom_path(aes(x = mileage, y = ypred_knn50), color='red')

p_test + geom_path(aes(x = mileage, y = ypred_knn50), color='red') + 
  
  geom_path(aes(x = mileage, y = ypred_lm2), color='blue')  
  
ypred_lm1 = predict(lm1, X_test)

ypred_lm2 = predict(lm2, X_test)

ypred_knn100= knn100$pred


rmse(y_test, ypred_lm1)

rmse(y_test, ypred_lm2)

rmse(y_test, ypred_knn100)

rmse_63K100=rmse(y_test, ypred_knn100)

rmse_63K100

D_test$ypred_lm2 = ypred_lm2

D_test$ypred_knn100 = ypred_knn100



p_test = ggplot(data = D_test) + 
  
  geom_point(mapping = aes(x = mileage, y = price), color='lightgrey') + 
  
  theme_bw(base_size=18) + 
  
  ylim(0, 200000)

p_test



p_test + geom_point(aes(x = mileage, y = ypred_knn50), color='red')

p_test + geom_path(aes(x = mileage, y = ypred_knn50), color='red')

p_test + geom_path(aes(x = mileage, y = ypred_knn50), color='red') + 
  
  geom_path(aes(x = mileage, y = ypred_lm2), color='blue')  

show(K_RMSE)

350K	350RMSE
3	11378.72
5	10881.42
10	10246.25
20	10425.31
50	11103.55
100	11582.2

![](https://i.imgur.com/qj4oxEg.png)
![](https://i.imgur.com/xFWTKkf.png)
![](https://i.imgur.com/ZQ54Bgu.png)
![](https://i.imgur.com/3TK9h28.png)
![](https://i.imgur.com/iPcG6KQ.png)
![](https://i.imgur.com/VAN3Wpq.png)

63K	63RMSE
3	16623.42
5	15958.97
10	15241.02
20	14949.23
50	14857.67
100	15781.63
![](https://i.imgur.com/VJ6zrEH.png)
![](https://i.imgur.com/cQzgVlf.png)
![](https://i.imgur.com/NoAod0Q.png)
![](https://i.imgur.com/Mh471aU.png)
![](https://i.imgur.com/GpkEf3a.png)
![](https://i.imgur.com/6ImCccB.png)
## From the data,we can see that the RMSE deceases at first and increases with K increases, thus we found that the best K for 350 is 10 or about and the best K for 63 AMG is 50 or about.
