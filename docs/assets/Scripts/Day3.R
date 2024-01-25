#####
## Exercise class
#####

### Go to the right directory

class<- read.csv("class.csv")

##inspect the data
dim(class)
head(class)
summary(class[,-1])

## Problem the data set does not have column of Gender as a factor
#
class <- as.data.frame(class)
class$Gender <- as.factor(class$Gender)

#inspect the pairs of variables on 2by2plots
pairs(class[,-c(1)])
      
# Investigating Height ~ Age without the attach function
Height2 <- class$Height
Age2<- class$Age 
lm( Height2 ~ Age2)

## with the attach function
attach(class)
lm( Height ~ Age, data=class) 
model <- lm( Height ~ Age, data=class) 
model

summary(model)

##plot the age vs Height and add the fitted line with abline
plot( class$Age, class$Height)
abline(model, col="red", lwd=2)

#change the range of xaxis and yaxis in order to visually see the intersept
plot(class$Age, class$Height, 
      xlim=range(0,class$Age), 
      ylim=range(coef(model)[1], class$Height))
abline(model, col="red", lwd=2)

##Do a summary of the linear model to see the residuals the degrees of freedom and the p-values estimated
summary( lm( Height ~ Age, data = class) )

##
data(anscombe)

##

anscombe
dim(anscombe)
anscombe[1:3, ]
summary(anscombe)
boxplot(anscombe)
par(mfrow=c(2,2),pty="s")
plot(x1,y1)
plot(x2,y2)
plot(x3,y3)
plot(x4,y4)
plot(x2,y2)
plot(x2, y2)
#urve( -5.99+2.78*x+0.02415*x^2, add=TRUE)

plot(x2, y2)
curve(  5.30362+0.02415*x^2, add=TRUE)
summary(lm(y2 ~ (x2 + I(x2^2)) ))

z2 <- x2^2

summary(lm(y2 ~ x2 + z2))

summary(lm(y2 ~ z2))


#### 
## Afternoon script 3rd Day
####

#### 
## Thuesen
####


library(ISwR)
data(thuesen)
?thuesen
thuesen

sv <- thuesen$short.velocity
bg <- thuesen$blood.glucose

summary(thuesen)## we already see a NA
cor(thuesen)## this gives a problem
?cor
round(cor(thuesen,use="complete.obs",method="spearman"),4)

plot(bg, sv)

plot(bg, sv, pch=16, xlab="Blood Glucose", ylab= "Shortening Velocity")
## linear model
th.lm <- lm(sv ~ bg)
summary(th.lm)

abline(lm(sv ~ bg))


## regression line
reg_line <- 1.09781 + 0.02196 * bg
reg_line2 <- coef(th.lm)[1]+coef(th.lm)[2]*bg



### look at residuals
th.resid <- resid(th.lm)

th.resid
th.lm$residuals

bg.1 <- bg[! is.na(sv)] 
plot(bg.1,th.resid,pch=16)
abline(h=0)

qqnorm(th.resid)
qqline(th.resid)
shapiro.test(th.resid)

### here same as the previous plot but in general with several variables you will not have it.
th.fv <- fitted.values(th.lm)
plot(th.fv, th.resid,pch=16)
abline(h=0)

#### calculating the hat

th.hat <- lm.influence(th.lm)
sort(th.hat$hat)

index <- seq(1:length(th.hat$hat))

plot(index,th.hat$hat,xlab="Index",ylab="Hat value", ylim=c(0,0.3)) # ylim sets the range of the y-xis
abline(h=c(2*2/23,3*2/23),lty=c(2,3),col=c("blue","red") ) # h for horizontal lines, here two specified together


#### Identification of influencial points

th.highlev <- identify(index,th.hat$hat)
th.highlev <- c(4,13)
th.hat$hat

thuesen[th.highlev,]
thuesen

### ploting influencial points on the final picture
plot(bg, sv, pch=16, xlab="Blood Glucose", ylab= "Shortening Velocity")
abline(lm(sv~bg))
points(bg[th])
points(bg[th.highlev],sv[th.highlev],pch=16,col="blue",cex=2)

pd <- predict.lm(th.lm,interval="confidence")
lines(sort(bg.1),as.data.frame(pd)$lwr[order(bg.1)],col="grey")
lines(sort(bg.1),as.data.frame(pd)$upr[order(bg.1)],col="grey")
pd <- predict.lm(th.lm,interval="confidence",level=0.99)
lines(sort(bg.1),as.data.frame(pd)$lwr[order(bg.1)],col="pink")
lines(sort(bg.1),as.data.frame(pd)$upr[order(bg.1)],col="pink")

names(as.data.frame(pd))
#### 
## ESR1 expression
####

### go in the directory where you have the data
#setwd("/Users/Rachel/Downloads/2020/IS20/")
##open it and look at it 
clin <- read.csv("clindata.csv")
expr <- read.csv("expression-esr1.csv")
head(clin)
summary(clin)
clin$er <- as.factor(clin$er)
clin$treatment  <- as.factor(clin$treatment )
rownames(clin)<-clin[,1]
summary(clin)
head(expr)
dim(expr)
#rownames(expr)<- expr[,1]
##check all the correlation (Pearson) and see which one correspond
cor(expr)
rownames(expr) == clin$sample
##for loop to see all the correlations with ER status
for(i in 1:9){
  print(cor(expr[,i],as.numeric(clin[,"er"]),method="spearman"))
}
### put them in a variable
s <- c()
for(i in 1:9){
  s[i] <-cor(expr[,i],as.numeric(clin[rownames(expr),"er"]),method="spearman")
}
head(clin)

### do some boxplots
plot(clin$er,expr[,1])

pat0 <- expr[clin$er==0,1]
pat1 <- expr[clin$er==1,1]
shapiro.test(pat0)
shapiro.test(pat1)

t.test(pat0,pat1)
