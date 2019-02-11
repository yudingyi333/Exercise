library(tidyverse)

library(FNN)

sclass <- read.csv("~/GitHub/ECO395M/data/sclass.csv")
View(sclass)

s350data<-sclass[which(sclass$trim == 350),]
View(s350data)

ggplot(data = s350data) + 
  
  geom_point(mapping = aes(x = mileage, y = price), color='red') + 
  ylim(0,100000)
  
N = nrow(s350data)

N_train = floor(0.6*N)

N_test = N - N_train

train_ind = sample.int(N, N_train, replace=FALSE)

D_train = s350data[train_ind,]

D_test = s350data[-train_ind,]

D_test = arrange(D_test, mileage)

head(D_test)

X_train = select(D_train, mileage)

y_train = select(D_train, price)

X_test = select(D_test, mileage)

y_test = select(D_test, price)

lm1 = lm(price ~ mileage, data=D_train)

lm2 = lm(price ~ poly(mileage, 2), data=D_train)

knn3 = knn.reg(train = X_train, test = X_test, y = y_train, k=3)

names(knn3)

knn5 = knn.reg(train = X_train, test = X_test, y = y_train, k=5)

names(knn5)

knn10 = knn.reg(train = X_train, test = X_test, y = y_train, k=10)

names(knn10)

knn20 = knn.reg(train = X_train, test = X_test, y = y_train, k=20)

names(knn20)

knn50 = knn.reg(train = X_train, test = X_test, y = y_train, k=50)

names(knn50)

knn100 = knn.reg(train = X_train, test = X_test, y = y_train, k=100)

names(knn100)

rmse = function(y, ypred) {
  
  sqrt(mean(data.matrix((y-ypred)^2)))
  
}

ypred_lm1 = predict(lm1, X_test)

ypred_lm2 = predict(lm2, X_test)

ypred_knn3= knn3$pred


rmse(y_test, ypred_lm1)

rmse(y_test, ypred_lm2)

rmse(y_test, ypred_knn3)

rmse_350K3=rmse(y_test, ypred_knn3)

rmse_350K3

D_test$ypred_lm2 = ypred_lm2

D_test$ypred_knn3 = ypred_knn3



p_test = ggplot(data = D_test) + 
  
  geom_point(mapping = aes(x = mileage, y = price), color='lightgrey') + 
  
  theme_bw(base_size=20) + 
   ylim(0,100000)

p_test



p_test + geom_point(aes(x = mileage, y = ypred_knn3), color='red')

p_test + geom_path(aes(x = mileage, y = ypred_knn3), color='red')

p_test + geom_path(aes(x = mileage, y = ypred_knn3), color='red') + 
  
  geom_path(aes(x = mileage, y = ypred_lm2), color='blue')



ypred_lm1 = predict(lm1, X_test)

ypred_lm2 = predict(lm2, X_test)

ypred_knn5= knn5$pred


rmse(y_test, ypred_lm1)

rmse(y_test, ypred_lm2)

rmse(y_test, ypred_knn5)

rmse_350K5=rmse(y_test, ypred_knn5)

rmse_350K5

D_test$ypred_lm2 = ypred_lm2

D_test$ypred_knn5 = ypred_knn5



p_test = ggplot(data = D_test) + 
  
  geom_point(mapping = aes(x = mileage, y = price), color='lightgrey') + 
  
  theme_bw(base_size=18) + 
  
  ylim(0, 100000)

p_test



p_test + geom_point(aes(x = mileage, y = ypred_knn5), color='red')

p_test + geom_path(aes(x = mileage, y = ypred_knn5), color='red')

p_test + geom_path(aes(x = mileage, y = ypred_knn5), color='red') + 
  
  geom_path(aes(x = mileage, y = ypred_lm2), color='blue')


ypred_lm1 = predict(lm1, X_test)

ypred_lm2 = predict(lm2, X_test)

ypred_knn10= knn10$pred


rmse(y_test, ypred_lm1)

