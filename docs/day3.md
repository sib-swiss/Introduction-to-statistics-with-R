# Linear Models

## Learning outcomes of the day

**After having completed this chapter you will be able to:**

- Understand association between variables
- Understand correlation and how this is related to the scatterplot
- Understand simple and multiple regression 


## Material 



Slides of lectures:

[Download slides](assets/pdf/Day3_corr_and_reg.pdf){: .md-button }

The purpose of these exercises is to introduce you to using R for regression modeling. Applications are the estimation of parameter values, the determination of variables that are associated with each other, for example the identification of important biological factors that affect a given "outcome".

## Exercise class

Go to the right directory and load the file class.csv

```r
class<- read.csv("class.csv")
```

inspect the data

```r
dim(class)
head(class)
summary(class[,-1])
```

Problem the data set does not have column of Gender as a factor
```r
class <- as.data.frame(class)
class$Gender <- as.factor(class$Gender)
```

inspect the pairs of variables on 2by2plots
```r
pairs(class[,-c(1)])
```  

Investigating Height ~ Age without the attach function

```r
Height2 <- class$Height
Age2<- class$Age 
lm( Height2 ~ Age2)
```

or using the data slot 

```r
lm( Height ~ Age, data=class) 
model <- lm( Height ~ Age, data=class) 
model
```

plot the age vs Height and add the fitted line with abline
```r
plot( class$Age, class$Height)
abline(model, col="red", lwd=2)
```

change the range of xaxis and yaxis in order to visually see the intersept
```r
plot(class$Age, class$Height, 
      xlim=range(0,class$Age), 
      ylim=range(coef(model)[1], class$Height))
abline(model, col="red", lwd=2)
```

Do a summary of the linear model to see the residuals the degrees of freedom and the p-values estimated
```r
summary( lm( Height ~ Age, data = class) )
```





## Anscombe data
We will start by exploring the classic Anscombe example data set which comes with R. You will soon see why it is 'instructive'. It has been created for the didactic purpose to make people analysing data aware of the fact that while correlation is very convenient and useful, one should know certain limitations. This analysis will demonstrate the importance of examining scatterplots as part of data analysis. First we load the data.

```r
data(anscombe)
```

This is a small dataset, so we can look at the whole data. For large datasets we would just look at the dimension (dim) of the data frame and at a few lines, here [1:3, ] selects the first three rows (and all their columns). Then we get some summary information for the 8 columns (four X,Y pairs), the summary function automatically executes on each column and returns the mean and the "five numbers summary" (minimum, maximum, 1st 2nd and 3rd quartile, the 2nd is the median) Similarly, we make the boxplots, for a graphical visualization.

```r
anscombe
dim(anscombe)
anscombe[1:3, ]
summary(anscombe)
boxplot(anscombe)
```

Question Q1:
What do you notice about the summary statistics?
(Example answer given later)

Now, we "attach" the data, we can then use the variable names used in the data (the names of the columns) directly in the R console window.
```r
attach(anscombe)
```

Computing correlations; Correlations and scatterplots
This data set consists of four pairs of X,Y data: x1 and y1 go together, etc. Find the correlation coefficient for each of the four sets. You can either do this for each pair separately by hand, e.g.

```r
cor(x1,y1)
cor(x2,y2)
cor(x3,y3)
cor(x4,y4)
```

etc., or all at once (cor applies to all pairwise combinations of columns), and the result of cor is given to the function round specifying that we want rounding to 3 decimal places.

```r
round(cor(anscombe) , digits=3)
```

Anything interesting here? Guess what the four scatterplots will look like....

Done guessing? :)

OK, now for the test - go ahead and make the four scatterplots. The first command subdivides the graphical window into 2x2 panels, each with a square plotting region.

```r
par(mfrow=c(2,2),pty="s")
plot(x1,y1)
plot(x2,y2)
plot(x3,y3)
plot(x4,y4)
```

Were you right? Are you surprised??


## Linear regressions
We can add regression lines (abline plots straight lines) and a title to the plots as follows:

```r
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
```

Moral of the story: there is only one way to tell what the scatterplot will look like: you have to look at it! Even the results of the statistical estimation of intercept and slope, based on assumed normal distribution of the residuals, can be misleading.


