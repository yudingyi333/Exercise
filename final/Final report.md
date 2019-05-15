
#Final project


## 1.Motivation
Real estate is the first investment option for people in China during past 10 years, thus how will house price goes is always a hot topic among people. In our final project, we will  do some anaylsis about the house price of Beijing. There are many types of rooms on the market. Which is the best one for you to invest? Which kind of house should you choice? This is then interesting to look at the prices since it may reflect several changes China has been in recent years.

## 2. Data preparetion
### 2.1 description of the features:

url: the url which fetches the data( character )

id: the id of transaction( character )

Lng: and Lat coordinates, using the BD09 protocol. ( numerical )

Cid: community id( numerical )

tradeTime: the time of transaction( character )

DOM: active days on market.( numerical )

followers: the number of people follow the transaction.( numerical )

totalPrice: the total price( numerical )

price: the average price by square( numerical )

square: the square of house( numerical )

livingRoom: the number of living room( character )

drawingRoom: the number of drawing room( character )

kitchen: the number of kitchen( numerical )

bathroom the number of bathroom( character )

floor: the height of the house. I will turn the Chinese characters to English in the next version.( character )

buildingType: including tower( 1 ) , bungalow( 2 )，combination of plate and tower( 3 ), plate( 4 )( numerical )

constructionTime: the time of construction( numerical )
renovationCondition: including other( 1 ), rough( 2 ),Simplicity( 3 ), hardcover( 4 )( numerical )

buildingStructure: including unknow( 1 ), mixed( 2 ), brick and wood( 3 ), brick and concrete( 4 ),steel( 5 ) and steel-concrete composite ( 6 ).( numerical )

ladderRatio: the proportion between number of residents on the same floor and number of elevator of ladder. It describes how many ladders a resident have on average.( numerical )

elevator have ( 1 ) or not have elevator( 0 )( numerical )
fiveYearsProperty: if the owner have the property for less than 5 years( numerical )

### 2.2 Data Cleaning
We did data cleaning mainly in Excel which is more convenient.

Firstlt, we think that url, id, Cid are not useful for our analysis, thus we delete them from the origial data set.

Secondly, we found that a large part of DOM are missing. I decided to keep this feature at first and just use the data set which DOM is not missing which decreased our simple size from 300K to 70K roughly.

Otherwise there are some missing values or NA in the buildingType and communityAverage(pop.) for which I decide to simply remove the values. Indeed they only account for hundreds rows compared to 70k+ of the entire dataset so the loss is not too big.

Finally, I simply remove some features that I don’t plan to use later, such as some characters are in Chinese.

## 3 Exploratory analysis on the clean dataset
We have to focus on price (price of unit / flat in yuan) as well as totalPrice(in millions yuan)
Price will be the target variable of the regression model.

