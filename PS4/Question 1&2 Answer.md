# Exericise 4
**By Dingyi Yu Xiaoyu Xu Shuang Jiang**

## Question 4.1
This question needs us to compare the clustering and PCA to test which method is better. 
For the code part:
In the first step, we try to do the clustering. Since we already have basic 2 categories, we choose K=2 to divide the wine into two categories and visualize through the total sulfur dioxide and density. Then, we calculate the accuracy rate to check how well it explains. By using the following confusion matrix, we could get the accuracy rate is (4830+1575)/6947=98.6%

![](https://i.imgur.com/SZvtqSB.png)

Using qplot we get, 

![](https://i.imgur.com/VT4y7xb.png)

In the second step, we try to use the PCA method. Again, we look at the accuracy rate from the confusion matrix and the (4818+1575)/6947=98.4%.

![](https://i.imgur.com/mu8rdUl.png)

Using qplot, we get

![](https://i.imgur.com/o80k6zr.png)

Then we plot the k_grid, SSE_grid and K seems to be 5 by the method.

![](https://i.imgur.com/Z8rxuf0.png)

So we classify wine into five different types.  Then do the clustering and PCA again. In this step, using qplot, we get the clustering like this,

![](https://i.imgur.com/GGSsjpr.png)

We get the PCA like this,

![](https://i.imgur.com/ZDBof9H.png)

**CONCLUSION**

In our opinion, PCA does better than cluster in this case. Because we learn from class that the goal of PCA is to find low-dimensional summaries of high-dimensional data sets, which is useful for compression, denoising, plotting, and making sense of data sets that initially seem too complicated to understand. If we try the clustering, the more similarity in the quality, the better result we will get. But in this case, we want to divide into 5 categories to test present more difference in each group. So it is better to use PCA method.

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
Group 1-5 are the market segments we get.
 
**Group 1:** "religion" "food" "parenting" "sports_fandom" "school"  "family"  "beauty"        "crafts"  "cooking"  "fashion"

**We assume this group is more likely to be adult married woman.**

**Group 2:** "sports_fandom" "religion"  "parenting" "food" "school" "family"  "automotive"  "news"  "crafts"   "politics"

**We assume this group is more likely to be adult married man.**

**Group 3:** "politics" "travel" "computers" "news" "automotive" "business" "small_business" "college_uni"  "tv_film" "online_gaming" 

**We assume this group is more likely to be young man above 18.**

**Group 4** "health_nutrition" "personal_fitness" "outdoors" "politics""news"  "eco" "computers"  "travel"  "food" "automotive" 

**We assume this group is more likely to be people who love fitness and life.** 

**Group 5** "beauty" "fashion" "cooking" "photo_sharing" "shopping" "computers" "politics" "school" "travel" "business

**We assume this group is more likely to be young girls who love beauty and fashion.** 