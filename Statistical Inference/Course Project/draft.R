library(ggplot2)


###### PART 1 ########
lambda = 0.2
set.seed(15)
## Generate sample of means
means = unlist(lapply(1:1000, function(x){mean(rexp(40, lambda))}))

## Calculate sample and theoretical mean of the simulations
sample_mean = mean(means)
theo_mean = (1/lambda)

sample_mean
theo_mean

## Calculate sample and theoretical variance of the simulations
sample_var = var(means)
theo_var = (1/lambda^2)/40

theo_var
sample_var

## Illustrate normality of the means
ggplot(data.frame(means= (means-sample_mean)/sqrt(sample_var))) +   
  stat_qq(aes(sample = means)) + 
  geom_abline(color = "blue") +
  xlab("Theoretical quantiles") + 
  ylab("Sample quantiles")

ggplot(data.frame(means= means)) + 
  geom_histogram(aes(x = means, y = ..density..), fill = "red", alpha = .5, color = "black", binwidth = .4) +
  stat_function(fun = function(x){dnorm(x, sample_mean, sqrt(sample_var))}, size = 1)


## Generate sample of exponentials
compare_mean = rbind(data.frame(measure =means , type = "means"), data.frame(measure= rexp(1000,lambda), type ="random exponentials"))

## Comapre distribution of means vs exponentials
ggplot(compare_mean) + geom_boxplot(aes(y = measure, x = type , fill= type), color = "black", alpha=.7) +
  xlab("densities")

ggplot(compare_mean) + geom_histogram(aes(x = measure, y =..density.., fill= type), color = "black", alpha=.7) +
  facet_grid(type ~., scales = "free_y")+ theme(legend.position = "top") + scale_fill_discrete("")



###### PART 2 ######
library(dplyr)
library(GGally)

data(ToothGrowth)
ToothGrowth$dose = factor(ToothGrowth$dose)
summary(ToothGrowth)
len_by_supp_dose = ToothGrowth %>% group_by(dose, supp) %>% summarize(mean(len))
ggplot(ToothGrowth) + geom_boxplot(aes(x = supp, y = len, fill = supp))
ggplot(ToothGrowth) + geom_boxplot(aes(x = dose, y = len, fill = dose))

ggplot(ToothGrowth) + geom_boxplot(aes(x = dose, y = len, fill =supp)) 
ggpairs(ToothGrowth)


t.test(len~supp, ToothGrowth)
t.test(filter(ToothGrowth, dose==0.5)$len, filter(ToothGrowth, dose==1)$len)
t.test(filter(ToothGrowth, dose==0.5)$len, filter(ToothGrowth, dose==2)$len)
t.test(filter(ToothGrowth, dose==1)$len, filter(ToothGrowth, dose==2)$len)




