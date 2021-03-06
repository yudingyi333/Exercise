

#Question 1
##1.(1)to build the best predictive model possible for price;


In order to build the best predictive model possible for price, our group uses " automatically lterative model selection", rather than building the model by hand and comparing it individually, becasue hand building model does not test as much model as "automatic model selection", so there maybe big possibility that the model which is built by hand is not good enough. So our group will try 3 ways for "automatic model selection" which are "Forward Selection", "backward selection" and stepwise selection. And to test which model is the best one, our group uses AIC for comparison, the model which has the lowest AIC are the best model among the models we have runned.

Firstly, we use "Forward Selection Method".
```{r setup, include=FALSE}
library(tidyverse)
library(mosaic)
library(foreach)
library(doMC)  # for parallel computing
```

```{r cars}
lm0 = lm(Rent ~ 1, data=greenbuildings)
lm_forward = step(lm0, direction='forward',
                  scope=~(cluster + size + empl_gr + leasing_rate + stories+
                          age + renovated + class_a + class_b + green_rating
                          + net + amenities +cd_total_07 + hd_total07 + total_dd_07 + Precipitation
                          +Gas_Costs + Electricity_Costs + cluster_rent)^2)
```

The best model which is predicted by "forward Selction" is shown as below:
Rent ~ cluster_rent + size + class_a + class_b + cd_total_07 + 
    age + cluster + net + leasing_rate + Electricity_Costs + 
    hd_total07 + amenities + green_rating + cluster_rent:size + 
    size:cluster + cluster_rent:cluster + size:leasing_rate + 
    cluster_rent:net + class_b:age + class_a:age + cd_total_07:Electricity_Costs + 
    cd_total_07:hd_total07 + cluster_rent:age + cd_total_07:net + 
    size:Electricity_Costs + size:class_a + cluster_rent:leasing_rate + 
    age:Electricity_Costs + cluster:Electricity_Costs + cluster:hd_total07 + 
    cd_total_07:cluster + cluster:leasing_rate + size:cd_total_07 + 
    amenities:green_rating + class_a:cd_total_07 + size:age + 
    Electricity_Costs:amenities + cluster_rent:amenities + size:amenities + 
    size:class_b + class_b:amenities + cluster_rent:cd_total_07

And this model's AIC is 34796.39. However this is not the best model overall, it is just the best model predicted by "forward Selection", and in practical, it is hard to find the best model, especially when you have a large data and many variables. In this case, our group's aim is to find a "decent model" rather than "best model". 

Therefore, our group want to try the "backward model" to see if it has a lower AIC than the model found by "forward Selection". The code should of the "backward selection" should be shown as below""

"lm_big <- lm(Rent ~ (cluster + size + empl_gr + leasing_rate + stories+
                          age + renovated + class_a + class_b + LEED + Energystar + green_rating
                        + net + amenities +cd_total_07 + hd_total07 + total_dd_07 + Precipitation
                        +Gas_Costs + Electricity_Costs + cluster_rent)^2, data = greenbuildings)

step(fullmodel, direction = "backward" )


However, becasue this model is starting from the "full(big) model", and this contains too much data, So the result will come very slowly, our group has waited 40 minutes for this result, but it only came up the first several steps result, so our group gave up the "backward selection method".

Lastly, our group uses stepwise selection, for the start of the stepwise model, our group uses "middle model" to start, the middle model is the model which contains all vriables (excpet LEED and Energystar as the title illustrated) but without any interactions. The coding is shown as below:

```{r pressure, echo=FALSE}
middlemodel <- lm(Rent ~ cluster + size + empl_gr + leasing_rate + stories+
                  age + renovated + class_a + class_b +  green_rating
                + net + amenities +cd_total_07 + hd_total07 + total_dd_07 + Precipitation
                +Gas_Costs + Electricity_Costs + cluster_rent, data = greenbuildings)
lm_step = step(middle, 
               scope=~(.)^2)
```

