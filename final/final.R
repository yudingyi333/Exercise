library(tidyverse)
library(mosaic)
library(foreach)
library(doMC)
library(ggplot2)
library(dbplyr)
library(lubridate)

summary(beijing.house.price)

M = beijing.house.price[,-c(3)]
M = scale(M, center = TRUE, scale =TRUE)
res <- cor(M)
round(res,2)

mu = attr(M,"scaled:center")

sigma = attr(M,"scaled:scale")

clust1 = kmeans(M, 5, nstart=50)

clust1$center[1,]*sigma + mu

clust1$center[2,]*sigma + mu

clust1$center[4,]*sigma + mu

qplot(square,price, data=beijing.house.price, col=factor(clust1$cluster))
qplot(buildingType,price, data=beijing.house.price, col=factor(clust1$cluster))
qplot(followers,price, data=beijing.house.price, col=factor(clust1$cluster))
qplot( price,subway, data=beijing.house.price, color=factor(clust1$cluster))
qplot( price, data=beijing.house.price, color=factor(clust1$cluster))

pc2 = prcomp(M, rank=5)

names(pc2)


loadings = pc2$rotation

scores = pc2$x



VE = pc2$sdev^2

PVE = VE / sum(VE)



# scree Plot

PVEplot = qplot(c(1:2,4:22), PVE) + 
  
  geom_line() + 
  
  xlab("Principal Component") + 
  
  ylab("PVE") +
  
  ggtitle("Scree Plot") +
  
  ylim(0, 1)

cumPVE = qplot(c(1:2, 4:22), cumsum(PVE)) + 
  
  geom_line() + 
  
  xlab("Principal Component") + 
  
  ylab(NULL) + 
  
  ggtitle("Cumulative Scree Plot") +
  
  ylim(0,1)



round(PVE, 2)



o1 = order(loadings[,1], decreasing=TRUE)

colnames(M)[head(o1,10)]



o2 = order(loadings[,2], decreasing=TRUE)

colnames(M)[head(o2,10)]



o3 = order(loadings[,3], decreasing=TRUE)

colnames(M)[head(o3,10)]



o4 = order(loadings[,4], decreasing=TRUE)

colnames(M)[head(o4,10)]



o5 = order(loadings[,5], decreasing=TRUE)

colnames(M)[head(o5,10)]


X1 = subset(beijing.house.price,clust1$cluster == 1)

lm1 = lm(price ~.-tradeTime,data = X1)

summary(lm1)

X2 = subset(beijing.house.price,clust1$cluster == 2)

lm2 = lm(price ~.-tradeTime,data = X2)

summary(lm2)

X3 = subset(beijing.house.price,clust1$cluster == 3)

lm3 = lm(price ~.- tradeTime,data = X3)

summary(lm3)

X4 = subset(beijing.house.price,clust1$cluster == 4)

lm4 = lm(price ~.-tradeTime,data = X4)

summary(lm4)

X5 = subset(beijing.house.price,clust1$cluster == 5)

lm5 = lm(price ~.-tradeTime,data = X5)

summary(lm5)

train_data1 = X1 %>% filter (as.numeric (substr(tradeTime,1,4))<2017)

test_data1 = X1 %>% filter (as.numeric (substr(tradeTime,1,4))>=2017)

lm1 = lm(price ~ 1, data=train_data1)

##split into 2 groups

#X1 
train_data1 = X1 %>% filter (as.numeric (substr(tradeTime,1,4))<2017)
test_data1 = X1 %>% filter (as.numeric (substr(tradeTime,1,4))>=2017)
lm1 = lm(price ~ 1, data=train_data1)

#Aic=120424.3
lm_forward1 = step(lm1, direction='forward',
                   scope=~(DOM + followers + square+
                             livingRoom + drawingRoom + kitchen + bathRoom +buildingType 
                           + constructionTime + renovationCondition + buildingStructure +ladderRatio + elevator+ fiveYearsProperty+communityAverage+subway)^2)



lmX1=lm(price ~ communityAverage + renovationCondition + DOM + fiveYearsProperty + 
          followers + square + elevator + ladderRatio + constructionTime + 
          buildingType + buildingStructure + DOM:followers + DOM:square + 
          communityAverage:renovationCondition + DOM:fiveYearsProperty + 
          communityAverage:fiveYearsProperty + renovationCondition:followers + 
          communityAverage:followers + renovationCondition:fiveYearsProperty + 
          renovationCondition:square + communityAverage:ladderRatio + 
          square:constructionTime + followers:square + communityAverage:square + 
          fiveYearsProperty:constructionTime + square:elevator + square:ladderRatio + 
          followers:constructionTime + elevator:buildingType + communityAverage:constructionTime + 
          fiveYearsProperty:ladderRatio + ladderRatio:constructionTime + 
          renovationCondition:constructionTime + fiveYearsProperty:elevator + 
          DOM:elevator + followers:buildingType + elevator:constructionTime + 
          fiveYearsProperty:square + communityAverage:buildingType + 
          constructionTime:buildingType + communityAverage:buildingStructure + 
          communityAverage:elevator + constructionTime:buildingStructure + 
          buildingType:buildingStructure + elevator:buildingStructure + 
          DOM:constructionTime + renovationCondition:DOM,data=train_data1)

