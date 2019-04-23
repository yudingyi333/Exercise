# Exericise 4
**By Dingyi Yu Xiaoyu Xu Shuang Jiang**

## Exercise 4.1

## Exercise 4.2

The goal of this question is to identify the market segments. We accomplished this goal in several steps
The first step is raw data processing. We think that “chatter”,” uncategorized” and “spam” are helpless in cluster, so we drop the columns. And, as reminded, we removed some users that maybe are bots.

The second step is center and scale the data and observe the characteristics of data. We established the correlation matrix between each label. We found that some labels have high correlation with some other labels, such as personal_fitness and health_nutrition. We predicted that such users pay more attention to health and may be grouped together. We have a general idea about how to market segment.

The third step is cluster. Even the optimal K seems to be 6 by the method, we still just want to classify these users into five different market types.
![](https://i.imgur.com/xgrGVt6.png)

The fourth step. We run k-means with 5 clusters and 50 starts. We got 5 clusters, however, we do not know who is under the which market. Thus, we use several labels to test our clusters. For example, we use online_gaming and personal_fitness to drew the picture. We found that group 4 prefer online_gaming and group 5 like personal_fitness more.
 
![](https://i.imgur.com/IVqPfgK.png)

We test some users’ data in group 4 and group 5, it seems that the clusters we get are reasonable.

Finally, We using PCA to  get the labels of each market segament.

After the second step, we did the correlation analysis of total 33 categories. In the correlation matrix , we found that the correlation of those categories are relatively weak, as most correlation coefficients are below 0.2. Thus, we suppose that the PVE will not be as high as we expected.

We got top 10 interests of followers of NutrientH20 in each market segment.
 
**Group 1:** "religion" "food" "parenting" "sports_fandom" "school"  "family"  "beauty"        "crafts"  "cooking"  "fashion

**Group 2:** "sports_fandom" "religion"  "parenting" "food" "school" "family"        "automotive"    "news"      "crafts"        "politics"

**Group 3:** "politics" "travel" "computers" "news" "automotive" "business"       "small_business" "college_uni"  "tv_film" "online_gaming" 

**Group 4** "health_nutrition" "personal_fitness" "outdoors" "politics""news"  "eco" "computers"  "travel"  "food" "automotive"  

**Group 5** "beauty" "fashion" "cooking" "photo_sharing" "shopping" "computers" "politics"      "school" "travel" "business