Accoridng to the "stepwise selection", the best model under this method is shown as below:
Rent ~ cluster + size + empl_gr + leasing_rate + stories + age + 
    renovated + class_a + class_b + green_rating + net + amenities + 
    cd_total_07 + hd_total07 + Precipitation + Gas_Costs + Electricity_Costs + 
    cluster_rent + size:cluster_rent + cluster:size + cluster:cluster_rent + 
    size:Precipitation + stories:cluster_rent + size:leasing_rate + 
    net:cd_total_07 + green_rating:amenities + age:class_b + 
    leasing_rate:cluster_rent + age:renovated + stories:amenities + 
    class_b:Gas_Costs + size:cd_total_07 + class_b:amenities + 
    cluster:leasing_rate + amenities:cluster_rent + age:cluster_rent + 
    renovated:cluster_rent + age:Electricity_Costs + hd_total07:cluster_rent + 
    class_b:Electricity_Costs + class_b:Precipitation + class_a:Precipitation + 
    class_a:Electricity_Costs + class_a:Gas_Costs + empl_gr:class_b + 
    amenities:Electricity_Costs + cluster:stories + stories:cd_total_07 + 
    renovated:hd_total07 + stories:renovated + size:renovated + 
    cluster:Electricity_Costs + cluster:hd_total07 + cluster:cd_total_07 + 
    cluster:Gas_Costs + net:cluster_rent + stories:age + size:age + 
    size:class_a + class_b:hd_total07 + class_a:hd_total07 + 
    Electricity_Costs:cluster_rent + cd_total_07:hd_total07 + 
    amenities:Gas_Costs + amenities:Precipitation + age:Gas_Costs + 
    renovated:cd_total_07 + hd_total07:Electricity_Costs + size:stories

And this model has AIC=34347.14, which is lower than the best model that is calculated by "forward selction". Therefore, the "best preditive model for price" is shown as the model above which is calculated through "stepwise selection". 





##1.(2)to use this model to quantify the average change in rental income per square foot (whether in absolute or percentage terms) associated with green certification, holding other features of the building constant;

In other to answer the question, it needs to work out the coefficient of the "best predictive model".


```{r pressure, echo=FALSE}
bestmodel <- lm(Rent ~ cluster + size + empl_gr + leasing_rate + stories + age + 
                  renovated + class_a + class_b + green_rating + net + amenities + 
                  cd_total_07 + hd_total07 + Precipitation + Gas_Costs + Electricity_Costs + 
                  cluster_rent + size:cluster_rent + cluster:size + cluster:cluster_rent + 
                  size:Precipitation + stories:cluster_rent + size:leasing_rate + 
                  net:cd_total_07 + green_rating:amenities + age:class_b + 
                  leasing_rate:cluster_rent + age:renovated + stories:amenities + 
                  class_b:Gas_Costs + size:cd_total_07 + class_b:amenities + 
                  cluster:leasing_rate + amenities:cluster_rent + age:cluster_rent + 
                  renovated:cluster_rent + age:Electricity_Costs + hd_total07:cluster_rent + 
                  class_b:Electricity_Costs + class_b:Precipitation + class_a:Precipitation + 
                  class_a:Electricity_Costs + class_a:Gas_Costs + empl_gr:class_b + 
                  amenities:Electricity_Costs + cluster:stories + stories:cd_total_07 + 
                  renovated:hd_total07 + stories:renovated + size:renovated + 
                  cluster:Electricity_Costs + cluster:hd_total07 + cluster:cd_total_07 + 
                  cluster:Gas_Costs + net:cluster_rent + stories:age + size:age + 
                  size:class_a + class_b:hd_total07 + class_a:hd_total07 + 
                  Electricity_Costs:cluster_rent + cd_total_07:hd_total07 + 
                  amenities:Gas_Costs + amenities:Precipitation + age:Gas_Costs + 
                  renovated:cd_total_07 + hd_total07:Electricity_Costs + size:stories,data=greenbuildings)
options(scipen = 100)
coef(bestmodel)

mean(greenbuildings$Rent)

2.28/28.42# the ratio between coefficient and average Rent Price
```
The coefficient of green_rating is 2.28, this means keeps the other variables constant, the green buildings's price is 2.28 dollors per square foot higher than non-green buildings, and mean Rent price of the overall data is 28.42 dollars per square foot. 2.28/28.42 is 8% difference. Furthermore, there is an interaction (with green_rating) variable which is green_raiting*amenities which is -2.26, that is keeps the other variable constant, if amenities=1, then the green builiding rating building is only 2.28-2.26=0.02 dollar per square foot more expensive than non-green building. And keeps the other variable constant, if ametities=0, then green building's price is 2.28 dollor more than non-greenbuildings, which is not a very small amount. 

