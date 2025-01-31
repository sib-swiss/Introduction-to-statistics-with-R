#-----------------
#-----------------
# Introduction to statistics with R
# 2025
# In Lausanne 
#-----------------
#-----------------

weight <- c(65,72,55,91,95,72) #this is the weight of our classroom people
height <- c(1.73, 1.80, 1.62, 1.90, 1.78, 1.93)
bmi <- weight / height^2
bmi # Type this in R to see the computed values

#-----------------
#-----------------
# 1st exercise
#-----------------

library(ISwR)
?hellung
data(hellung) 

summary(hellung)

glucose <- hellung$glucose
mean(hellung$glucose)
sd(hellung$glucose)
mean(hellung$conc)
sd(hellung$conc)
mean(hellung$diameter)
sd(hellung$diameter)

means.hellung <- c()
for (i in 1:3){
  means.hellung <- c(means.hellung, mean(hellung[,i]))
  print(means.hellung)
}
means.hellung

stdev.hellung <- c()
for (i in 1:3){
  stdev.hellung <- c(stdev.hellung, sd(hellung[,i]))
}
stdev.hellung

par(mfrow=c(2,2)) # for viewing multiple plots (2 rows x 2 columns = 4 plots)
hist(hellung$conc, main="Hellung data", xlab="concentration", ylab="freq")
hist(hellung$diameter, col="red")
hist(hellung$glucose)
hist(hellung$conc, breaks=20)

par(mfrow=c(1,2)) # for viewing multiple plots
boxplot( conc ~ glucose,data=hellung)
boxplot(diameter ~ glucose, data=hellung)
boxplot(hellung$conc ~ hellung$glucose)
boxplot(hellung$diameter ~ hellung$glucose)


cor(hellung$conc, hellung$diameter)
plot(diameter ~ conc, data=hellung) 
cor(log(hellung$conc), hellung$diameter)
plot(diameter ~ log(conc), data=hellung) 

# a fancy plot with ggplot :)
library(ggplot2)
ggplot(hellung, aes(x=log(conc), y=diameter,col=glucose)) + geom_point() 

hellung$glucose <- factor(hellung$glucose)

#-----------------
#-----------------
# 2nd exercise
#-----------------
data <- read.csv("~/Desktop/Introduction-to-statistics-with-R/docs/assets/exercises/data.csv", header=FALSE)

setwd("/Users/rachelmarcone/Desktop/Introduction-to-statistics-with-R/docs/assets/exercises/")
data <- read.csv("data.csv") 


data
summary(data)
sd(data[,1]); sd(data[,2]); sd(data[,3])
attach(data)
datatoplot <- data[,1]
#pdf("datanumber1.pdf")
## Plot 4 rows of graphs on one plot
par(mfrow=c(4,1))

# 1st plot: individual points on the x-axis; random noise on the
#           y-axis so that points are not too much superimposed
plot(datatoplot, runif( length(datatoplot), -1, 1), xlim=range(datatoplot))

# 2nd plot: histogram, with the density line superimposed
hist(datatoplot, xlim=range(datatoplot), breaks=20)
lines(density(datatoplot))

# 3rd plot: average +/- Sd
plot(mean(datatoplot), 0, xlim=range(datatoplot), main="Mean and standard deviation of a")
arrows(mean(datatoplot)-sd(datatoplot), 0, mean(datatoplot)+sd(datatoplot), 0, angle=90, code=3)

# 4th plot: boxplot
boxplot(datatoplot, horizontal=TRUE, ylim=range(datatoplot))
#dev.off()

## now I am looking at the second column

datatoplot <- data[,2]
#pdf("datanumber2.pdf")
## Plot 4 rows of graphs on one plot
par(mfrow=c(4,1))

# 1st plot: individual points on the x-axis; random noise on the
#           y-axis so that points are not too much superimposed
plot(datatoplot, runif( length(datatoplot), -1, 1), xlim=range(datatoplot))

# 2nd plot: histogram, with the density line superimposed
hist(datatoplot, xlim=range(datatoplot), breaks=20)
lines(density(datatoplot))

# 3rd plot: average +/- Sd
plot(mean(datatoplot), 0, xlim=range(datatoplot), main="Mean and standard deviation of a")
arrows(mean(datatoplot)-sd(datatoplot), 0, mean(datatoplot)+sd(datatoplot), 0, angle=90, code=3)

# 4th plot: boxplot
boxplot(datatoplot, horizontal=TRUE, ylim=range(datatoplot))
#dev.off()

## now I am looking at the third column

datatoplot <- data[,3]
#pdf("datanumber3.pdf")
## Plot 4 rows of graphs on one plot
par(mfrow=c(4,1))

# 1st plot: individual points on the x-axis; random noise on the
#           y-axis so that points are not too much superimposed
plot(datatoplot, runif( length(datatoplot), -1, 1), xlim=range(datatoplot))

# 2nd plot: histogram, with the density line superimposed
hist(datatoplot, xlim=range(datatoplot), breaks=20)
lines(density(datatoplot))

# 3rd plot: average +/- Sd
plot(mean(datatoplot), 0, xlim=range(datatoplot), main="Mean and standard deviation of a")
arrows(mean(datatoplot)-sd(datatoplot), 0, mean(datatoplot)+sd(datatoplot), 0, angle=90, code=3)

# 4th plot: boxplot
boxplot(datatoplot, horizontal=TRUE, ylim=range(datatoplot))
#dev.off()


x <- rnorm(10000,mean=0, sd=1)
hist(x)
t.test(x,mu=0)$p.value


s <- rep(0,100) # this is an empty vector with 10 entries
for(i in 1:100){ # this is a loop, called a "for" loop, it will repeat 
  # everything in parenthesis 10 times changing the variable
  # i from 1 to 10 at each iteration
  x <- rnorm(10,mean=10, sd=1)
  s[i] <- t.test(x,mu=10)$p.value # does a t.test then takes the p.value obtained and
  # puts it into the i-th entry of s
  
}

s_adj <- p.adjust(s)

## Last exercise


student <- read.table("students.csv",header=TRUE,sep=",")
student[,8]<- as.numeric(gsub(",",".",student[,8]))
student[,1]<- as.factor(student[,1])
student[,5]<- as.factor(student[,5])
student[,6]<- as.factor(student[,6])
student[student[,"leftrighthanded"] =="D","leftrighthanded"] <- "R"
student[student[,"leftrighthanded"] =="G","leftrighthanded"] <- "L"

student[student[,"smoker"] =="NS ","smoker"] <- "NS"
student[student[,"smoker"] =="nS","smoker"] <- "NS"
student$smoker <- factor(student$smoker,levels=unique(student$smoker))
student$leftrighthanded <- as.factor(as.character(student$leftrighthanded))
summary(student)

student[student[,"height"] ==1.77,"height"] <-177
student[,"siblings"]<- as.factor(student[,"siblings"])

plot(student$height,student$weight,col=student$gender)
boxplot(height~gender,data=student)
boxplot(weight~gender,data=student)
hist(student$weight)
pairs(student) ## two by two plots of data
