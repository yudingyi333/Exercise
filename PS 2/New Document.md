#Question 2

##Exercise 2.2.1


- Firstly, we found that if we predict that none of them had cancer, we will have an accuracy that performs better than any model we used to predict. But this means that we miss all cancer patients and have a high false negative . If we ask the radiologists to recall all the patients, we will find all cancer patients but we will have a very high false positives. When we are trying to build a model to predict the result we found that it is hard to minimizing false negatives and false positives at the same time. We think that it is more important to minimizing false negatives than minimizing false positives.

- First question：
The models we used get the results(RMSE) that as follows:
   result    result    result    result    result    result    result 
0.1493401 0.1857107 0.1514213 0.1499492 0.1575127 0.1580203 0.1651269
Based on our test, we find that there are some radiologists more clinically conservative than others in recalling patients. We know the problem that the radiologists do not see the same patients. So we build “out of sample test”. Our model simulates radiologists’ judgment. After training, If the model turns out to be valid in raw data, then it should performs the same in 'out-of-sample test' which is a different set of data. We asked all radiologists to look at all out of samples to see if their recall rate is still the same as that of raw data.
The higher prob recall means the more conservative the radiologist is. 

###Results:

|radiologist13|0.139| 

|radiologist34|0.0872|

|radiologist66|0.191| 

|radiologist89|0.211|     

|radiologist95|0.0998|


We re-runed the result many times, it seems that the radiologist89 is the most conservative and radiologist34 is the most not conservative. 

##Exercise 2.2.2

- The result we get is that the radiologists should be weighing some clinical risk factors, such as breast density classification and menopause status, more heavily than they currently are. The steps and result are as follows
First we build the benchmark, which is model0. The model0 means when the doctors recall a patient, they think that the patient has cancer. If other clinical risk factors are helpful in the judgment of cancer, then the model 1 to model 5 will performs better than the benchmark. 
From the results, we can see that if the radiologist consider history, symptoms and menopause, the error will slightly lower error rate. We know that if we consider the interaction terms, the error will be lower than model0 to model 5, however there are too many possibilities. The result of model 2, model 3 and model 4 are enough to prove the importance of other clinical risk factors.
From the tables(t0-t5) we can get that density also could increase the
p