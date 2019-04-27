library(arules)  
library(arulesViz)  
library(RColorBrewer)
library(tidyverse)


myurl<- ('https://github.com/yudingyi333/Exercise/blob/master/PS4/groceries.csv')
groceries = as(groceries, "transactions")

# View the statistical summary information about the dataset
summary(groceries)
class(groceries)
dim(groceries)
colnames(groceries)

# BasketSize is the number of items a transaction contains 
basketSize <- size(groceries)
summary(basketSize)
basketSize
itemFreq <- itemFrequency(groceries)
itemFreq
# how many items each transaction bought in average
sum(itemFreq)

itemCount <- (itemFreq/sum(itemFreq))*sum(basketSize)
summary(itemCount)
orderedItem <- sort(itemCount, decreasing = T )
orderedItem
itemFrequencyPlot(groceries, support=0.1)

itemFrequencyPlot(groceries, topN=10, horiz=T)
groceries_use <- groceries[basketSize > 1]
dim(groceries_use)

# evaluation model
groceryrules <- apriori(groceries, parameter = list(support =0.01, confidence = 0.25, minlen = 2))
summary(groceryrules)
grocery
inspect(groceryrules[1:10])
inspect(groceryrules[90])#root veg=>other vege
inspect(groceryrules[127])#root vege,tropical furit=>other vege
plot(groceryrules)
plot(groceryrules,measure = c("confidence","lift"),shading = "support")
plot(groceryrules,method ='two-key plot')
#top 10 rules
#confidence:eg.Support(wholemilk,hard cheese)/support(hard cheese)
#lift:support(whole milke, hard cheese)/support(whole milk)* support(hard cheese)
#support: hard cheese, whole milk / 9935
#count: hard cheese, whole milk count 99 times
inspect(subset(groceryrules,lift>3&confidence > 0.5))



#second rules
second.rules <- apriori(groceries, parameter = list(support = 0.025, confidence = 0.2))
print(summary(second.rules))
plot(second.rules, 
     control=list(jitter=2, col = rev(brewer.pal(9, "Greens")[4:9])),
     shading = "lift")  
plot(second.rules, method="grouped",   
     control=list(col = rev(brewer.pal(9, "Greens")[4:9])))
plot(second.rules, measure="confidence", method="graph", 
     control=list(type="items"),
     shading = "lift")



saveAsGraph(subset(groceryrules, subset=confidence>0.5&lift >2), file = "consumerrules.graphml",type="items")
