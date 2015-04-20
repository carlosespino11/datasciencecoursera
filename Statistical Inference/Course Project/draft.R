lambda = 0.2

set.seed(15)
means = unlist(lapply(1:1000, function(x){ 
  mean(rexp(40, lambda))
}))


sample_mean = mean(means)
theo_mean = (1/lambda)

sample_mean
theo_mean

sample_var = var(means)
theo_var = (1/lambda^2)/40

theo_var
sample_var


ggplot(data.frame(means= (means-sample_mean)/sqrt(sample_var))) +   
  stat_qq(aes(sample = means)) + 
  geom_abline(color = "blue") +
  xlab("Theoretical quantiles") + 
  ylab("Sample quantiles")
ggplot(data.frame(means= (means-sample_mean)/sqrt(sample_var))) + 
  geom_histogram(aes(x = means, y = ..density..), fill = "red", alpha = .5, color = "black", binwidth = .4) +
  stat_function(fun = dnorm, size = 1) 

compare_mean = rbind(data.frame(measure =means , type = "means"), data.frame(measure= rexp(1000,lambda), type ="random exponentials"))
ggplot(compare_mean) + geom_boxplot(aes(y = measure, x = type , fill= type), color = "black", alpha=.4) +
  xlab("densities")

ggplot(compare_mean) + geom_histogram(aes(x = measure, y =..density.., fill= type), color = "black", alpha=.4) +
  facet_grid(type ~., scales = "free_y")+ theme(legend.position = "top") + scale_fill_discrete("")
  xlab("") 
