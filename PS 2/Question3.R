library(tidyverse)
library(mosaic)
library(class)
library(FNN)
library(foreach)

OnlineNews=online_news
OnlineNews$viral = ifelse(OnlineNews$shares > 1400, 1, 0)

##set function to run test 

rmse=function(y,yhat) {
  sqrt (mean((y-yhat)^2))
}

rmse_vals = do(5)*{
  
  # split into train and test cases
  n = nrow(OnlineNews)
  n_train = round(0.8*n)  
  n_test = n - n_train
  train_cases = sample.int(n, n_train, replace=FALSE)
  test_cases = setdiff(1:n, train_cases)
  Onlinenews_train = OnlineNews[train_cases,]
  Onlinenews_test = OnlineNews[test_cases,]
  
  
  # fit to this training set 
  ## linear models
  ##1
  lm_1 = lm(viral ~ n_tokens_title + n_tokens_content + num_hrefs + 
              num_self_hrefs + num_imgs + num_videos + 
              average_token_length + num_keywords + data_channel_is_lifestyle + 
              data_channel_is_entertainment + data_channel_is_bus + 
              + data_channel_is_socmed + data_channel_is_tech + 
              data_channel_is_world + self_reference_avg_sharess + 
              weekday_is_monday + weekday_is_tuesday + weekday_is_wednesday + 
              weekday_is_thursday + weekday_is_friday + weekday_is_saturday + title_sentiment_polarity, data=Onlinenews_train)
  
  
  lm_12 = lm(shares ~ n_tokens_title + n_tokens_content + num_hrefs + 
               num_self_hrefs + num_imgs + num_videos + 
               average_token_length + num_keywords + data_channel_is_lifestyle + 
               data_channel_is_entertainment + data_channel_is_bus + 
               + data_channel_is_socmed + data_channel_is_tech + 
               data_channel_is_world + self_reference_avg_sharess + 
               weekday_is_monday + weekday_is_tuesday + weekday_is_wednesday + 
               weekday_is_thursday + weekday_is_friday + weekday_is_saturday + title_sentiment_polarity, data=Onlinenews_train)
  
  ##2 with interactions
  ## the ()^2 says "include all pairwise interactions
  lm_2 = lm(viral ~ (n_tokens_title + n_tokens_content + num_hrefs + 
                       num_self_hrefs + num_imgs + num_videos + 
                       average_token_length + num_keywords + data_channel_is_lifestyle + 
                       data_channel_is_entertainment + data_channel_is_bus + 
                       + data_channel_is_socmed + data_channel_is_tech + 
                       data_channel_is_world + self_reference_avg_sharess + 
                       weekday_is_monday + weekday_is_tuesday + weekday_is_wednesday + 
                       weekday_is_thursday + weekday_is_friday + weekday_is_saturday + title_sentiment_polarity)^2, data=Onlinenews_train)
  
  
  lm_22 = lm(shares ~ (n_tokens_title + n_tokens_content + num_hrefs + 
                         num_self_hrefs + num_imgs + num_videos + 
                         average_token_length + num_keywords + data_channel_is_lifestyle + 
                         data_channel_is_entertainment + data_channel_is_bus + 
                         + data_channel_is_socmed + data_channel_is_tech + 
                         data_channel_is_world + self_reference_avg_sharess + 
                         weekday_is_monday + weekday_is_tuesday + weekday_is_wednesday + 
                         weekday_is_thursday + weekday_is_friday + weekday_is_saturday + title_sentiment_polarity)^2, data=Onlinenews_train)
  
  
  
  
  ##3 polynomial
  lm_3 = lm(viral ~ poly(n_tokens_title, 3) + n_tokens_content + num_hrefs + 
              num_imgs + num_videos + 
              poly(average_token_length, 3) + num_keywords + data_channel_is_lifestyle + 
              data_channel_is_entertainment + data_channel_is_bus + 
              + data_channel_is_socmed + data_channel_is_tech + 
              data_channel_is_world + self_reference_avg_sharess + 
              weekday_is_monday + weekday_is_tuesday + weekday_is_wednesday + 
              weekday_is_thursday + weekday_is_friday + weekday_is_saturday + 
              poly(avg_positive_polarity, 3) + poly(avg_negative_polarity, 3), data=Onlinenews_train)
  
  lm_32 = lm(shares ~ poly(n_tokens_title, 3) + n_tokens_content + num_hrefs + 
               num_imgs + num_videos + 
               poly(average_token_length, 3) + num_keywords + data_channel_is_lifestyle + 
               data_channel_is_entertainment + data_channel_is_bus + 
               + data_channel_is_socmed + data_channel_is_tech + 
               data_channel_is_world + self_reference_avg_sharess + 
               weekday_is_monday + weekday_is_tuesday + weekday_is_wednesday + 
               weekday_is_thursday + weekday_is_friday + weekday_is_saturday + 
               poly(avg_positive_polarity, 3) + poly(avg_negative_polarity, 3), data=Onlinenews_train)
  
  
  
  # predict on this testing set
  yhat_test1 = predict(lm_1, Onlinenews_test)
  yhat_test2 = predict(lm_12, Onlinenews_test)
  yhat_test3 = predict(lm_2, Onlinenews_test)
  yhat_test4 = predict(lm_22, Onlinenews_test)
  yhat_test5 = predict(lm_3, Onlinenews_test)
  yhat_test6 = predict(lm_32, Onlinenews_test)
  
  c(rmse(Onlinenews_test$viral, yhat_test1),
    rmse(Onlinenews_test$viral, yhat_test2),
    rmse(Onlinenews_test$viral, yhat_test3),
    rmse(Onlinenews_test$viral, yhat_test4),
    rmse(Onlinenews_test$viral, yhat_test5),
    rmse(Onlinenews_test$viral, yhat_test6))
}