Question Q2: Which of the data correspond to which of the four comments?:
A) One single point drives the correlation to a higher value
B) One single point drives the correlation to a lower value
C) A case where the straight line seems the appropriate model
D) The graph departs from a straight line, shows curvature, the straight line seems unsuitable in the sense that a better model exists.

What do you expect for the estimation of the slopes? Will the P values and the confidence intervals be comparable? The summary function applied to the object returnd by lm

```r
summary(lm(y1 ~ x1))
summary(lm(y2 ~ x2))
summary(lm(y3 ~ x3))
summary(lm(y4 ~ x4))
```

Here one could compute hat values to see if they can identify points with a high influence on the estimates. But this is planned already for another example.


Question Q3: Can you find a more appropriate model for (x2,y2) ?



??? done "Don't open this before having tried to answer"
    
    Solution to Questions:
    Q1:
    With the exception of x4, the x columns have almost identical numerical summaries, and so have the y columns.
    
    Q2:
    Pairs Description-Plot:
    A-4,
    B-3,
    C-1,
    D-2

    The first plot seems to be distributed normally, and corresponds to what one would expect when considering two variables correlated and following the assumption of normality.
    The second one is not distributed normally; while an obvious relationship between the two variables can be observed, it is not linear, and the Pearson correlation coefficient is not relevant.
    In the third case, the linear relationship is perfect, except for one outlier which exerts enough influence to lower the correlation coefficient from 1 to 0.81.
    Finally, the fourth example shows another example when one outlier is enough to produce a high correlation coefficient, even though the relationship between the two variables is not linear.


    Q3:
    The graph resembles that of a quadratic function. We can use a polynomial including both x and x^2:
    ```r
    z2 <- x2^2
    summary(lm(y2 ~ x2 + z2 ))
    ```
    
    The summary shows that the results of these models fit better to the given points.

    You cannot use the abline function to plot the resulting curve on the plot, as it is not a straight line anymore. However, you can use the curve function, using the three coefficients returned by the summary:

    ```r
    plot(x2, y2)
    curve( -5.99+2.78*x-0.127*x^2, add=TRUE)
    ```

    Alternatively, you can extract the coefficients directly:

    ```r
    coefs <- coef( lm(y2 ~ x2 + z2) )
    curve( coefs[1] + coefs[2]*x + coefs[3]*x^2, add=TRUE)
    ```
    
    
## Thuesen data

Exploring bivariate data
We will use the 'Thuesen' data (L. Thuesen, Diabetologica 1985) contained in the ISwR package. (book "Introductory Statistics with R" by P. Dalgaard).
This data set contains fasting blood glucose concentration (mmol/l, normal range 4-6 mM, except shortly after eating) and mean circumferential shortening velocity of the left ventriculum (percentages of circumference / s, average in the healthy control group was 0.85) measured for 24 (type 1-) diabetic patients. Both variables are numeric, continuous.

Diabetes is considered a proven a risk factor for heart disease. The glucose concentration is increased and the degree of increase is an indicator of how well the person is managing to control it ('metabolic control'), for example by controlling sugar uptake.
The shortening velocity is an indicator of cardiac function. It is increased in diabetic persons and believed to be a risk factor for heart valve function impairment.

A question of interest here is if better metabolic control - as shown by lower (more normal) blood glucose level - is associated with lower (more normal) shortening velocity. The interest was in testing, if there is a relation between these two physiologial quantities. If so, it would suggest that a diabetic person that can keep its glucose low might have less risk of suffering later from heart diseases.

```r
library(ISwR)
data(thuesen)
```

We can start by looking at the data: (You would not want to do this for very large data sets!)

```r
thuesen
```


There are several ways to access the individual variables in thuesen:

1. We could use the $ operator: 'name of the data - $ - name of the variable':

```r
thuesen$short.velocity
thuesen$blood.glucose
```

