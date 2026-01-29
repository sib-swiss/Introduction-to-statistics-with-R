#-----------------
#-----------------
# Introduction to statistics with R
# January 2024
# In Lausanne 
#-----------------
#-----------------

###########################
# Exercises - Day 3       #
# Linear regression       #
# The CLASS dataset       #
###########################


# clear the environment
rm(list = ls())


# load the file class.csv
class <- read.csv("class.csv")


# inspect the data

dim(class)
# [1] 19  5

head(class)
#      Name Gender Age Height Weight
# 1  JOYCE      F  11  151.3  25.25
# 2 THOMAS      M  11  157.5  42.50
# 3  JAMES      M  12  157.3  41.50
# 4   JANE      F  12  159.8  42.25
# 5   JOHN      M  12  159.0  49.75
# 6 LOUISE      F  12  156.3  38.50

summary(class[,-1]) # without the first column (name)
# Gender               Age            Height          Weight     
# Length:19          Min.   :11.00   Min.   :151.3   Min.   :25.25  
# Class :character   1st Qu.:12.00   1st Qu.:158.2   1st Qu.:42.12  
# Mode  :character   Median :13.00   Median :162.8   Median :49.75  
#                    Mean   :13.32   Mean   :162.3   Mean   :50.01  
#                    3rd Qu.:14.50   3rd Qu.:165.9   3rd Qu.:56.12  
#                    Max.   :16.00   Max.   :172.0   Max.   :75.00


# Problem: the data set does not have column of Gender as a factor
#class <- as.data.frame(class) # NOT NEEDED, IT IS ALREADY A DATA FRAME
class$Gender <- as.factor(class$Gender)

# inspect the pairs of variables on 2by2plots
pairs(class[,-1]) # no need for the c(), only if more than one column to exclude

# Investigating Height ~ Age without the attach function
Height2 <- class$Height # create a vector of heights from the df
Age2<- class$Age # create a vector of ages from the df
lm( Height2 ~ Age2) # fitting the linear model
# Call:
#   lm(formula = Height2 ~ Age2)
# 
# Coefficients:
#   (Intercept)         Age2  
# 125.224        2.787  

# or using the data slot
lm(Height ~ Age, data=class) 
model <- lm( Height ~ Age, data=class) # we can also save the result into a variable
model
# Call:
#   lm(formula = Height ~ Age, data = class)
# 
# Coefficients:
#   (Intercept)          Age  
# 125.224        2.787  


# plot the age vs Height and add the fitted line with abline
plot( class$Age, class$Height)
abline(model, col="red", lwd=2)



# Change the range of x axis and y axis in order to visually see the intersept
plot(class$Age, class$Height, 
     xlim=range(0,class$Age),
     ylim=range(coef(model)[1], class$Height))
abline(model, col="red", lwd=2)





# Do a summary of the linear model to see the residuals the degrees of freedom and the p-values estimated
summary( lm( Height ~ Age, data = class) )
# Call:
#   lm(formula = Height ~ Age, data = class)
# 
# Residuals:
#   Min     1Q Median     3Q    Max 
# -4.957 -1.407 -0.031  1.374  6.130 
# 
# Coefficients:
#   Estimate Std. Error t value Pr(>|t|)    
# (Intercept) 125.2239     6.5217  19.201 5.82e-13 ***
#   Age           2.7871     0.4869   5.724 2.48e-05 ***
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 3.083 on 17 degrees of freedom
# Multiple R-squared:  0.6584,	Adjusted R-squared:  0.6383 
# F-statistic: 32.77 on 1 and 17 DF,  p-value: 2.48e-05



# Five-number summary of the residuals
# Returns Tukey's five number summary (minimum, lower-hinge - first quartile, median, upper-hinge - third quartile, maximum) for the input data. 
fivenum(residuals(model))
# 8          11          17           4           7 
# -4.95669291 -1.40669291 -0.03097113  1.37401575  6.13044619 

# or graphically, using a boxplot
boxplot(residuals(model), horizontal=T)


# RSE: Residual Standard Error
# It is not exactly equal to what the sd command would return
sd(residuals(model)) # using the standardr deviation function
# [1] 2.996486
sqrt(sum(residuals(model)^2)/18) # 19 observations -1 parameter
# [1] 2.996486

# Here, we must divide by the number of degrees of freedom to get the same number
sqrt(sum(residuals(model)^2)/17)
# [1] 3.083359


# R^2 is equal to the square of the correlation coefficient between two variables
summary(model)$r.squared
#[1] 0.6584257
cor(class$Age, class$Height)^2
# [1] 0.6584257


# F test for significance of regression

#################################################################
# Challenge: Investigate the correlation and the relationship   #
# between weight and height using R basic commands              #
#################################################################


