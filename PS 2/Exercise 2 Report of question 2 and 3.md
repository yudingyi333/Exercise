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

# Question3

The first thing we did is try to find a good model to predict shares and viral. Regress first means we run the regression first and get the result, then we threshold it as (shares > 1400, 1, 0). We use the prediction to get the confusion matrix, overall error rate, true positive rate, and false positive rate. Threshold first means we use the threshold first and use the (1,0) prediction result directly to get 
the confusion matrix, overall error rate, true positive rate, and false positive rate.
 
The results show that threshold first will helps us get a better prediction.The follows is the result of viral.

          >         yhat
              y      0    1        
                0 2514 1463
                1 1444 2508
              Error rate =(1444+1463)/7929 = 0.36%
              TPR =2508/3952=63.46%
              FOR = 1463/(1463+2514)= 36.78%