rmse(y_test, ypred_lm2)

rmse(y_test, ypred_knn10)

rmse_350K10=rmse(y_test, ypred_knn10)

rmse_350K10

D_test$ypred_lm2 = ypred_lm2

D_test$ypred_knn10 = ypred_knn10



p_test = ggplot(data = D_test) + 
  
  geom_point(mapping = aes(x = mileage, y = price), color='lightgrey') + 
  
  theme_bw(base_size=18) + 
  
  ylim(0, 100000)

p_test



p_test + geom_point(aes(x = mileage, y = ypred_knn10), color='red')

p_test + geom_path(aes(x = mileage, y = ypred_knn10), color='red')

p_test + geom_path(aes(x = mileage, y = ypred_knn10), color='red') + 
  
  geom_path(aes(x = mileage, y = ypred_lm2), color='blue')
  
ypred_lm1 = predict(lm1, X_test)

ypred_lm2 = predict(lm2, X_test)

ypred_knn20= knn20$pred


rmse(y_test, ypred_lm1)

rmse(y_test, ypred_lm2)

rmse(y_test, ypred_knn20)

rmse_350K20=rmse(y_test, ypred_knn20)

rmse_350K20

D_test$ypred_lm2 = ypred_lm2

D_test$ypred_knn20 = ypred_knn20



p_test = ggplot(data = D_test) + 
  
  geom_point(mapping = aes(x = mileage, y = price), color='lightgrey') + 
  
  theme_bw(base_size=18) + 
  
  ylim(0, 100000)

p_test



p_test + geom_point(aes(x = mileage, y = ypred_knn20), color='red')

p_test + geom_path(aes(x = mileage, y = ypred_knn20), color='red')

p_test + geom_path(aes(x = mileage, y = ypred_knn20), color='red') + 
  
  geom_path(aes(x = mileage, y = ypred_lm2), color='blue')  
  

ypred_lm1 = predict(lm1, X_test)

ypred_lm2 = predict(lm2, X_test)

ypred_knn50= knn50$pred


rmse(y_test, ypred_lm1)

rmse(y_test, ypred_lm2)

rmse(y_test, ypred_knn50)

rmse_350K50=rmse(y_test, ypred_knn0)5

rmse_350K50

D_test$ypred_lm2 = ypred_lm2

D_test$ypred_knn50 = ypred_knn50



p_test = ggplot(data = D_test) + 
  
  geom_point(mapping = aes(x = mileage, y = price), color='lightgrey') + 
  
  theme_bw(base_size=18) + 
  
  ylim(0, 100000)

p_test



p_test + geom_point(aes(x = mileage, y = ypred_knn50), color='red')

p_test + geom_path(aes(x = mileage, y = ypred_knn50), color='red')

p_test + geom_path(aes(x = mileage, y = ypred_knn50), color='red') + 
  
  geom_path(aes(x = mileage, y = ypred_lm2), color='blue')  
  

ypred_lm1 = predict(lm1, X_test)

ypred_lm2 = predict(lm2, X_test)

ypred_knn100= knn100$pred


rmse(y_test, ypred_lm1)

rmse(y_test, ypred_lm2)

rmse(y_test, ypred_knn100)

rmse_350K100=rmse(y_test, ypred_knn100)

rmse_350K100

D_test$ypred_lm2 = ypred_lm2

D_test$ypred_knn100 = ypred_knn100



p_test = ggplot(data = D_test) + 
  
  geom_point(mapping = aes(x = mileage, y = price), color='lightgrey') + 
  
  theme_bw(base_size=18) + 
  
  ylim(0, 100000)

p_test



p_test + geom_point(aes(x = mileage, y = ypred_knn100), color='red')

p_test + geom_path(aes(x = mileage, y = ypred_knn100), color='red')

p_test + geom_path(aes(x = mileage, y = ypred_knn100), color='red') + 
  
  geom_path(aes(x = mileage, y = ypred_lm2), color='blue')  
  
