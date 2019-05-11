library(tidyverse)
library(mosaic)
library(foreach)
library(doMC)
library(ggplot2)

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



#7463

lm_forward = step(lm1, direction='forward',
                  
                  scope=~(DOM + followers + square+
                            
                            livingRoom + drawingRoom + kitchen + bathRoom +buildingType 
                          
                          + constructionTime + renovationCondition + buildingStructure +ladderRatio + elevator+ fiveYearsProperty
                          
                          +subway + district + communityAverage)^2)



lm1medium = lm(price~DOM + followers + square+
                 
                 livingRoom + drawingRoom + kitchen + bathRoom +buildingType 
               
               + constructionTime + renovationCondition + buildingStructure +ladderRatio + elevator+ fiveYearsProperty
               
               +subway + district + communityAverage,data=train_data1)

#AIC=7382

lm_step = step(lm1medium, 
               
               scope=~(DOM + followers + square+
                         
                         livingRoom + drawingRoom + kitchen + bathRoom +buildingType 
                       
                       + constructionTime + renovationCondition + buildingStructure +ladderRatio + elevator+ fiveYearsProperty
                       
                       +subway + district + communityAverage)^2)





lmX1=lm(price ~ DOM + followers + square + livingRoom + drawingRoom + 
          
          bathRoom + buildingType + constructionTime + renovationCondition + 
          
          buildingStructure + ladderRatio + elevator + fiveYearsProperty + 
          
          district + communityAverage + ladderRatio:communityAverage + 
          
          square:elevator + renovationCondition:communityAverage + 
          
          bathRoom:buildingStructure + followers:renovationCondition + 
          
          buildingStructure:ladderRatio + constructionTime:ladderRatio + 
          
          drawingRoom:buildingStructure + bathRoom:renovationCondition + 
          
          followers:square + followers:elevator + DOM:constructionTime + 
          
          livingRoom:elevator + livingRoom:constructionTime + followers:ladderRatio + 
          
          buildingType:communityAverage + buildingType:elevator + DOM:square + 
          
          DOM:followers,data=train_data1)



yhat_1 = predict(lmX1, test_data1)

rmse = function(y, yhat) {
  
  sqrt( mean( (y - yhat)^2 ) )
  
}

rmse(test_data1$price, yhat_1)