yhat_1 = predict(lmX1, test_data1)
rmse = function(y, yhat) {
  sqrt( mean( (y - yhat)^2 ) )
}
rmse(test_data1$price, yhat_1)
#rmse24203.75


#X2
train_data2 = X2 %>% filter (as.numeric (substr(tradeTime,1,4))<2017)
test_data2 = X2 %>% filter (as.numeric (substr(tradeTime,1,4))>=2017)
lm2 = lm(price ~ 1, data=train_data2)

#7463
lm_forward2 = step(lm2, direction='forward',
                   scope=~(DOM + followers + square+
                             livingRoom + drawingRoom + kitchen + bathRoom +buildingType 
                           + constructionTime + renovationCondition + buildingStructure +ladderRatio + elevator+ fiveYearsProperty++communityAverage+subway)^2)

##7434.91
lmX2=lm(price ~ communityAverage + constructionTime + DOM + fiveYearsProperty + 
          renovationCondition + square + elevator + ladderRatio + subway + 
          buildingType + DOM:renovationCondition + constructionTime:square + 
          square:elevator + communityAverage:renovationCondition + 
          communityAverage:ladderRatio + communityAverage:fiveYearsProperty + 
          constructionTime:ladderRatio + square:ladderRatio + elevator:buildingType + 
          communityAverage:buildingType + fiveYearsProperty:elevator + 
          constructionTime:DOM + ladderRatio:buildingType,data=train_data2)

yhat_2 = predict(lmX2, test_data2)
rmse(test_data2$price, yhat_2)
#rmse30082.05

# X3
train_data3 = X3 %>% filter (as.numeric (substr(tradeTime,1,4))<2017)
test_data3 = X3 %>% filter (as.numeric (substr(tradeTime,1,4))>=2017)
lm3 = lm(price ~ 1, data=train_data3)

lm_forward3 = step(lm3, direction='forward',
                   scope=~(DOM + followers + square+
                             livingRoom + drawingRoom + kitchen + bathRoom +buildingType 
                           + constructionTime + renovationCondition + buildingStructure +ladderRatio + elevator+ fiveYearsProperty++communityAverage+subway)^2)

#446402.5
lmX3=lm(price ~ communityAverage + renovationCondition + DOM + fiveYearsProperty + 
          followers + square + livingRoom + drawingRoom + buildingStructure + 
          elevator + kitchen + subway + bathRoom + communityAverage:renovationCondition + 
          DOM:followers + communityAverage:followers + renovationCondition:followers + 
          DOM:fiveYearsProperty + communityAverage:square + renovationCondition:DOM + 
          communityAverage:DOM + followers:livingRoom + DOM:livingRoom + 
          renovationCondition:fiveYearsProperty + DOM:drawingRoom + 
          DOM:square + renovationCondition:drawingRoom + fiveYearsProperty:livingRoom + 
          communityAverage:buildingStructure + communityAverage:drawingRoom + 
          renovationCondition:livingRoom + communityAverage:elevator + 
          square:livingRoom + livingRoom:drawingRoom + renovationCondition:square + 
          square:elevator + fiveYearsProperty:drawingRoom + drawingRoom:buildingStructure + 
          followers:drawingRoom + livingRoom:kitchen + DOM:subway + 
          communityAverage:subway + livingRoom:subway + livingRoom:elevator + 
          communityAverage:fiveYearsProperty + communityAverage:livingRoom + 
          DOM:buildingStructure + followers:buildingStructure + followers:square + 
          fiveYearsProperty:subway + followers:elevator + square:bathRoom + 
          communityAverage:bathRoom + fiveYearsProperty:bathRoom + 
          livingRoom:bathRoom + renovationCondition:bathRoom + kitchen:bathRoom + 
          elevator:bathRoom + DOM:bathRoom,data=train_data3)

yhat_3 = predict(lmX3, test_data3)
rmse(test_data3$price, yhat_3)
#23822.85

# X4
train_data4 = X4 %>% filter (as.numeric (substr(tradeTime,1,4))<2017)
test_data4 = X4 %>% filter (as.numeric (substr(tradeTime,1,4))>=2017)
lm4 = lm(price ~ 1, data=train_data4)

