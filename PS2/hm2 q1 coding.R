library(tidyverse)
library(mosaic)
data(SaratogaHouses)
summary(SaratogaHouses)

lm_medium = lm(price ~ lotSize + age + livingArea + pctCollege + bedrooms + 
                 fireplaces + bathrooms + rooms + heating + fuel + centralAir, data=SaratogaHouses)

coef(lm_medium)

# All interactions
# the ()^2 says "include all pairwise interactions"
lm_big = lm(price ~ (. - sewer - waterfront - landValue - newConstruction)^2, data=SaratogaHouses)

lm_improve=lm(price ~ bedrooms + bathrooms +lotSize+newConstruction+heating+ rooms
              +fireplaces+livingArea+age+waterfront+landValue+centralAir+rooms*heating
              +landValue*lotSize+rooms*bathrooms, data=SaratogaHouses)
coef(lm_improve)

# Compare out-of-sample predictive performance
#do200times
# Split into training and testing sets
rmse_vals = do(200)*{
  n = nrow(SaratogaHouses)
  n_train = round(0.8*n)  # round to nearest integer
  n_test = n - n_train
  train_cases = sample.int(n, n_train, replace=FALSE)
  test_cases = setdiff(1:n, train_cases)
  saratoga_train = SaratogaHouses[train_cases,]
  saratoga_test = SaratogaHouses[test_cases,]
  
  # Fit to the training data
  lm1 = lm(price ~ . - sewer - waterfront - landValue - newConstruction, data=saratoga_train)
  lm2 = lm(price ~ (. - sewer - waterfront - landValue - newConstruction)^2, data=saratoga_train)
  #our improved model
  #Model0 #standard model I found
  lmimprove=lm(price ~ bedrooms+newConstruction+heating
               +fireplaces+livingArea+age+waterfront+centralAir+rooms*heating
               +landValue*lotSize+rooms*bathrooms, data=saratoga_train)
  #Model1#Model0 withouout rooms*bathrooms 
  lmimprove1=lm(price ~ bedrooms+newConstruction+heating+rooms+landValue+lotSize+bathrooms
                +fireplaces+livingArea+age+waterfront+centralAir+rooms*heating
                +landValue*lotSize, data=saratoga_train)
  #Model2#Model0 withouout age
  lmimprove2=lm(price ~ bedrooms+newConstruction+heating+rooms+landValue+lotSize+bathrooms
                +fireplaces+livingArea+waterfront+centralAir+rooms*heating
                +landValue*lotSize+rooms*bathrooms, data=saratoga_train)
  #Model3#Model0 without bedrooms
  lmimprove3=lm(price ~ newConstruction+heating+rooms+landValue+lotSize+bathrooms
                +fireplaces+livingArea+age+waterfront+centralAir+rooms*heating
                +landValue*lotSize+rooms*bathrooms, data=saratoga_train)
  #Model4#Model 0 without centralAir
  lmimprove4=lm(price ~ bedrooms+newConstruction+heating+rooms+landValue+lotSize+bathrooms
                +fireplaces+livingArea+age+waterfront+rooms*heating
                +landValue*lotSize+rooms*bathrooms, data=saratoga_train)
  # Predictions out of sample
  
  yhat_meidum = predict(lm1, saratoga_test)
  yhat_big = predict(lm2, saratoga_test)
  yhat_improve = predict(lmimprove, saratoga_test)
  yhat_improve1 = predict(lmimprove1, saratoga_test)
  yhat_improve2 = predict(lmimprove2, saratoga_test)
  yhat_improve3 = predict(lmimprove3, saratoga_test)
  yhat_improve4 = predict(lmimprove4, saratoga_test)
  
  rmse = function(y, yhat) {
    sqrt( mean( (y - yhat)^2 ) )
  }
  # predict on this testing set
  c(rmse(saratoga_test$price, yhat_meidum),
    rmse(saratoga_test$price, yhat_big),
    rmse(saratoga_test$price, yhat_improve),
    rmse(saratoga_test$price, yhat_improve1),
    rmse(saratoga_test$price, yhat_improve2),
    rmse(saratoga_test$price, yhat_improve3),
    rmse(saratoga_test$price, yhat_improve4))
}
rmse_vals
options(scipen=200)
colMeans(rmse_vals)

coef(lmimprove)
#KNN MODEL 
# construct the training and test-set feature matrices
# note the "-1": this says "don't add a column of ones for the intercept"
#price ~ bedrooms+newConstruction+heating+fireplaces+livingArea+age+waterfront+centralAir+rooms*heating+landValue*lotSize+rooms*bathrooms

Xtrain = model.matrix(~ . - (price + pctCollege + fuel +sewer + fuel) - 1, data=saratoga_train)
Xtest = model.matrix(~ . - (price + pctCollege + fuel +sewer + fuel) - 1, data=saratoga_test)

# training and testing set responses
ytrain = saratoga_train$price
ytest = saratoga_test$price

# now rescale:
scale_train = apply(Xtrain, 2, sd)  # calculate std dev for each column
Xtilde_train = scale(Xtrain, scale = scale_train)
Xtilde_test = scale(Xtest, scale = scale_train)  # use the training set scales!


head(Xtrain, 2)

head(Xtilde_train, 2) %>% round(3)

library(FNN)

K=10
# fit the model
knn_model = knn.reg(Xtilde_train, Xtilde_test, ytrain, k=K)

# calculate test-set performance
rmse(ytest, knn_model$pred)

library(foreach)

k_grid = seq(1,100,by=1) %>% round %>% unique
rmse_grid = foreach(K = k_grid, .combine='c') %do% {
  knn_model = knn.reg(Xtilde_train, Xtilde_test, ytrain, k=K)
  rmse(ytest, knn_model$pred)
}
k_grid[which.min(rmse_grid)]
rmse_grid[which.min(rmse_grid)]
plot(k_grid, rmse_grid, log='x',type="l",lty=1,lwd=3,col="darkblue",col.axis="darkblue",  col.lab="black",
     main="relationship between RMSE and K",col.main="darkblue",fg="black",las=0,font=2,xlab="K value",ylab="RMSE",col.lab="black")

#print out
k_grid = seq(1,100,by=1)
for(i in k_grid){
  knn_model=knn.reg(Xtilde_train,Xtilde_test,ytrain,k=i)
  rmse_value=rmse(ytest,knn_model$pred)
  print(paste0("rmse is ",rmse_value))
  print(paste0("K is ",i))
}