##1.(3) Assess whether the "green certification" effect is different for different buildings, or instead whether it seems to be roughly similar across all or most buildings.

From the model we use, it seems that "green certification" effect is different for the buildings with amenities and the buildings without amenities.  The result is that -2.26 as mentioned in the question 2 answer. The result is different with our prediction. We think that the green certification buildings with amenities should have higher price. There are many possible ways to explain this result. There must have some reason that might have caused prices to fall by green certification and amenities.On the other hand, Another possibility is that the price of the house is relatively poor quality, they need to improve the surrounding  and green certification to attract people to buy.


#Question 2
##Q1：
Why can’t I just get data from a few different cities and run the regression of “Crime” on “Police” to understand how more cops in the streets affect crime? (“Crime” refers to some measure of crime rate and “Police” measures the number of cops in a city.)

Because there is not a clear relationship between the police and the crime. In this case, we could not clarify the police and crime which is the cause and which is the effect. Moreover, there are lots of other variables to affect the effect of ‘crime’ on ‘police’ such as the degree of dangerous of each city and the whether it is the high alert day or not. It is more subjective to get the crime levels of each city without reference point. 

##Q2:
How were the researchers from UPenn able to isolate this effect? Briefly describe their approach and discuss their result in the “Table 2” below, from the researcher's paper.
They use daily police reports of crime from the Metropolitan Police Department of the District of Columbia (Washington, D.C) covering the time period since the alert system began. They regress daily D.C. crime totals against the terror alert level and use a day-of-the-week as an indicator to control for day effects. They obtain daily data on public transportation (Metro) ridership to test whether fewer visitors could explain results. The Metro data suggest a very small decrease in midday ridership on high-alert days. They find that increased Metro ridership is correlated with an increase in crime. And they have to control the ridership because ridership means people go out in which case the crime might happen. They estimate the actual increase in police presence on the street during high-alert periods to calculate an elasticity of crime with respect to police. The table 2 tells us that the increase of the police will have a negative impact on crime holding ridership fixed.


##Q3: 
Why did they have to control for Metro ridership? What was that trying to capture?


That is a confused reason of the police. Because if people are not out during the high alert days, there will be less possible to have crime which is a disturbing effect.
 We want to capture that the more police will lead to less crime. However, there is not a clear model for testing the relationship between the police and the crime.

##Q4:
Below I am showing you "Table 4" from the researchers' paper. Just focus on the first column of the table. Can you describe the model being estimated here? What is the conclusion?
They make another model to address the problem that crime may come in waves; even if they  control for some of this using day-of-the-week effects, but there may be other sources of dependence that result in serial correlation and thus and thus downwardly biased standard errors. 
Y=beta1 high alert* district 1 +beta 2 high alert * other districts +beta 3 log(midday ridership)+ epsilon
 In this new model, they could check the effect of high alert days on crime is same across all districts of the town. The column of the Table 4 reveals that the effect is only clear in the District 1. And the result is corresponding with the hypothesis that during a terror alert, most of the increased police attention will be devoted to District 1. Moreover, for the other districts, there is a small but not clear negative effect.
