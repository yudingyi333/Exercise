library(tidyverse)

library(mosaic)

library(class)

library(FNN)

library(nnet)

data(brca)

#First question
# how many cancer paitent got a definite diagnosis after they got recalled
n = nrow(brca)

sum(brca$recall != brca$cancer)/n


# We list all the function that we are going to use after
rmse = function(y, yhat) {
  
  sqrt( mean( (y - yhat)^2 ) )
  
}

dev_out = function(ml, y, dataset) {
  
  probhat = predict(ml, newdata=dataset, type='response')
  
  p0 = 1-probhat
  
  phat = data.frame(P0 = p0, p1 = probhat)
  
  rc_pairs = cbind(seq_along(y), y)
  
  -2*sum(log(phat[rc_pairs]))
  
}

glm_error = function(fo, data, Family = binomial, threshold = 0.5, Ntimes = 50){
  
  n = nrow(data)
  
  # performance check
  
  rmse_vals = do(Ntimes)*{
    
    
    # re-split into train and test cases
    
    n_train = round(0.8*n)  # round to nearest integer
    
    n_test = n - n_train
    
    train_cases = sample.int(n, n_train, replace=FALSE)
    
    test_cases = setdiff(1:n, train_cases)
    
    brca_train = data[train_cases,]
    
    brca_test = data[test_cases,]
    
    
    
    # fit to this training set
    
    glm_result = glm(fo, data=brca_train, family=Family)
    
    
    
    # predict on this testing set
    
    phat_test = predict(glm_result, brca_test, type='response')
    
    yhat_test = ifelse(phat_test > threshold, 1, 0)
    
    sum(yhat_test != unlist(brca_test[as.character(fo[[2]])]))/n_test 
    
  }
  
  colMeans(rmse_vals)
  
}

threshold = sum(brca$cancer == 1)/n

# We tried to build a model that could minimize the RMSE  

c(
glm_error(recall~radiologist+age+history+symptoms+menopause+density,data=brca, Ntimes = 50),

glm_error(recall~(radiologist+age+history+symptoms+menopause+density)^2,data=brca,Ntimes = 50),

glm_error(recall~radiologist*(age+history+symptoms+menopause),data=brca, Ntimes = 50),

glm_error(recall~radiologist*(age+history+symptoms+menopause+density),data=brca, Ntimes = 50))


# This is the model that we think have the best performance

logit_recall1 = glm(recall~radiologist+age+history+symptoms+menopause+density, data= brca, family = 'binomial')

coef(logit_recall1)

model=glm(recall~radiologist+age+history+symptoms+menopause+density,data=brca)

summary(model)



n_train = round(0.8*n) 

train_cases = sample.int(n,n_train,replace=FALSE)

brca_train = brca[train_cases,]

brca_sample=data.frame(brca_train)

brca_samplerepeat=brca_sample[rep(1:nrow(brca_sample),each=5),-1]

brca_samplerepeat$radiologist=c("radiologist13","radiologist34","radiologist66","radiologist89","radiologist95")

yhat_recall = predict(model, brca_samplerepeat)

brca_samplerepeat=cbind(brca_samplerepeat,yhat_recall)

brca_predict<-brca_samplerepeat%>%
  
group_by(radiologist)%>%
  
summarise(Prob_recall = mean(yhat_recall))

brca_predict


##Second question

error= do(100)*{
  
  data = brca
  
  n = nrow(data)
  
  n_train = round(0.8*n)  # round to nearest integer
  
  n_test = n - n_train
  
  train_cases = sample.int(n, n_train, replace=FALSE)
  
  test_cases = setdiff(1:n, train_cases)
  
  brca_train = data[train_cases,]
  
  brca_test = data[test_cases,]
  
  
  #benchmark
  
  glm_model0 = glm(cancer~ recall, data = brca_train)
  
  
  glm_model1 = glm(cancer~ recall + age, data = brca_train)
  
  
  glm_model2 = glm(cancer~ recall + history, data = brca_train)
  
  
  glm_model3 = glm(cancer~ recall + symptoms, data = brca_train)
  
  
  glm_model4 = glm(cancer~ recall + menopause, data = brca_train)
  
  
  glm_model5 = glm(cancer~ recall + density, data = brca_train)
  
  
  # this is the error test result of benchmark model0
  
  phat_test0 = predict(glm_model0, brca_test, type='response')

  yhat_test0 = ifelse(phat_test0 >= threshold, 1, 0)
  
  t0 = xtabs(~brca_test$cancer+yhat_test0)

  
  phat_test1 = predict(glm_model1, brca_test, type='response')
  
  yhat_test1 = ifelse(phat_test1 >= threshold, 1, 0)
  
  t1 = xtabs(~brca_test$cancer+yhat_test1)
  
  
  phat_test2 = predict(glm_model2, brca_test, type='response')
  
  yhat_test2 = ifelse(phat_test2 >= threshold, 1, 0)
  
  t2 = xtabs(~brca_test$cancer+yhat_test2)
  
  
  phat_test3 = predict(glm_model3, brca_test, type='response')
  
  yhat_test3 = ifelse(phat_test3 >= threshold, 1, 0)
  
  t3 = xtabs(~brca_test$cancer+yhat_test3)
  
  
  phat_test4 = predict(glm_model4, brca_test, type='response')
  
  yhat_test4 = ifelse(phat_test4 >= threshold, 1, 0)
  
  t4 = xtabs(~brca_test$cancer+yhat_test4)
  
  
  phat_test5 = predict(glm_model5, brca_test, type='response')
  
  yhat_test5 = ifelse(phat_test5 >= threshold, 1, 0)
  
  t5 = xtabs(~brca_test$cancer+yhat_test5)
  
  
  c(
    dev_out(ml = glm_model0,dataset = brca_test,y = brca_test$cancer),
    
    dev_out(ml = glm_model1,dataset = brca_test,y = brca_test$cancer),
    
    dev_out(ml = glm_model2,dataset = brca_test,y = brca_test$cancer),
    
    dev_out(ml = glm_model3,dataset = brca_test,y = brca_test$cancer),
    
    dev_out(ml = glm_model4,dataset = brca_test,y = brca_test$cancer),
    
    dev_out(ml = glm_model5,dataset = brca_test,y = brca_test$cancer))
}


colMeans(error)

t0
t1 
t2 
t3 
t4 
t5 
  

ml1 = multinom(cancer~ recall, data = brca_train,, maxit=1000)

ml2 = multinom(cancer~ recall+history, data = brca_train,, maxit=1000)

ml3 = multinom(cancer~ recall+symptoms, data = brca_train,, maxit=1000)

ml4 = multinom(cancer~ recall+menopause, data = brca_train,, maxit=1000)

ml5 = multinom(cancer~ recall+density, data = brca_train,, maxit=1000)

ml6 = multinom(cancer~ recall+age, data = brca_train,, maxit=1000)


deviance(ml1)

deviance(ml2)

deviance(ml3)

deviance(ml4)

deviance(ml5)  
  
deviance(ml6)   
  
  
  