rmse_vals
colMeans(rmse_vals)

##We can tell that the first model is the better than others 

## compare shares and viral, this is the result of viral 
lm_Model <- lm_1
yhat_train_test = predict(lm_Model, Onlinenews_train)
class_train_test = ifelse(yhat_train_test > 0.5, 1, 0)

confusion_in = table(y = Onlinenews_train$viral, yhat = class_train_test)
confusion_in
sum(diag(confusion_in))/sum(confusion_in)
sum(Onlinenews_test$viral)/count(Onlinenews_test)

# test simple
yhat_test_test = predict(lm_Model, Onlinenews_test)
class_test_test = ifelse(yhat_test_test > 0.5, 1, 0)

confusion_out = table(y = Onlinenews_test$viral, yhat = class_test_test)
confusion_out
sum(diag(confusion_out))/sum(confusion_out)

sum(Onlinenews_train$viral)/count(Onlinenews_train)

## compare shares and viral, this is the result of shares 
lm_Model2 <- lm_12

yhat_train_test2 = predict(lm_Model12, Onlinenews_train)
class_train_test2 = ifelse(yhat_train_test2 > 1400, 1, 0)

confusion_in2= table(y = Onlinenews_train$shares + yhat = class_train_test2)
confusion_in2
sum(diag(confusion_in2))/sum(confusion_in2)
sum(Onlinenews_test$shares)/count(Onlinenews_test)

yhat_test_test2 = predict(lm_Model12, Onlinenews_test)
class_test_test2 = ifelse(yhat_test_test2 > 1400, 1, 0)

confusion_out2 = table(y = Onlinenews_test$shares, yhat = class_test_test2)
confusion_out2
sum(diag(confusion_out2))/sum(confusion_out2)

sum(Onlinenews_train$viral)/count(Onlinenews_train)


rmse_vals2 = do(5)*{
  
  # re-split into train and test cases
  n_train2 = round(0.8*n) 
  n_test2 = n - n_train2
  train_cases2 = sample.int(n, n_train2, replace=FALSE)
  test_cases2 = setdiff(1:n, train_cases2)
  Onlinenews_train2 = OnlineNews[train_cases2,]
  Onlinenews_test2 = OnlineNews[test_cases2,]
  
  # fit to this training set
  
  glm_C_error(viral ~ n_tokens_title + n_tokens_content + num_hrefs + 
                num_self_hrefs + num_imgs + num_videos + 
                average_token_length + num_keywords + data_channel_is_lifestyle + 
                data_channel_is_entertainment + data_channel_is_bus + 
                + data_channel_is_socmed + data_channel_is_tech + 
                data_channel_is_world + self_reference_avg_sharess + 
                weekday_is_monday + weekday_is_tuesday + weekday_is_wednesday + 
                weekday_is_thursday + weekday_is_friday + weekday_is_saturday+ title_sentiment_polarity,Family = binomial,threshold = 0.5,
              data=OnlineNews,Ntimes = 5)  
  glm<- glm_C_error
  
  # predict on this testing set
  phat_test2 = predict(glm, Onlinenews_test2, type='response')
  yhat_test2 = ifelse(phat_test2 > threshold, 1, 0)
  sum(yhat_test2 != unlist(Onlinenews_test2[as.character(glm[[2]])]))/n_test2
}
colMeans(rmse_vals2)