lm_forward4 = step(lm4, direction='forward',
                   scope=~(DOM + followers + square+
                             livingRoom + drawingRoom + kitchen + bathRoom +buildingType 
                           + constructionTime + renovationCondition + buildingStructure +ladderRatio + elevator+ fiveYearsProperty++communityAverage+subway)^2)
#258917.3
lmX4=lm(price ~ communityAverage + renovationCondition + DOM + fiveYearsProperty + 
          square + followers + ladderRatio + subway + livingRoom + 
          kitchen + buildingStructure + communityAverage:DOM + communityAverage:renovationCondition + 
          DOM:followers + renovationCondition:followers + DOM:fiveYearsProperty + 
          renovationCondition:DOM + square:ladderRatio + communityAverage:followers + 
          communityAverage:livingRoom + DOM:livingRoom + communityAverage:subway + 
          communityAverage:ladderRatio + square:livingRoom + ladderRatio:livingRoom + 
          DOM:ladderRatio + ladderRatio:subway + renovationCondition:fiveYearsProperty + 
          fiveYearsProperty:followers + renovationCondition:ladderRatio + 
          followers:livingRoom + renovationCondition:kitchen + fiveYearsProperty:subway + 
          communityAverage:buildingStructure + DOM:buildingStructure + 
          renovationCondition:buildingStructure + communityAverage:square + 
          subway:buildingStructure,data=train_data4)

yhat_4 = predict(lmX4, test_data4)
rmse(test_data4$price, yhat_4)
#21503.17


#X5
train_data5 = X5 %>% filter (as.numeric (substr(tradeTime,1,4))<2017)
test_data5 = X5 %>% filter (as.numeric (substr(tradeTime,1,4))>=2017)
lm5 = lm(price ~ 1, data=train_data5)

lm_forward5 = step(lm5, direction='forward',
                   scope=~(DOM + followers + square+
                             livingRoom + drawingRoom + kitchen + bathRoom +buildingType 
                           + constructionTime + renovationCondition + buildingStructure +ladderRatio + elevator+ fiveYearsProperty++communityAverage+subway)^2)
#168636.5
lmX5=lm(price ~ communityAverage + DOM + renovationCondition + fiveYearsProperty + 
          square + buildingStructure + followers + constructionTime + 
          drawingRoom + livingRoom + elevator + buildingType + bathRoom + 
          subway + ladderRatio + communityAverage:DOM + DOM:fiveYearsProperty + 
          communityAverage:renovationCondition + DOM:renovationCondition + 
          DOM:followers + square:constructionTime + fiveYearsProperty:followers + 
          renovationCondition:fiveYearsProperty + fiveYearsProperty:square + 
          DOM:square + renovationCondition:followers + communityAverage:followers + 
          communityAverage:fiveYearsProperty + communityAverage:square + 
          DOM:buildingStructure + communityAverage:constructionTime + 
          fiveYearsProperty:constructionTime + renovationCondition:buildingStructure + 
          square:drawingRoom + square:livingRoom + buildingStructure:constructionTime + 
          buildingStructure:elevator + constructionTime:elevator + 
          communityAverage:elevator + renovationCondition:buildingType + 
          communityAverage:subway + livingRoom:bathRoom + followers:drawingRoom + 
          fiveYearsProperty:bathRoom + buildingType:subway + elevator:ladderRatio + 
          buildingStructure:buildingType + constructionTime:ladderRatio + 
          buildingType:ladderRatio + square:elevator + livingRoom:elevator + 
          livingRoom:subway + DOM:subway + communityAverage:buildingStructure + 
          fiveYearsProperty:ladderRatio + buildingStructure:followers + 
          communityAverage:livingRoom + communityAverage:bathRoom + 
          buildingStructure:bathRoom + followers:bathRoom,data=train_data5)

yhat_5 = predict(lmX5, test_data5)
rmse(test_data5$price, yhat_5)
#26454.4

options(scipen = 100)
coefficients (lmX4)

which(clust1$cluster == 2)

BeijingLoc <- data.frame('Long'=116.4075,'Lat' = 39.904)
beijing.house.price %>% ggplot(aes(x=Lng,y=Lat)) + geom_point(aes(color=price),size=1,alpha=.5)  + 
  scale_colour_gradientn(colors = viridis::viridis(100)) + theme_minimal() + 
  theme(legend.position = 'bottom') + 
  guides(color = guide_colorbar(barwidth = 35, barheight = .75)) +
  geom_point(data=BeijingLoc,aes(x=Long,y=Lat),size=2,color='black') +
  theme(axis.title= element_blank(), axis.text = element_blank()) +
  labs(title='Average home price in Beijing geographically') + coord_fixed(1.3)
