#####################################
# Introduction to Statistics with R #
# Multiple Regression               #
# Joao Lourenco                     #
# 29.01.2025                        #
#####################################

# clear the environment
rm(list = ls())

# clear the command line
cat("\014")


###########################################
# multiple regression with two variables  #
###########################################

# load the class dataset
class <- read.csv("/Users/rachelmarcone/Desktop/Introduction-to-statistics-with-R/docs/assets/exercises/class.csv")

# fit model with two independent variables
model <- lm(Height ~ Age + Weight, data = class)
summary(model)

# The order doesn't matter
summary(lm(Height ~ Weight + Age  , data = class))

# compare to the models where each variable is considered separately
summary(lm(Height ~Age  , data = class))
summary(lm(Height ~ Weight, data = class))


# example of a case in which the adjusted R2 decreseases when the number of variables increases

y <- rnorm(10) # create a random vector
X <- matrix(rnorm(100),ncol = 10, nrow = 10) #create a random matrix

# r-squared
plot(sapply( 1:10, function(i) summary(lm(y ~ X[,1:i]))$r.squared),type = "l")

# adjusted r-squared
plot(sapply( 1:10, function(i) summary(lm(y ~ X[,1:i]))$adj.r.squared),type = "l")

# last model
summary(lm(y ~ X))

#########################################################
# Categorical variables, dummy variables and contrasts  #
#########################################################

## categorical variable

# convert Gender to a factor
class$Gender <- as.factor(class$Gender)
class$Gender
as.numeric(class$Gender)

summary(lm(Height ~  Age + Gender, data = class ))


# difference in means between males and females
#?tapply
#?diff
means <- tapply(class$Height, class$Gender, mean)
diff(means)

# where does this difference come from
summary(lm(Height ~  Gender, data = class ))
summary(lm(Height ~  Age + Gender, data = class ))


## interaction between Age and Gender
summary(lm(Height ~ Age + Gender + Age:Gender, data = class))
#summary(lm(Height ~ Age*Gender, data = class))


## What if males were the baseline

# create a new categorical variable
class$Gender1 <- relevel(class$Gender, ref="M") 

# fit the model
summary(lm(Height ~ Age + Gender1, data = class))



###########################
# Diagnostic tools        #
###########################

attach(class)


## examination of residuals
model <- lm(Height ~ Age , data = class)
plot(class$Age, residuals(model)) # works only for simple regression
plot(fitted(model), residuals(model)) # works only for simple regression

# hat values
?lm.influence
hat <- lm.influence(model)
plot(hat$hat, ylim = range(0,hat$hat, 3*2/19))
abline(h=c(2,3)*2/19, lty=2, col=c("blue","red"))


# Predictions with confidence intervals
?predict.lm
preds <- predict(model, interval = "prediction")
attach(class)
# Plot the data
plot(Age, Height)

# Add regression line
abline(model, col = "red", lwd = 2)




# Generate new predictor values for smooth plotting
new_x = seq(min(Age),max(Age),length.out = 100)

#  get the prediction interval
prediction_interval <- predict(model, 
                                newdata = data.frame(Age = new_x),
                                interval = "prediction")

# get the confidence intervals for a given level of confidence
confidence_interval <- predict(model,
                               newdata = data.frame(Age = new_x),
                               interval = "confidence")

# Create the scatterplot
plot(Age, Height, ylim = range(prediction_interval[, "lwr"],prediction_interval[, "upr"]))

# Add regression line
abline(model, col = "red", lwd = 2)


# Add bands
lines(new_x, confidence_interval[, "lwr"], lty = "dashed")
lines(new_x, confidence_interval[, "upr"], lty = "dashed")
lines(new_x, prediction_interval[, "lwr"], lty = "dotted")
lines(new_x, prediction_interval[, "upr"], lty = "dotted")