2. Or we could use the subset operator [ to select individual columns by name or by position:

```r
thuesen[,"blood.glucose"]
thuesen[,2]
```

3. Or we could attach the data and just refer to the variables by their names:

```r
attach(thuesen)
short.velocity
blood.glucose
```

4. This is still a lot of typing! We could assign the variables to new ones with shorter names:

```r
sv <- thuesen$short.velocity
bg <- thuesen$blood.glucose
```

Get some univariate summaries
```r
summary(thuesen)
```

If you are interested in knowing just the means, you can use the function colMeans(thuesen).

You might have noticed that one of the observations was 'NA' (i.e. Not Available). In case you did not notice this, it will be signaled to you if you use certain functions on the data (e.g. mean, sd). You must specify that you want the observations with NA values removed:

```r
colMeans(thuesen, na.rm=TRUE)
```

Look at a bivariate summary
If you type:

```r
cor(thuesen)
```

you will get an error: Error in cor(thuesen) : missing observations in cov/cor. [You will have seen a similar message above when calculating the means.] This is because of the missing value. We can learn which argument to set in cor to decide how to handle the missing values, by using the help facility '?' to ask for the documentation for this function. Here we use the 'use' argument to exclude those observations that have one or more missing values from the calculation of the correlation.

```r
?cor
round( cor(thuesen, use="complete.obs"), 4)
```

Q1) What is the correlation between blood glucose and shortening velocity?
What do you think the scatter plot will look like? Well, we just learned that the only way to know is to look!

Look at the scatter plot
We will be interested in predicting shortening velocity from blood glucose, so our Y variable is sv and X variable is bg:

```r
plot(bg, sv)
```

We can enhance the plot in a number of ways, for example changing the plotting character (pch), adding different axis labels (xlab, ylab):
```r
plot(bg, sv, pch=16, xlab="Blood Glucose", ylab= "Shortening Velocity")
```


Finding the Regression Line
Use lm to estimate the regression line from the data:

```r
th.lm <- lm(sv ~ bg)
```

We can get enough information to write out the regression line from:

```r
th.lm
```

However, we will see a more comprehensive summary using 'summary' :
```r
summary(th.lm)
```

Q2) Using this information, write out a formula for the regression line.
Are any coefficients significant at the 5% level? (could you estimate a 95% confidence interval?) Is sv predicted to be lower when bg is lower, or not?

We can add the regression line to the scatter plot:
```r
abline(lm(sv ~ bg))
```


Exploring Model Fit
To explore the fit of the model, we should examine the residuals more carefully. First, extract the residuals from th.lm using the 'extractor' resid function:

```r
th.resid <- resid(th.lm)
```


Normality
First, extract the residuals from th.lm. We eliminate the observations with missing values for sv (using is.na(sv)) and the 'not' operator '!'. Then we produce QQ plots for the residuals.

```r
bg.1 <- bg[! is.na(sv)]
plot(bg.1,th.resid)
abline(h=0)

qqnorm(th.resid)
qqline(th.resid)
```

Q3) Are any points off the line to indicate departure from a normal distribution?


Constant variance
We check this assumption by plotting the residuals against the fitted values that we obtain by applying the function of this name to the lm object.
```r
th.fv <- fitted.values(th.lm)
plot(th.fv, th.resid)
abline(h=0)
```

Q4) Does the variance of the residuals seem roughly constant across the range of x?
If not, what pattern do you see?


Influential points
Here we compute the 'hat' values (function lm.influence, variable hat in the object returned) We want to compare the hat values to 2p/n or 3p/n, where p is the dimension of the model space (2 here). Values bigger than this may be considered 'influential'. Note the use of '#', this symbol and the rest of the line are ignored by R. It is useful to add small comments to our R code (and to keep this together in a protocol file).

```r
th.hat <- lm.influence(th.lm)
sort(th.hat$hat) # look at the sorted values
index <- seq(1:length(th.hat$hat)) # integers 1 .. number of points
plot(index,th.hat$hat,xlab="Index",ylab="Hat value", ylim=c(0,0.3)) # ylim sets the range of the y-xis
abline(h=c(2*2/23,3*2/23),lty=c(2,3),col=c("blue","red") ) # h for horizontal lines, here two specified together
```

Q5) Do there appear to be any influential points beyond the two horizontal lines?

We can find measurements corresponding to the highest leverage points as follows, using R 'interactive' capabilities, write:

```r
th.highlev <- identify(index,th.hat$hat)
```

and then click on the two highest points in the graphical window (they should be at index 4 and 13). When you are finished, return t the R console window and see which points they are:
```r
th.highlev # should be 4 , 13
```

