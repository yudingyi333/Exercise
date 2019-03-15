
#Question1

##Saratoga house prices

###Hand build Model
Our group has tried several models in order to minimize the RMSE, and for each model, we found 200 times trained group and test group and workout it 200 times RMSE and average them, in order to minimize the error. (If only run the model for only 1 time, there is a big possibility of random). After testing several models’ RMSE, finally, we found a satisfied model which we think it has a low RMSE, at least the RMSE of the model we used is much lower than “medium” model. The model we used is shown below: 

         > price=bedrooms+ newConstruction+ heating+ fireplaces+ livingArea+ age+waterfront+centralAir+rooms*heating+landValue*lotSize+rooms*bathrooms.

And in order to find the strong drivers of house prices, I think there are two points of view to find the strong drivers. Firstly, it is important to select if you drop any of the variable in your model, your RMSE will be much bigger. (Say your model is less correctly predict than before). Secondly, check the coefficient of each variable, this aim is to see which variable’s change can lead to big change in price. 

As for the first point, our group select some variables which we think can lead to big increase in RMSE, the variable we test respectively are room*bathrooms, age, bedrooms, and centralAir. And we workout colmeans of each variable. The result is shown below (every time run the coding the result will be different, because the trained group and test group are random assigned):

 
v1-meidium model 

v2-big model

v3-standard model-the model we use

v4-v7 are the models to test which variables in v3 model are “strong drivers”

v4-standard model without room*bathrooms variable

v5-standared model without age variable

v6-standard model without bedrooms variable 

v7-standard model without centralAir Variable
![](https://i.imgur.com/lvyEdHw.png)

From the result above we can see standard model has the lowest RMSE. (cause it runs 200 times so the colMeans result is stable to most extent) And it is much lower than the medium model. 
Comparing v3 with v4-v7, we can see the biggest different is v7(without centralAir variable) the second biggest difference is V6 (without bedrooms variable) So accordingly, we think centralAir and bedrooms are strong drivers house prices according to RMSE indicator.

As for the second point, our group will workout the coefficient of the model we select, but it is not right to directly to find out their coefficient, for example: for living area and bedrooms, adding 1 more feet of living area is different from adding 1 more bedroom. In this case, we standardized each variable. 

After standardrized, we found the coefficient of each variable:

![](https://i.imgur.com/Z6BTyGp.png) 

And we definite the strong driver as the top 3 coefficient variables are strong driver: so in this case, livingarea, bathrooms and landValue are 3 strong drivers.

When using KNN model, we just follow the instruction, don’t include interactions of our standard model, and after standardized, we plot RMSE versus K, the graph is shown below:

 ![](https://i.imgur.com/nSAMOyU.png)

This graph shows when k = 11(approximately), the RMSE will be minimized, but every time the K which minimize the RMSE maybe different , because each time will have different group of trained and test group. And at this time we run the model, the KNN is 60771.18 as the graph below shows.

 ![](https://i.imgur.com/IkPMQTE.png)

And this number is much bigger than the “hand build linear model” which has the RMSE of 58484 (both models using the same trained and test data). This means linear model can predict more accurately than KNN model, so hand build linear model can turn into better performing than KNN model. 

So for local taxing authority, they need to levy tax according to the price of house, as the above illustrated, the hand build model has more accurately prediction, so it is better for taxing authority using the hand build linear model to predict price:
price=bedrooms+ newConstruction+ heating+ fireplaces+ livingArea+ age+waterfront+centralAir+rooms*heating+landValue*lotSize+rooms*bathrooms.
And according to the predicted price, it can know how much local taxing authority should tax.



#Question 2

##Exercise 2.2.1


- Firstly, we found that if we predict that none of them had cancer, we will have an accuracy that performs better than any model we used to predict. But this means that we miss all cancer patients and have a high false negative . If we ask the radiologists to recall all the patients, we will find all cancer patients but we will have a very high false positives. When we are trying to build a model to predict the result we found that it is hard to minimizing false negatives and false positives at the same time. We think that it is more important to minimizing false negatives than minimizing false positives.

- First question：
The models we used get the results(RMSE) that as follows: 

        > 0.1493401 0.1857107 0.1514213 0.1499492 0.1575127 0.158020 0.1651269

Based on our test, we find that there are some radiologists more clinically conservative than others in recalling patients. We know the problem that the radiologists do not see the same patients. So we build “out of sample test”. Our model simulates radiologists’ judgment. After training, If the model turns out to be valid in raw data, then it should performs the same in 'out-of-sample test' which is a different set of data. We asked all radiologists to look at all out of samples to see if their recall rate is still the same as that of raw data.
The higher prob recall means the more conservative the radiologist is. 

###Results:

     >     |radiologist13|0.139| 

           |radiologist34|0.0872|

           |radiologist66|0.191| 

           |radiologist89|0.211|     

           |radiologist95|0.0998|


We re-runed the result many times, it seems that the radiologist89 is the most conservative and radiologist34 is the most not conservative. 

##Exercise 2.2.2

- The result we get is that the radiologists should be weighing some clinical risk factors, such as breast density classification and menopause status, more heavily than they currently are. The steps and result are as follows
First we build the benchmark, which is model0. The model0 means when the doctors recall a patient, they think that the patient has cancer. If other clinical risk factors are helpful in the judgment of whether they have cancer or not, then the model 1 to model 5 will performs better than the benchmark.

           >  V1       V2       V3       V4       V5       V6 
             1.455376 1.500908 1.438493 1.436622 1.433988 1.493219  
From the results, we can see that if the radiologist consider history, symptoms and menopause, the error will slightly lower error rate. We know that if we consider the interaction terms, the error will be lower than model0 to model 5, however there are too many possibilities. The result of model 2, model 3 and model 4 are enough to prove the importance of other clinical risk factors.

         > t0
                            yhat_test0
           brca_test$cancer    0   1
                           0  166  20
                           1   3   8
         > t1 
                            yhat_test1
           brca_test$cancer   0   1
                           0 125  61
                           1   2   9
         > t2 
                            yhat_test2
           brca_test$cancer   0   1
                           0 166  20
                           1   3   8
         > t3 
                           yhat_test3
           brca_test$cancer   0   1
                           0 166  20
                           1   3   8
         > t4 
                           yhat_test4
           brca_test$cancer   0   1
                           0 158  28
                           1   3   8
         > t5
                           yhat_test5
           brca_test$cancer   0   1
                           0 151  35
                           1   2   9
 
  
From the tables(t0-t5) we can get that density also could increase the
true positive rate from 8/(3+8)= 72.7% to 9/(2+9)= 81.8%. Although the false positive rate increased, we found one more patient from the pool.It is worth it.