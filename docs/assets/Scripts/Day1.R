#-----------------
#-----------------
# Introduction to statistics with R
# 6-9 February 2023
# Streamed from Lausanne 
#-----------------
#-----------------



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
}
means.hellung

stdev.hellung <- c()
for (i in 1:3){
  stdev.hellung <- c(stdev.hellung, sd(hellung[,i]))
}
stdev.hellung

par(mfrow=c(2,2)) # for viewing multiple plots (2 rows x 2 columns = 4 plots)
hist(hellung$conc, main="a title", xlab="concentration", ylab="freq")
hist(hellung$diameter, col="red")
hist(hellung$glucose)
hist(hellung$conc, breaks=20)

par(mfrow=c(1,2)) # for viewing multiple plots
boxplot(conc ~ glucose, data=hellung)
boxplot(diameter ~ glucose, data=hellung)
boxplot(hellung$conc ~ hellung$glucose)
boxplot(hellung$diameter ~ hellung$glucose)

cor(hellung$conc, hellung$diameter)
plot(diameter ~ conc, data=hellung) 
cor(log(hellung$conc), hellung$diameter)
plot(diameter ~ log(conc), data=hellung) 

# a fancy plot with ggplot :)
library(ggplot2)
ggplot(hellung, aes(x=log(conc), y=diameter)) + geom_point()



#-----------------
#-----------------
# 2nd exercise
#-----------------

setwd("/Users/Rachel/Desktop/Introduction-to-statistics-with-R/docs/assets/exercises/")
data <- read.csv("data.csv") 

data
summary(data)
sd(data[,1]); sd(data[,2]); sd(data[,3])

datatoplot <- data[,1]

## Plot 4 rows of graphs on one plot
par(mfrow=c(4,1))
dev.off()
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
plot(student$height,student$weight,col=student$gender)
boxplot(height~gender,data=student)
boxplot(weight~gender,data=student)
hist(student$weight)