# the trim of 65 AMG
library(tidyverse)

library(FNN)

sclass <- read.csv("~/GitHub/ECO395M/data/sclass.csv")
View(sclass)

s63data <-sclass[which(sclass$trim == "63 AMG"),]
View(s63data)

ggplot(data = s63data) + 
  
  geom_point(mapping = aes(x = mileage, y = price), color='red') 
   ylim(0,200000)
  
 
N = nrow(s63data)

N_train = floor(0.6*N)

N_test = N - N_train

train_ind = sample.int(N, N_train, replace=FALSE)

D_train = s63data[train_ind,]

D_test = s63data[-train_ind,]

D_test = arrange(D_test, mileage)

head(D_test)

X_train = select(D_train, mileage)

y_train = select(D_train, price)

X_test = select(D_test, mileage)

y_test = select(D_test, price)

lm1 = lm(price ~ mileage, data=D_train)

lm2 = lm(price ~ poly(mileage, 2), data=D_train)

knn3 = knn.reg(train = X_train, test = X_test, y = y_train, k=3)

names(knn3)

knn5 = knn.reg(train = X_train, test = X_test, y = y_train, k=5)

names(knn5)

knn10 = knn.reg(train = X_train, test = X_test, y = y_train, k=10)

names(knn10)

knn20 = knn.reg(train = X_train, test = X_test, y = y_train, k=20)

names(knn20)

knn50 = knn.reg(train = X_train, test = X_test, y = y_train, k=50)

names(knn50)

knn100 = knn.reg(train = X_train, test = X_test, y = y_train, k=100)

names(knn100)

rmse = function(y, ypred) {
  
  sqrt(mean(data.matrix((y-ypred)^2)))
  
}

ypred_lm1 = predict(lm1, X_test)

ypred_lm2 = predict(lm2, X_test)

ypred_knn3= knn3$pred


rmse(y_test, ypred_lm1)

rmse(y_test, ypred_lm2)

rmse(y_test, ypred_knn3)

rmse_63K3=rmse(y_test, ypred_knn3)

rmse_63K3

D_test$ypred_lm2 = ypred_lm2

D_test$ypred_knn3 = ypred_knn3



p_test = ggplot(data = D_test) + 
  
  geom_point(mapping = aes(x = mileage, y = price), color='lightgrey') + 
  
  theme_bw(base_size=20) + 
  
  ylim(0, 200000)

p_test



p_test + geom_point(aes(x = mileage, y = ypred_knn3), color='red')

p_test + geom_path(aes(x = mileage, y = ypred_knn3), color='red')

p_test + geom_path(aes(x = mileage, y = ypred_knn3), color='red') + 
  
  geom_path(aes(x = mileage, y = ypred_lm2), color='blue')



ypred_lm1 = predict(lm1, X_test)

ypred_lm2 = predict(lm2, X_test)

ypred_knn5= knn5$pred


rmse(y_test, ypred_lm1)

rmse(y_test, ypred_lm2)

rmse(y_test, ypred_knn5)

rmse_63K5=rmse(y_test, ypred_knn5)

rmse_63K5

D_test$ypred_lm2 = ypred_lm2

D_test$ypred_knn5 = ypred_knn5



p_test = ggplot(data = D_test) + 
  
  geom_point(mapping = aes(x = mileage, y = price), color='lightgrey') + 
  
  theme_bw(base_size=18) + 
  
  ylim(0, 200000)

p_test



p_test + geom_point(aes(x = mileage, y = ypred_knn5), color='red')

p_test + geom_path(aes(x = mileage, y = ypred_knn5), color='red')

p_test + geom_path(aes(x = mileage, y = ypred_knn5), color='red') + 
  
  geom_path(aes(x = mileage, y = ypred_lm2), color='blue')


ypred_lm1 = predict(lm1, X_test)

ypred_lm2 = predict(lm2, X_test)

ypred_knn10= knn10$pred


rmse(y_test, ypred_lm1)

