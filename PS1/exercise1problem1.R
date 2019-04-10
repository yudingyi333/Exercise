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
#

green<-newdata[which(newdata$green_rating==1&newdata$amenities==1), ]

nongreen<-newdata[which(newdata$green_rating==0&newdata$amenities==1),]

greenrent=green$Rent
nongreenrent=nongreen$Rent

#Guru's boxplot
boxplot(greenbuildings$Rent,col = c("lightblue"), main="Outliers of all buildings rent by Guru")
summary(greenbuildings$Rent)#7894 observation
allQL <- quantile(greenbuildings$Rent, probs = 0.25)
allQU <- quantile(greenbuildings$Rent, probs = 0.75)
allQU_QL <- allQU-allQL
Guru<-greenbuildings[which(greenbuildings$Rent < allQU + 1.5*allQU_QL&
                             greenbuildings$Rent>allQL-1.5*allQU_QL),]#286 outliers

Gurudown<-greenbuildings[which(greenbuildings$Rent>allQL-1.5*allQU_QL),]#no outliers downward
Guruup<-greenbuildings[which(greenbuildings$Rent < allQU + 1.5*allQU_QL),]#all obervation upward
#Green
boxplot(greenrent,col = c("lightblue"), main="Greenbuildings rent Outliers")
summary(greenrent)
QL <- quantile(greenrent, probs = 0.25)
QU <- quantile(greenrent, probs = 0.75)
QU_QL <- QU-QL
greenwithoutoutlier<-greenrent[which(greenrent < QU + 1.5*QU_QL&greenrent>QL-1.5*QU_QL)]


#Nongreen
boxplot(nongreenrent,col = c("red"), main="non-Greenbuildings Rent Outliers")
summary(nongreenrent)
nonQL <- quantile(nongreenrent, probs = 0.25)
nonQU <- quantile(nongreenrent, probs = 0.75)
nonQU_QL <- nonQU-nonQL
nongreenwithoutoutlier<-nongreenrent[which(nongreenrent < nonQU + 1.5*nonQU_QL&nongreenrent
                                           >nonQL-1.5*nonQU_QL)]
nongreendown<-nongreenrent[which(nongreenrent < nonQU + 1.5*nonQU_QL)]
nongreenup<-nongreenrent[which(nongreenrent>nonQL-1.5*nonQU_QL)]
#mean
a=mean(greenwithoutoutlier)
b=mean(nongreenwithoutoutlier)
a
b
3#total revenue
revenue1=a*mean(green$leasing_rate)*250000*0.01#leasing rate is not represent in percentage
revenue2=b*mean(nongreen$leasing_rate)*250000*0.01
revenue1
revenue2
#yrs return
yrs1=105000000/revenue1
yrs2=100000000/revenue2
yrs1
yrs2
yrsdifference=5000000/(revenue1-revenue2)
yrsdifference
cor(greenbuildings$Rent,greenbuildings$stories)   



#others
plot(Electricity_Costs~Rent,data=green)
lmgreen1=lm(Electricity_Costs~Rent,data=green)  
abline(lmgreen1,col="red")

plot(Electricity_Costs~Rent,data=nongreen)
lmnongreen1=lm(Electricity_Costs~Rent,data=nongreen)  
abline(lmnongreen1)
lines(x==30)


#electricity and gas
ggplot(newdata,aes(Electricity_Costs,Rent)) + 
  geom_point(aes(color=green_rating))+ geom_smooth(se = FALSE)+
  labs(title = "rent and electricity relationship by greenrating ")
ggplot(newdata,aes(Gas_Costs,Rent)) + 
  geom_point(aes(color=green_rating))+ geom_smooth(se = FALSE)+
  labs(title = "rent and gas relationship by greenrating ")
mean(green$Gas_Costs)
mean(nongreen$Gas_Costs)