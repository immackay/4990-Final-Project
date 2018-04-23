x <- read.csv("kmeans_sse.csv", sep=" ", header=FALSE)
x <- unlist(x, use.names=FALSE)
hist(x, main="Frequency of Sum of Mean Squared\n Errors in 100 k means trials", xlab="Sum of Mean Squared Errors")
mu <- mean(x)
variance <- var(x)
print(mu)
print(variance)
print(IQR(x))

x <- read.csv("kpp_sse.csv", sep=" ", header=FALSE)
x <- unlist(x, use.names=FALSE)
hist(x, main="Frequency of Sum of Mean Squared\n Errors in 100 k++ trials", xlab="Sum of Mean Squared Errors")
mu <- mean(x)
variance <- var(x)
print(mu)
print(variance) 
print(IQR(x))