# Check the data
summary(class[,c("Weight","Height")])
# Weight          Height     
# Min.   :25.25   Min.   :151.3  
# 1st Qu.:42.12   1st Qu.:158.2  
# Median :49.75   Median :162.8  
# Mean   :50.01   Mean   :162.3  
# 3rd Qu.:56.12   3rd Qu.:165.9  
# Max.   :75.00   Max.   :172.0  

plot(class$Height, class$Weight)

cor(class$Height,class$Weight)

# Create the linear model
model <- lm( Weight ~ Height, data=class) 
model

# Call:
#   lm(formula = Weight ~ Height, data = class)
# 
# Coefficients:
#   (Intercept)       Height  
# -266.46         1.95  


# plot the age vs Height and add the fitted line with abline
plot( class$Height, class$Weight)
abline(model, col="red", lwd=2)


# Change the range of x axis and y axis in order to visually see the intersept
plot(class$Height, class$Weight, 
     xlim=range(0,class$Height), 
     ylim=range(coef(model)[1], class$Weight))
abline(model, col="red", lwd=2)

# Do a summary of the linear model to see the residuals the degrees of freedom and the p-values estimated
summary( model )

# Call:
#   lm(formula = Weight ~ Height, data = class)
# 
# Residuals:
#   Min      1Q  Median      3Q     Max 
# -8.8404 -3.0321  0.2558  4.6423  9.1849 
# 
# Coefficients:
#   Estimate Std. Error t value Pr(>|t|)    
# (Intercept) -266.465     41.910  -6.358 7.14e-06 ***
#   Height         1.950      0.258   7.555 7.89e-07 ***
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 5.613 on 17 degrees of freedom
# Multiple R-squared:  0.7705,	Adjusted R-squared:  0.757 
# F-statistic: 57.08 on 1 and 17 DF,  p-value: 7.887e-07


########################################
# Exercises - Day 3                    #
# Linear and non linear regression     #
# Anscombe data                        #
########################################


# clear the environment
rm(list = ls())



#############################
# Load and inspect the data #
#############################


# Load the data
data(anscombe)

# What is this dataset
help(anscombe)

# Inspect the data
anscombe
#    x1 x2 x3 x4    y1   y2    y3    y4
# 1  10 10 10  8  8.04 9.14  7.46  6.58
# 2   8  8  8  8  6.95 8.14  6.77  5.76
# 3  13 13 13  8  7.58 8.74 12.74  7.71
# 4   9  9  9  8  8.81 8.77  7.11  8.84
# 5  11 11 11  8  8.33 9.26  7.81  8.47
# 6  14 14 14  8  9.96 8.10  8.84  7.04
# 7   6  6  6  8  7.24 6.13  6.08  5.25
# 8   4  4  4 19  4.26 3.10  5.39 12.50
# 9  12 12 12  8 10.84 9.13  8.15  5.56
# 10  7  7  7  8  4.82 7.26  6.42  7.91
# 11  5  5  5  8  5.68 4.74  5.73  6.89

# dimensions of the data frame
dim(anscombe)
#[1] 11  8

# only the first three columns
anscombe[1:3, ]
#   x1 x2 x3 x4   y1   y2    y3   y4
# 1 10 10 10  8 8.04 9.14  7.46 6.58
# 2  8  8  8  8 6.95 8.14  6.77 5.76
# 3 13 13 13  8 7.58 8.74 12.74 7.71

# five numbers summary (minimum, maximum, 1st 2nd and 3rd quartile, the 2nd is the median)
summary(anscombe)
# x1             x2             x3             x4           y1               y2       
# Min.   : 4.0   Min.   : 4.0   Min.   : 4.0   Min.   : 8   Min.   : 4.260   Min.   :3.100  
# 1st Qu.: 6.5   1st Qu.: 6.5   1st Qu.: 6.5   1st Qu.: 8   1st Qu.: 6.315   1st Qu.:6.695  
# Median : 9.0   Median : 9.0   Median : 9.0   Median : 8   Median : 7.580   Median :8.140  
# Mean   : 9.0   Mean   : 9.0   Mean   : 9.0   Mean   : 9   Mean   : 7.501   Mean   :7.501  
# 3rd Qu.:11.5   3rd Qu.:11.5   3rd Qu.:11.5   3rd Qu.: 8   3rd Qu.: 8.570   3rd Qu.:8.950  
# Max.   :14.0   Max.   :14.0   Max.   :14.0   Max.   :19   Max.   :10.840   Max.   :9.260  
# 
# y3              y4        
# Min.   : 5.39   Min.   : 5.250  
# 1st Qu.: 6.25   1st Qu.: 6.170  
# Median : 7.11   Median : 7.040  
# Mean   : 7.50   Mean   : 7.501  
# 3rd Qu.: 7.98   3rd Qu.: 8.190  
# Max.   :12.74   Max.   :12.500 

# graphical visualization
boxplot(anscombe)



#######################################################################################
# Question Q1: What do you notice about the summary statistics?                       
#
# With the exception of x4, the x columns have almost identical numerical summaries, 
# and so have the y columns.
#
#######################################################################################


