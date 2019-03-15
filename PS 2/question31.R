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

rmse_vals = do(20)*{
  
  # re-split into train and test cases
  n_train = round(0.8*n)  # round to nearest integer
  n_test = n - n_train
  train_cases = sample.int(n, n_train, replace=FALSE)
  test_cases = setdiff(1:n, train_cases)
  OnlineNews_train = OnlineNews[train_cases,]
  OnlineNews_test = OnlineNews[test_cases,]
  
  
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
              weekday_is_thursday + weekday_is_friday + weekday_is_saturday + title_sentiment_polarity, data=OnlineNews_train)
  
  
  lm_12 = lm(shares ~ n_tokens_title + n_tokens_content + num_hrefs + 
               num_self_hrefs + num_imgs + num_videos + 
               average_token_length + num_keywords + data_channel_is_lifestyle + 
               data_channel_is_entertainment + data_channel_is_bus + 
               + data_channel_is_socmed + data_channel_is_tech + 
               data_channel_is_world + self_reference_avg_sharess + 
               weekday_is_monday + weekday_is_tuesday + weekday_is_wednesday + 
               weekday_is_thursday + weekday_is_friday + weekday_is_saturday + title_sentiment_polarity, data=OnlineNews_train)
  
  ##2 with interactions
  ## the ()^2 says "include all pairwise interactions
  lm_2 = lm(viral ~ (n_tokens_title + n_tokens_content + num_hrefs + 
                       num_self_hrefs + num_imgs + num_videos + 
                       average_token_length + num_keywords + data_channel_is_lifestyle + 
                       data_channel_is_entertainment + data_channel_is_bus + 
                       + data_channel_is_socmed + data_channel_is_tech + 
                       data_channel_is_world + self_reference_avg_sharess + 
                       weekday_is_monday + weekday_is_tuesday + weekday_is_wednesday + 
                       weekday_is_thursday + weekday_is_friday + weekday_is_saturday + title_sentiment_polarity)^2, data=OnlineNews_train)
  
  
  lm_22 = lm(shares ~ (n_tokens_title + n_tokens_content + num_hrefs + 
                         num_self_hrefs + num_imgs + num_videos + 
                         average_token_length + num_keywords + data_channel_is_lifestyle + 
                         data_channel_is_entertainment + data_channel_is_bus + 
                         + data_channel_is_socmed + data_channel_is_tech + 
                         data_channel_is_world + self_reference_avg_sharess + 
                         weekday_is_monday + weekday_is_tuesday + weekday_is_wednesday + 
                         weekday_is_thursday + weekday_is_friday + weekday_is_saturday + title_sentiment_polarity)^2, data=OnlineNews_train)
  
  
  
  
  ##3 polynomial
  lm_3 = lm(viral ~ poly(n_tokens_title, 3) + n_tokens_content + num_hrefs + 
              num_imgs + num_videos + 
              poly(average_token_length, 3) + num_keywords + data_channel_is_lifestyle + 
              data_channel_is_entertainment + data_channel_is_bus + 
              + data_channel_is_socmed + data_channel_is_tech + 
              data_channel_is_world + self_reference_avg_sharess + 
              weekday_is_monday + weekday_is_tuesday + weekday_is_wednesday + 
              weekday_is_thursday + weekday_is_friday + weekday_is_saturday + 
              poly(avg_positive_polarity, 3) + poly(avg_negative_polarity, 3), data=OnlineNews_train)
  
  lm_32 = lm(shares ~ poly(n_tokens_title, 3) + n_tokens_content + num_hrefs + 
               num_imgs + num_videos + 
               poly(average_token_length, 3) + num_keywords + data_channel_is_lifestyle + 
               data_channel_is_entertainment + data_channel_is_bus + 
               + data_channel_is_socmed + data_channel_is_tech + 
               data_channel_is_world + self_reference_avg_sharess + 
               weekday_is_monday + weekday_is_tuesday + weekday_is_wednesday + 
               weekday_is_thursday + weekday_is_friday + weekday_is_saturday + 
               poly(avg_positive_polarity, 3) + poly(avg_negative_polarity, 3), data=OnlineNews_train)
  
  
  
  
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