###3.1 Numerical features
![](https://i.imgur.com/U3Vwaem.png)

Comments:

Price has a strong positive correlation with the communityAverage which means prices of homes are higher in dense population area.

Price has some positive correlation with the number of living room, the number of bath room and the number of drawing room

as for the square variable, we see that it has a strong correlation with the above variables too: it makes sense since if the home has a large square footage, the chance you can build more room is higher(obvious)
some other interesting correlation: communityAverage has a negative correlation with the construction time, meaning it takes less time to build a home in a dense population area.

###3.2 Cluster
We decided to cluster all the houses into five categorize.
And we plot several images to show the characteristics of the five different categorize.



![](https://i.imgur.com/AaHoXh7.png)

From the graph, we can see clearly that cluster 5 are the larger house and cluster 2 are high price house relatively.

![](https://i.imgur.com/k15ntlD.png)
From this graph, we can see that cluster 4 are more type 1 and 3 and cluster 5 are more in type 4.

![](https://i.imgur.com/g7z0O8K.png)

This graph is more interesting because we found that the more followers the higher price in group 4 and the more followers the less price in cluster 2 which is the expensive house.

Thus, we think that for different types of houses, the factors that affect their prices are also different.

We found that every time you rerun the coding, the color and the number of each clusters changed but the five types don't actually change. Thus we need give each group some labels.

We use PCA method to cluster the house based on the features without the tradeTime. 
Still, We divided all the houses into five categories. 

 

Cluster 1 
"buildingType" "district" "Lat" "communityAverage" "price" "fiveYearsProperty" "subway"            "followers" "ladderRatio" "Lng"              

Cluster 2 
"buildingStructure" "elevator" "constructionTime" "Lng" "subway" "ladderRatio"        
"fiveYearsProperty" "kitchen" "renovationCondition" "followers"
          
Cluster 3
"price" "elevator" "communityAverage" "buildingStructure" "DOM" "district"    "renovationCondition" "followers" "constructionTime" "Lat"                

Cluster 4
"followers" "DOM" "renovationCondition" "Lng" "buildingType" "subway" "price"               "constructionTime" "livingRoom" "totalPrice"         

Cluster 5
"constructionTime" "price" "buildingType" "communityAverage" "totalPrice" "DOM"             
"drawingRoom" "followers" "bathRoom" "square" 


Then we use linear regression to find the relationship between their prices and other variables.

In lm1 model, we found that Lat, followers,living Room, buildingType, renovationCondition, buildingStructure, subway and district have more positive impact on the price.

In lm2 model, we found that only Lng, DOM, followers,kitchen, bathroom have more positive impact on the price. According to the actual situation, cluster 2 is the expensive houses, which are more located in the west part of Beijing where has more good schools for kids and infrastructure.

In lm3 model, we found that Lat, DOM, followers,kitchen, bathroom, renovationCondition and communityAverage have more positive impact on the price.

In lm4 model, we found that followers, drawingRoom, kitchen, bathRoom,renovationCondition, elevator, and subway have more positive impact on the price.

In lm5 model, we found that Lng, Lat, followers, drawingRoom, bathRoom, RnovationCondition,have more positive impact on the price.

**From the five simple linear model, we can tell it is true that  the price of house in different categories will increase by different reasones. Thus, in our price forecasting, we need adjust this situation to see which kind of house will perform better if we decided to invest**

### 3.3 model prediction
**The following result is based on the first run and we found that each time the cluster's number change, thus, there may be some inconsistent data. However, The cluster 4 we mentioned under is the cluster two we use above, we named them the expensive house cluster**

We build models to analyze the relation of price and other variables for each cluster. 
Firstly, we split each cluster data into two sets. If the trade time is before 2017, data will go into the train data set. If the trade time is after 2017, data will go into the test data set.
Secondly, we use forward linear regression to test the relation to get the best model of each cluster. 
Thirdly, using this model to check the test set to get rmse. The rmse is smaller, the better the model fit the dataset which means better predict the relation of price and the variables. After testing all five clusters, we get the rmse for cluster 1 is 24203.75, for cluster 2 is 30082.05, for cluster 3 is 23822.85, for expensive house cluster is 21503.17, for cluster 5 is 26454.4. In this case, the model for cluster 4 best fits the data.
We use this model to get the predicted price which is compared with the actual price.  If the predicted price is higher than the actual price, this house is worth investing because the trade price is underestimated which means it has lot of room for the price to get higher in the future. In this case, we could sell it at a higher price than other houses.
For example, as for the expensive house cluster, the best model predicted by “forward method is

![](https://i.imgur.com/bD0c5vh.png)

And its relevant coefficient of variables are:

![](https://i.imgur.com/egUfYiJ.png)

From the coefficient of variables, the biggest coefficient variable is “fiveYearsProperty” and this variable shows that if the owner have the property for less than 5 years, the price of the house would be decreased, this may because people do not like to live in “high turnover rate house”, they may think it must have some reasons for the residence to give up the house due to its specific characteristics, such as the location of the house, the neighbor of the house or even maybe the “bad history” of the house, the second largest coefficient is subway, and its coefficient is negative, usually the coefficient for the subway should be positive. But why is the situation?

And this may because in expensive house cluster, the price of the house is commonly very high as the graph shows. And for rich people, they will not usually or even most of them would never take public transportation like bus and subway, thus they do not need to the subway near their house. Adversely, the house which is near the subway is crowded, and this will annoy the residence. So this maybe the reason why cluster 2’s subway coefficient is negative. The above illustration does not consider the interaction term. Still includes subway included as an example. Interaction term of ladder ratio and subway, the coefficient of the variable is positive, mean when there is subway, the price will change by coefficient*ladder ratios + subway coefficient + ladder* ladder coefficient. 

In order to use the “pricing model”, it is important to collect the variables data and substituted the data in this model to see what is the house price which is ran by the model. So can give the house a price in value, to see if the house price now is understated or overstated. And there is one thing important, to find according cluster model to predict, for example, cluster4 model, it has high price character, so it needs to find the house price which is more than 10000 rmb/ square. So for example, if the after substituting the data, the price predicted by the cluster4 model is 15,000 rmb/ square, and the price now is 17,000 rmb, then it is not valuable to buy the house.


##4 Conclusion
As our data shows above, we found that the expensive house has the most accurate price forecast which means that if you give me the characteristics of a luxury real estate, we could have the best prediction of it. That is to say the more expensive house, the better its price stay increasing trend because the inflation and the lower risk it faces.

![](https://i.imgur.com/kdtr5ow.png)

As the graph shows, the most expensive house are located in Chaoyang district which has the most yellow points. If you want buy a house in Beijing, our suggestion is buy the house in Chaoyang.

It is interesting to see that there's a missing piece of data in the middle. Houses in city center should be more expensive. At first, we think something wrong with our data. It took us sometime to remember that it is forbidden City in the middle.

##5 What problem we have or need to improve

Firstly, because we work in groups of three, each memebers have different clusters. Thus there are a lot of misrepresentations about the number of clusters. We tried our best to find every mistake and correct them. 

Secondly, we know that the models we get has some disadvantages, it cannot consider the inflation factor and macro policy factors, because such macro factors will influence the price level overall, rather than individual house price. And also, under this method, the model is required to include a lot of “predictive” variables, in this case the model can predict some houses which has huge different price than the model predicted but the model actually is wrong. For example, if the government is going to build a school near some houses, the price of the house will definitely increase, which the model cannot catch.

Thirdly, we should try to see that how our prediction of price changes over time, which will give us the effect in time series. And we should use other method to improve the accuracy to predict the house price, such as regression and classification trees or KNN. However, we do not have enough time for all of them.






