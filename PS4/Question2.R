library(ggplot2)

library(LICORS)  # for kmeans++

library(foreach)

library(mosaic)

setwd('C:/Users/yudin/Documents/GitHub/ECO395M/data')

social = read.csv('../data/social_marketing.csv', header=TRUE,row.names = 1)

summary(social)

# Center and scale the data

M = social[,-c(1,5,35:36)]

M = scale(M, center=TRUE, scale=TRUE)

# find the Correlation between variables

res <- cor(M)

round(res,2)

k_grid = seq(2,20,by=1)
SSE_grid = foreach(k = k_grid, .combine ='c') %do%
  {cluster_k = kmeans(social,k,nstart = 50)
  cluster_k$tot.withinss}

plot(k_grid, SSE_grid)


mu = attr(M,"scaled:center")

sigma = attr(M,"scaled:scale")



# Run k-means with 5 clusters and 50 starts

clust1 = kmeans(M, 5, nstart=50)


# What are the clusters?
clust1$center[1,]*sigma + mu

clust1$center[2,]*sigma + mu

clust1$center[4,]*sigma + mu

# Who are in which clusters?

which(clust1$cluster == 1)

which(clust1$cluster == 2)

which(clust1$cluster == 3)

which(clust1$cluster == 4)

which(clust1$cluster == 5)



# A few plots with cluster membership shown

# qplot is in the ggplot2 library

qplot(online_gaming, personal_fitness, data=social, color=factor(clust1$cluster))

qplot(health_nutrition, personal_fitness, data=social, color=factor(clust1$cluster))

plot_ly(x=social$online_gaming, y=social$personal_fitness, z=social$sports_playing, data= social, type="scatter3d", mode="markers", color=factor(clust1$cluster))%>%
  layout(
    title = "Market Sagement in 3D",
    scene = list(
      xaxis = list(title = "online_gaming"),
      yaxis = list(title = "personal_fitness"),
      zaxis = list(title = "sports_playing")
    ))


# Using kmeans++ initialization

clust2 = kmeanspp(X, k=5, nstart=25)



clust2$center[1,]*sigma + mu

clust2$center[2,]*sigma + mu

clust2$center[4,]*sigma + mu



# Which cars are in which clusters?

which(clust2$cluster == 1)

which(clust2$cluster == 2)

which(clust2$cluster == 3)

which(clust2$cluster == 4)

which(clust2$cluster == 5)

which(clust2$cluster == 6)


# Compare versus within-cluster average distances from the first run

clust1$withinss

clust2$withinss

sum(clust1$withinss)

sum(clust2$withinss)

clust1$tot.withinss

clust2$tot.withinss

clust1$betweenss

clust2$betweenss

#PCA

pc2 = prcomp(M, rank=5)
names(pc2)

loadings = pc2$rotation
scores = pc2$x

VE = pc2$sdev^2
PVE = VE / sum(VE)

# scree Plot
PVEplot = qplot(c(1:34), PVE) + 
  geom_line() + 
  xlab("Principal Component") + 
  ylab("PVE") +
  ggtitle("Scree Plot") +
  ylim(0, 1)

# Cumulative PVE plot
cumPVE = qplot(c(1:34), cumsum(PVE)) + 
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