rmse_vals2 = do(20)*{
  
  # re-split into train and test cases
  n_train2 = round(0.8*n)  # round to nearest integer
  n_test2 = n - n_train2
  train_cases2 = sample.int(n, n_train2, replace=FALSE)
  test_cases2 = setdiff(1:n, train_cases2)
  Onlinenews_train2 = OnlineNews[train_cases2,]
  Onlinenews_test2 = OnlineNews[test_cases2,]
  
  
  ##glm 
  ##4 logistic regression
  glm = glm(viral ~ n_tokens_title + n_tokens_content + num_hrefs + 
              num_self_hrefs + num_imgs + num_videos + 
              average_token_length + num_keywords + data_channel_is_lifestyle + 
              data_channel_is_entertainment + data_channel_is_bus + 
              + data_channel_is_socmed + data_channel_is_tech + 
              data_channel_is_world + self_reference_avg_sharess + 
              weekday_is_monday + weekday_is_tuesday + weekday_is_wednesday + 
              weekday_is_thursday + weekday_is_friday + weekday_is_saturday+ title_sentiment_polarity, data=Onlinenews_train2,family=binomial)
  ## without dummy
  glm2 = glm(shares ~ n_tokens_title + n_tokens_content + num_hrefs + 
               num_self_hrefs + num_imgs + num_videos + 
               average_token_length + num_keywords + data_channel_is_lifestyle + 
               data_channel_is_entertainment + data_channel_is_bus + 
               + data_channel_is_socmed + data_channel_is_tech + 
               data_channel_is_world + self_reference_avg_sharess + 
               weekday_is_monday + weekday_is_tuesday + weekday_is_wednesday + 
               weekday_is_thursday + weekday_is_friday + weekday_is_saturday+ title_sentiment_polarity, data=Onlinenews_train2,family=binomial)
  
  phat_test1 = predict(glm, Onlinenews_test2, type='response')
  yhat_test1 = ifelse(phat_test1 > threshold, 1, 0)
  sum(yhat_test != unlist(Onlinenews_test2[as.character(glm[[2]])]))/n_test2
  phat_test2 = predict(glm2, Onlinenews_test2, type='response')
  yhat_test2 = ifelse(phat_test2 > threshold, 1, 0)
  sum(yhat_test != unlist(Onlinenews_test2[as.character(glm[[2]])]))/n_test2
}
colMeans(rmse_vals2)





##4 multinom 

ml1= multinom(viral~n_tokens_title + n_tokens_content + num_hrefs + 
               num_self_hrefs + num_imgs + num_videos + 
               average_token_length + num_keywords + data_channel_is_lifestyle + 
               data_channel_is_entertainment + data_channel_is_bus + 
               + data_channel_is_socmed + data_channel_is_tech + 
               data_channel_is_world + self_reference_avg_sharess + 
               weekday_is_monday + weekday_is_tuesday + weekday_is_wednesday + 
               weekday_is_thursday + weekday_is_friday + weekday_is_saturday+ title_sentiment_polarity, data=OnlineNews_train)


ml2= multinom(shares~n_tokens_title + n_tokens_content + num_hrefs + 
                num_self_hrefs + num_imgs + num_videos + 
                average_token_length + num_keywords + data_channel_is_lifestyle + 
                data_channel_is_entertainment + data_channel_is_bus + 
                + data_channel_is_socmed + data_channel_is_tech + 
                data_channel_is_world + self_reference_avg_sharess + 
                weekday_is_monday + weekday_is_tuesday + weekday_is_wednesday + 
                weekday_is_thursday + weekday_is_friday + weekday_is_saturday+ title_sentiment_polarity, data=OnlineNews_train)

deviance(ml1)
deviance(ml2)