
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

### 3.3 
