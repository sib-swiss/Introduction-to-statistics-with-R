#####################################
# Introduction to Statistics with R #
# Correlation and Simple Regression #
# Joao Lourenco                     #
# 29.01.2025                        #
#####################################

# clear the environment
rm(list = ls())

# clear the command line
cat("\014")

##################
# Correlation    #
##################

# example
x <- c(70,60,0,90,20,100,120)
y <- c(6,5,1,8,2,10,10)

# cor function
?cor
cor(x,y)

# cor.test (Test for Association/Correlation Between Paired Samples)
?cor.test
cor.test(x, y)

##################
# Regression     #
##################

# load the class dataset
class <- read.csv("/data_big/Teaching/Introduction_to_statistics_with_R/2025/datasets/class.csv"  )

# descriptive statistics 
dim(class)
head(class)
summary(class)

# Create scatterplot to show the relationship between variables

pairs(class[,-1]) # exclude the "Name"
#Error in pairs.default(class[, -1]) : non-numeric argument to 'pairs'
#the pairs() function in R expects all columns in the input data to be numeric. 

# Alternative 1: exclude the "Gender"
pairs(class[,c(-1,-2)])

# Alternative 2: convert "Gender to a factor" (which we should do, anyway)
class$Gender <- factor(class$Gender, levels = c("F","M"))
pairs(class[,-1])


# fit the linear model with lm
?lm

lm(formula = Height ~ Age, data = class)
# lm(formula = "Height ~ Age", data = class)
# lm(Height ~ Age, data = class)
# lm(Height ~ Age, class)


# if we want to keep the results in an object
model <- lm(formula = Height ~ Age, data = class)
model

# plot the regression line in the scatterplot
plot(class$Age, class$Height)
abline(model, col="red", lwd = 2)

# show the intercept
# attach(class) # columns can be accessed by simply giving their names
plot(class$Age, class$Height, xlim= range(0, Age), ylim = range(coef(model)[1], Height))
abline(model, col="red", lwd = 2)

# get more details from the results
summary(model)


# five-number summary of the residuals
fivenum(residuals(model))

# boxplot with the distribution of the residuals
boxplot(residuals(model), horizontal = TRUE)

# RSE
sd(residuals(model))
sqrt(sum(residuals(model)^2)/18) # here, we are using n-1
sqrt(sum(residuals(model)^2)/17) # here, we are using n-2

# Multiple and adjusted r-squared
summary(model)$r.squared
cor(class$Age, class$Height)^2