# attach the data (columns in the dataframe can be used as objects - vectors)
attach(anscombe)



# computing correlations
# Find the correlation coefficient for each of the four sets. 
# for each pair separately
cor(x1,y1)
#[1] 0.8164205

cor(x2,y2)
#[1] 0.8162365

cor(x3,y3)
#1] 0.8162867

cor(x4,y4)
#[1] 0.8165214

# or all at once
round(cor(anscombe) , digits=3)
#        x1     x2     x3     x4     y1     y2     y3     y4
# x1  1.000  1.000  1.000 -0.500  0.816  0.816  0.816 -0.314
# x2  1.000  1.000  1.000 -0.500  0.816  0.816  0.816 -0.314
# x3  1.000  1.000  1.000 -0.500  0.816  0.816  0.816 -0.314
# x4 -0.500 -0.500 -0.500  1.000 -0.529 -0.718 -0.345  0.817
# y1  0.816  0.816  0.816 -0.529  1.000  0.750  0.469 -0.489
# y2  0.816  0.816  0.816 -0.718  0.750  1.000  0.588 -0.478
# y3  0.816  0.816  0.816 -0.345  0.469  0.588  1.000 -0.155
# y4 -0.314 -0.314 -0.314  0.817 -0.489 -0.478 -0.155  1.000

# scatterplots
par(mfrow=c(2,2),pty="s")
plot(x1,y1)
plot(x2,y2)
plot(x3,y3)
plot(x4,y4)


# Linear regressions

plot(x1,y1)
abline(lm(y1 ~ x1))
title("Plot 1")

plot(x2,y2)
abline(lm(y2 ~ x2))
title("Plot 2")

plot(x3,y3)
abline(lm(y3 ~ x3))
title("Plot 3")

plot(x4,y4)
abline(lm(y4 ~ x4))
title("Plot 4")

# Moral of the story: there is only one way to tell what the scatterplot will look like: 
# you have to look at it! Even the results of the statistical estimation of intercept and slope, 
# based on assumed normal distribution of the residuals, can be misleading


#####################################################################################
# Question Q2: Which of the data correspond to which of the four comments?:         
#   A) One single point drives the correlation to a higher value                    
#   B) One single point drives the correlation to a lower value                     
#   C) A case where the straight line seems the appropriate model                   
#   D) The graph departs from a straight line, shows curvature,                     
#      the straight line seems unsuitable in the sense that a better model exists.  
#
# Pairs Description-Plot: A-4, B-3, C-1, D-2
#
# A -4
# the fourth example shows another example when one outlier is enough to produce a high correlation 
# coefficient, even though the relationship between the two variables is not linear.
#
# B-3
# In the third case, the linear relationship is perfect, except for one outlier which exerts enough 
# influence to lower the correlation coefficient from 1 to 0.81. Finally, 
#
# C-1
# The first plot seems to be distributed normally, and corresponds to what one would 
# expect when considering two variables correlated and following the assumption of normality. 
#
# D-2
# The second one is not distributed normally; while an obvious relationship between the two 
# variables can be observed, it is not linear, and the Pearson correlation coefficient is not relevant. 
#
##################################################################################


# What do you expect for the estimation of the slopes? 
# Will the P values and the confidence intervals be comparable? 
# The summary function applied to the object returnd by lm

summary(lm(y1 ~ x1))
summary(lm(y2 ~ x2))
summary(lm(y3 ~ x3))
summary(lm(y4 ~ x4))


#####################################################################
# Question Q3: Can you find a more appropriate model for (x2,y2) ?  
#
#  The graphic resembles that of a quadratic function
#
#####################################################################



z2 <- x2^2 # create a new variable = x^2

summary(lm(y2 ~ x2 + z2 ))
# Call:
#   lm(formula = y2 ~ x2 + z2)
# 
# Residuals:
#   Min         1Q     Median         3Q        Max 
# -0.0013287 -0.0011888 -0.0006294  0.0008741  0.0023776 
# 
# Coefficients:
#   Estimate Std. Error t value Pr(>|t|)    
# (Intercept) -5.9957343  0.0043299   -1385   <2e-16 ***
#   x2           2.7808392  0.0010401    2674   <2e-16 ***
#   z2          -0.1267133  0.0000571   -2219   <2e-16 ***
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 0.001672 on 8 degrees of freedom
# Multiple R-squared:      1,	Adjusted R-squared:      1 
# F-statistic: 7.378e+06 on 2 and 8 DF,  p-value: < 2.2e-16


# plot the curve
plot(x2, y2)
curve( -5.99+2.78*x-0.127*x^2, add=TRUE, col="red")

# alternatively, you can extract the coefficients directly
coefs <- coef( lm(y2 ~ x2 + z2) )
curve( coefs[1] + coefs[2]*x + coefs[3]*x^2, add=TRUE, col="red")



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
