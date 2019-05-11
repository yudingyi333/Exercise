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

qplot(price, data=X1)

qplot(price, data=X2)

qplot(price, data=X3)

qplot(price, data=X4)

qplot(price, data=X5)