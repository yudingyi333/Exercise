library(tidyverse)
library(LICORS)
library(ISLR)
library(foreach)
library(mosaic)
library(GGally)

summary(wine)

# Q1: cluster into 2 categories,red and white

# Center and scale the data, data visualization
X = wine[,1:11]
X = scale(X, center=TRUE, scale=TRUE)
mu = attr(X,"scaled:center")
sigma = attr(X,"scaled:scale")

# distribution plot
XX = subset(wine,select = c("total.sulfur.dioxide","density","pH","volatile.acidity"))

# clusting
clust1 = kmeans(X, 2, nstart=20)
qplot(wine$density,wine$total.sulfur.dioxide, data=wine, shape=factor(clust1$cluster), col=factor(wine$color))
res <- cor(X)

# table for the correctly clustering
xtabs(~clust1$cluster + wine$color)
table1 = xtabs(~clust1$cluster + wine$color)

# PCA
pc = prcomp(X, scale=TRUE)
summary(pc)
loadings = pc$rotation
scores = pc$x
# PCA for clustering
clustPCA = kmeans(scores[,1:4], 2, nstart=20)
qplot(scores[,1], scores[,2], color=factor(wine$color), shape=factor(clustPCA$cluster), xlab='Component 1', ylab='Component 2')

# table for the correctly clustering
xtabs(~clustPCA$cluster + wine$color)
tablePCA = xtabs(~clustPCA$cluster + wine$color)

# The top characteristics associated with each component
o1 = order(loadings[,1], decreasing=TRUE)
colnames(X)[o1]
o2 = order(loadings[,2], decreasing=TRUE)
colnames(X)[o2]
o3 = order(loadings[,3], decreasing=TRUE)
colnames(X)[o3]
o4 = order(loadings[,4], decreasing=TRUE)
colnames(X)[o4]

# Q2: cluster into 5 categories

#clusting
k_grid = seq(2,20,by=1)
SSE_grid = foreach(k = k_grid, .combine ='c') %do%
    {cluster_k=kmeans(wine,k,nstart=50)
    cluster_k$tot.withiness}
plot(k_grid, SSE_grid)

clust2 = kmeans(X, 5, nstart=20)
xtabs(~clust2$cluster + wine$quality)
table2 = xtabs(~clust2$cluster + wine$quality)
qplot(wine$density,wine$total.sulfur.dioxide, data=wine, shape=factor(clust2$cluster), col=factor(wine$color))

# Who are in which clusters?
which(clust2$cluster == 1)
which(clust2$cluster == 2)
which(clust2$cluster == 3)
which(clust2$cluster == 4)
which(clust2$cluster == 5)

# PCA
pc = prcomp(X, scale=TRUE)
loadings = pc$rotation
scores = pc$x

# PCA for clustering
clustPCA2 = kmeans(scores[,1:4], 5, nstart=20)
qplot(scores[,1], scores[,2], color=factor(wine$quality), shape = factor(clustPCA2$cluster) , xlab='Component 1', ylab='Component 2')

# table for the correctly clustering
xtabs(~clustPCA2$cluster + wine$quality)
tablePCA = xtabs(~clustPCA2$cluster + wine$quality)
