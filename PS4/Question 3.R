library(arules)  
library(arulesViz)  
library(RColorBrewer)
library(tidyverse)

setwd('C:/Users/yudin/Documents/GitHub/ECO395M/data')
groceries <- read.transactions("groceries.csv", format="basket", sep=",")

# View the statistical summary information about the dataset
summary(groceries)
class(groceries)
dim(groceries)
colnames(groceries)

# BasketSize is the number of items a transaction contains 
basketSize <- size(groceries)
summary(basketSize)
itemFreq <- itemFrequency(groceries)
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
#top 10 rules
inspect(groceryrules[1:10])

inspect(subset(groceryrules,lift>3&confidence > 0.5))

plot(groceryrules)

plot(groceryrules,measure = c("confidence","lift"),shading = "support")

plot(groceryrules,method ='two-key plot')

first.rules <- subset(groceryrules,subset=confidence>0.5&lift >2)

summary(first.rules)

plot(first.rules, method ='graph')

ordered_groceryrules <- sort(groceryrules,by ="lift")

inspect(ordered_groceryrules[1:10])

second.rules <- apriori(groceries, parameter = list(support = 0.025, confidence = 0.1))

print(summary(second.rules))


plot(second.rules, 
       
          control=list(jitter=2, col = rev(brewer.pal(9, "Greens")[4:9])),
       
           shading = "lift")  
 
plot(second.rules, method="grouped",   
      
     control=list(col = rev(brewer.pal(9, "Greens")[4:9])))
 
 
plot(second.rules, measure="confidence", method="graph", 
                
                  control=list(type="items"),
                
                 shading = "lift")