We can get the glucose and velocity measurements for these points by typing
```r
thuesen[th.highlev,]
```

Let's see where these points are on the original scatter plot. We'll plot these points as large (scale 'cex=2') blue dots:

```r
plot(bg, sv, pch=16, xlab="Blood Glucose", ylab= "Shortening Velocity")
abline(lm(sv ~ bg))
points(bg[th.highlev],sv[th.highlev],pch=16,col="blue",cex=2)
```


Why do you think these points are the most influential?



??? done "Don't open before having tried to answer"

    Q1)
    cor r = 0.4168
    
    Q2) The results indicate high significance for a test of the hypothesis 'intercept = 0' and are just barely significant for a test on the 'coefficient = 0' for bg. An association between bg and sv can be assumed given these data, but the evidence is not overwhelming strong and caution in interpretation is required, especially if there might be doubts as to the correctness of the model assumption being made.
    regression line: sv = 1.09781 + 0.02196 * bg
    predicts on average an increase of sv with bg
    Estimated 95% CI for the coefficients of bg:
    Half-width: 1.96 * 0.01045 = 0.0205 (using the 1.96 from the normal distribution)
    CI: 0.0222 +/- 0.0205 = 0.0017, 0.0427
    Half-width: 2.08 * 0.01045 = 0.0217 (using the t distribution with 21 degrees of freedom)
    CI: 0.0222 +/- 0.0217 = 0.0005, 0.0439
    The slope coefficient is significant in the hypothesis test agains slope=0, but the confidence intervals include values very close to 0. While it is predicted that lower bg is associated with lover sv, how strong this effect is remains relatively unclear.
    
    Q3)
    The five points on the right hand side are fairly far from the straight line and suggest a departure from normal distribution that is important enough to be cautious about drawing definitive conclusions.
    
    Q4)
    The variance seems roughly constant, but a bit higher on the right hand side for the larger fitted values. There can be a bit of concern about model validity.
    
    Q5)
    There are two points with a high influence (leverage)
    They are obove the 2p/n but below the 3p/n line. Again, this is a reason of concern.
    
    In summary, the data present evidence for a linear association of higher ventricular contraction velocity when blood glucose is higher, but with substantial unexplained variation in the model (explained variance by R squared below 0.2, test on coefficient for bg borderline to significance).
    Because the data suggest a relation, but no final conclusion can be strongly supported, the recommendation is to sample more observations. In particular the relation is not well estimated at higher values of bg, and more observations with bg > 13 would be useful.

## Expression data

We are going to use data from a breast cancer study, described in the paper by C. Sotiriou et al, "Gene expression profiling in breast cancer: understanding the molecular basis of histological grade to improve prognosis", J Natl Cancer Inst (2006 Feb 15;98(4):262-72). File expression-esr1.csv contains microarray data for 20 different patients and 9 different probes. The 9 probes interrogate the same gene, ESR1 (Estrogen Receptor). The expression data is log transformed. File clindata.csv contains clinical data about these 20 patients. In particular, the "er" column indicates whether the tumour was identified (using immunohistochemistry) as expression an estrogen receptor. In theory, this information at the protein level should match the information obtained from RNA: an er value of 1 should correspond to a high expression value for gene ESR1, while a value of 0 should correspond to a low value. Answer the following questions (using statistical and graphical arguments).

Do the 9 probes give similar results, or can you identify one or several clusters of probes that give similar results ?
Do the probes give similar results than those obtained by immunohistochemistry ? What is the probe that is most closely associated with the immunihistochemistry data ?
You can use the cor() command on a table of variables and which will calculate all pairwise correlations; the pairs() command will create the related graphics.

??? done "Answer"
    ```r
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
        ##check all the correlation (Pearson) and see which one correspond
    cor(expr)
    
    ##for loop to see all the correlations with ER status
    for(i in 1:9){
    print(cor(expr[,i],as.numeric(clin[rownames(expr),"er"]),method="spearman"))
    	}
    	### put them in a variable
    	s <- c()
    	for(i in 1:9){
    	s[i] <-cor(expr[,i],as.numeric(clin[rownames(expr),"er"]),method="spearman")
    	}
    	head(clin)
    	
    	### do some boxplots
    plot(clin$er,expr[,1])
    ```
    