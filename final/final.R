library(tidyverse)
library(mosaic)
library(foreach)
library(doMC)
library(ggplot2)



library(LICORS)  # for kmeans++



library(foreach)



library(mosaic)

summary(beijing.house.price)
lm0 = lm(price ~ .,data = beijing.house.price)

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

which(clust1$cluster == 1)



which(clust1$cluster == 2)



which(clust1$cluster == 3)



which(clust1$cluster == 4)



which(clust1$cluster == 5)


qplot(square, price, data=beijing.house.price, color=factor(clust1$cluster))

qplot(price,buildingType,data=beijing.house.price, color=factor(clust1$cluster))



qplot(health_nutrition, personal_fitness, data=social, color=factor(clust1$cluster))



plot_ly(x=price, y=square, z=subway, data= beijing.house.price, type="scatter3d", mode="markers", color=factor(clust1$cluster))%>%
  
  layout(
    
    title = "Market Sagement in 3D",
    
    scene = list(
      
      xaxis = list(title = "price"),
      
      yaxis = list(title = "square"),
      
      zaxis = list(title = "subway")
      
    ))

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