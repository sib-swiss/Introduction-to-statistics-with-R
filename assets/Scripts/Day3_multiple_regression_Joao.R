#####################################
# Introduction to Statistics with R #
# Multiple Regression               #
# Joao Lourenco                     #
# 28.01.2026                        #
#####################################

# clear the environment
rm(list = ls())

# clear the command line
cat("\014")


###########################################
# multiple regression with two variables  #
###########################################

# load the class dataset
class <- read.csv("~/Documents/SIB/Teaching/Introduction_to_statistics_with_R_2026/Datasets/class.csv")

# fit model with two independent variables
model <- lm(Height ~ Age + Weight, data = class)
summary(model)

# The order doesn't matter
summary(lm(Height ~ Weight + Age  , data = class))

# compare to the models where each variable is considered separately
summary(lm(Height ~ Age , data = class))
summary(lm(Height ~ Weight, data = class))



#########################
# Overfitting

# example of a case in which the adjusted R2 decreseases when the number of variables increases

y <- rnorm(10) # create a random vector
X <- matrix(rnorm(90),ncol = 9, nrow = 10) #create a random matrix

# r-squared
plot(sapply( 1:9, function(i) summary(lm(y ~ X[,1:i]))$r.squared),type = "l")

# adjusted r-squared
plot(sapply( 1:9, function(i) summary(lm(y ~ X[,1:i]))$adj.r.squared),type = "l")

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

###########################
# Residuals
model <- lm(Height ~ Age , data = class)
plot(Age, residuals(model)) # works only for simple regression
plot(fitted(model), residuals(model)) # works only for simple regression

###############
# hat values

?lm.influence

hat <- lm.influence(model)
plot(hat$hat, ylim = range(0,hat$hat, 3*2/19))
abline(h=c(2,3)*2/19, lty=2, col=c("blue","red"))




########################################
# Predictions with confidence intervals

?predict

# Generate new predictor values for a smooth line
newdat <- data.frame(Age = seq(min(Age), max(Age), length.out = 100))

# # Prediction interval (wide bands: individual prediction)
prediction_interval <- predict(model,
                                newdata = newdat,
                                interval = "prediction")

prediction_interval.upr <- data.frame(Age = newdat, Height = prediction_interval[, "upr"])
prediction_interval.lwr <- data.frame(Age = newdat, Height = prediction_interval[, "lwr"])

# Confidence interval (narrow bands: mean prediction)
confidence_interval <- predict(model,
                               newdata = newdat,
                               interval = "confidence")

confidence_interval.fit <- data.frame(Age = newdat, Height = confidence_interval[, "fit"])
confidence_interval.lwr <- data.frame(Age = newdat, Height = confidence_interval[, "lwr"])
confidence_interval.upr <- data.frame(Age = newdat, Height = confidence_interval[, "upr"])


# Scatterplot, with y-limits wide enough for the bands
plot(Age, Height,
     ylim = range(prediction_interval[, "lwr"],
                  prediction_interval[, "upr"]),
     xlab = "Age", ylab = "Height")

# Regression line
lines(confidence_interval.df, col = "red", lwd = 2)

# Narrow bands (confidence interval for the mean)
lines(confidence_interval.lwr, lty = "dashed", col = "blue")
lines(confidence_interval.upr, lty = "dashed", col = "blue")

# Wide bands (prediction interval for individuals)
lines(prediction_interval.upr, lty = "dotted", col = "darkgray")
lines(prediction_interval.lwr, lty = "dotted", col = "darkgray")