rmse(y_test, ypred_lm2)

rmse(y_test, ypred_knn10)

rmse_63K10=rmse(y_test, ypred_knn10)

rmse_63K10

D_test$ypred_lm2 = ypred_lm2

D_test$ypred_knn10 = ypred_knn10



p_test = ggplot(data = D_test) + 
  
  geom_point(mapping = aes(x = mileage, y = price), color='lightgrey') + 
  
  theme_bw(base_size=18) + 
  
  ylim(0, 200000)

p_test



p_test + geom_point(aes(x = mileage, y = ypred_knn10), color='red')

p_test + geom_path(aes(x = mileage, y = ypred_knn10), color='red')

p_test + geom_path(aes(x = mileage, y = ypred_knn10), color='red') + 
  
  geom_path(aes(x = mileage, y = ypred_lm2), color='blue')
  
  
ypred_lm1 = predict(lm1, X_test)

ypred_lm2 = predict(lm2, X_test)

ypred_knn20= knn20$pred


rmse(y_test, ypred_lm1)

rmse(y_test, ypred_lm2)

rmse(y_test, ypred_knn20)

rmse_63K20=rmse(y_test, ypred_knn20)

rmse_63K20

D_test$ypred_lm2 = ypred_lm2

D_test$ypred_knn20 = ypred_knn20



p_test = ggplot(data = D_test) + 
  
  geom_point(mapping = aes(x = mileage, y = price), color='lightgrey') + 
  
  theme_bw(base_size=18) + 
  
  ylim(0, 200000)

p_test



p_test + geom_point(aes(x = mileage, y = ypred_knn20), color='red')

p_test + geom_path(aes(x = mileage, y = ypred_knn20), color='red')

p_test + geom_path(aes(x = mileage, y = ypred_knn20), color='red') + 
  
  geom_path(aes(x = mileage, y = ypred_lm2), color='blue')  

ypred_lm1 = predict(lm1, X_test)

ypred_lm2 = predict(lm2, X_test)

ypred_knn50= knn50$pred


rmse(y_test, ypred_lm1)

rmse(y_test, ypred_lm2)

rmse(y_test, ypred_knn50)

rmse_63K50=rmse(y_test, ypred_knn50)

rmse_63K50

D_test$ypred_lm2 = ypred_lm2

D_test$ypred_knn50 = ypred_knn50



p_test = ggplot(data = D_test) + 
  
  geom_point(mapping = aes(x = mileage, y = price), color='lightgrey') + 
  
  theme_bw(base_size=18) + 
  
  ylim(0, 200000)

p_test



p_test + geom_point(aes(x = mileage, y = ypred_knn50), color='red')

p_test + geom_path(aes(x = mileage, y = ypred_knn50), color='red')

p_test + geom_path(aes(x = mileage, y = ypred_knn50), color='red') + 
  
  geom_path(aes(x = mileage, y = ypred_lm2), color='blue')  
  
ypred_lm1 = predict(lm1, X_test)

ypred_lm2 = predict(lm2, X_test)

ypred_knn100= knn100$pred


rmse(y_test, ypred_lm1)

rmse(y_test, ypred_lm2)

rmse(y_test, ypred_knn100)

rmse_63K100=rmse(y_test, ypred_knn100)

rmse_63K100

D_test$ypred_lm2 = ypred_lm2

D_test$ypred_knn100 = ypred_knn100



p_test = ggplot(data = D_test) + 
  
  geom_point(mapping = aes(x = mileage, y = price), color='lightgrey') + 
  
  theme_bw(base_size=18) + 
  
  ylim(0, 200000)

p_test



p_test + geom_point(aes(x = mileage, y = ypred_knn50), color='red')

p_test + geom_path(aes(x = mileage, y = ypred_knn50), color='red')

p_test + geom_path(aes(x = mileage, y = ypred_knn50), color='red') + 
  
  geom_path(aes(x = mileage, y = ypred_lm2), color='blue')  

show(K_RMSE)



