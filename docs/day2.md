# Hypothesis Testing

In this section, you will find the R code that we will use during the course. We will explain the code and output during correction of the exercises.

Slides of lectures:

[Download slides Morning](assets/pdf/Parametric and non parametric tests - 090221.pdf){: .md-button }
[Download slides Afternoon](assets/pdf/ANOVA and confidence intervals - 090221.pdf){: .md-button }


The purpose of this exercise is to help you to better interpret a p-value by using R for introducing you to some simple hypothesis testing functions. As usual, be sure to read the help documentation for any new functions.


## Exercise 1: One-sample t-test
We use the intake data, available in the ISwR package. We will use the variable pre.

```r
library(ISwR)
library(ggplot2) #we will show you how to do some standard ggplots
data(intake)
?intake
attach(intake)
intake
```

Start off by looking at some simple summary statistics: mean, sd, quantile (hardly necessary for such a small data set, but good practice).

??? done "Answer"
    ```r
    summary(intake)
    mean(intake$pre)
    sd(intake$pre)
    ```
Might these data be approximately normally distributed? 
??? done "Answer"
    ```r
    # Assumption: no significant outliers in the data
    ggboxplot(intake$pre, width = 0.5, add = c("mean","jitter"),ylab = "premenstrual intake", xlab = F)

    identify_outliers(as.data.frame(intake$pre))

    # Assumption: normality
    ggqqplot(intake,"pre")
    shapiro_test(intake$pre)
    ```

    
Suppose you wish to test whether there is a systematic deviation between the women's (pre) energy intake and a recommended value of 7725 kJ. Assuming that the data are from a normal distribution, we are interested in testing whether the (population) mean is 7725. We can do a t-test in R as follows:

```r
t.test(pre, mu=7725)
```
Any idea what the argument alternative is doing ? 

```r
t.test(pre, mu=7725, alternative="less")
```

There are several components to the output, Take some time to make sure you can understand what it all means. For an alpha level of 0.05, do you reject the null hypothesis? What about for an alpha level of 0.01?

The default assumes that you want a 2-sided test. Use help to find out how you could get a 1-sided test that would be meaningful for the dataset, and carry this out. For an alpha level of 0.01, do you reject the null hypothesis?


## Exercise 2: Two-sample t-test

We use the energy data to illustrate the use of t.test for testing equality of population means based on two independent samples. Here, we wish to compare mean energy expenditure between lean and obese women.

```r
data(energy)
?energy
attach(energy)
energy
```
What are the assumptions you need to check for carring out a test ?

??? done "Answer"
    ```r
    # assumption 1: data in each group are normally distributed.
    
    ind.obese <- which(energy$stature == "obese")
    ind.lean <- which(energy$stature == "lean")
    
    shapiro_test(energy$expend[ind.obese]) 
    shapiro_test(energy$expend[ind.lean]) 
    
    # assumption 2: the variances for the two independent groups are equal.
    
    levene_test(energy, expend~stature)
    # if the command above does not work, use the levene test from the car package
    car::leveneTest(expend~stature, energy, center = "median")
    ```

The variable stature gives the grouping. The test can be carried out as follows:
```r
t.test(expend ~ stature)
```

Check that you understand the output. For an alpha level of 0.01, do you reject the null hypothesis?


## Exercise 3: Paired t-test

Paired tests are used when there are two measurements (a 'pair') on the same individual. A paired test is essentially a one-sample test of the differences between the measurements.

Any assumptions to be tested ?

??? done "Answer"
    ```r
    # assumption 1: Each of the paired measurements must be obtained from the same subject
    # check your sampling design !

    # assumption 2: The measured differences are normally distributed.

    intake.diff <- intake$post - intake$pre
    intake.diff.df <- as.data.frame(intake.diff)

    shapiro_test(intake.diff)
    ```
    
We can carry out a paired t-test on the differences between pre and post from the intake data as follows:
```r
t.test(pre, post, paired=TRUE)
```

Again, make sure that you know how to interpret the output. Assuming an alpha level of 0.01, what do you conclude?

It was important here to tell t.test that this was a paired test. What happens if you leave out paired=TRUE from the t.test command? Are the assumptions for a two-sample test satisfied in this situation?


## Exercise 4: Simulation of mice weight data and p values

We are going to simulate in a very simple way weight data for WT and KO mice. We will use a two-sample t-test for testing the difference in mean weight between the 2 groups of mice.

```r
KO <- runif(10, min=27, max=34)
WT <- runif(10, min=27, max=34)
KO <- as.data.frame(KO)
names(KO)[1] <- "weight"
KO$genotype <- "KO"
WT <- as.data.frame(WT)
names(WT)[1] <- "weight"
WT$genotype <- "WT"

KO_WT <- rbind(KO,WT)

boxplot(KO_WT$weight ~ KO_WT$genotype, main="Mice weight at 18 weeks", xlab="", ylab="")

res.welch.test <- t.test(KO_WT$weight ~ KO_WT$genotype)
res.t.test <- t.test(KO_WT$weight ~ KO_WT$genotype, var.equal = T)
```

Display or summarise the resulting p-values.

We will now simulate weight data for WT and KO mice 1000 times and look at the distribution of p-values:

```r
sim.p.welch.test <- NULL
sim.p.t.test <- NULL

for (i in 1:1000) {
  KO <- runif(10, min=27, max=34)
  WT <- runif(10, min=27, max=34)
  KO <- as.data.frame(KO)
  names(KO)[1] <- "weight"
  KO$genotype <- "KO"
  WT <- as.data.frame(WT)
  names(WT)[1] <- "weight"
  WT$genotype <- "WT"

  KO_WT <- rbind(KO,WT)

  res.welch.test <- t.test(KO_WT$weight ~ KO_WT$genotype)
  res.t.test <- t.test(KO_WT$weight ~ KO_WT$genotype, var.equal = T)

  sim.p.welch.test <- c(sim.p.welch.test, res.welch.test$p.value)
  sim.p.t.test <- c(sim.p.t.test, res.t.test$p.value)
}

sum(sim.p.welch.test < 0.05)
sum(sim.p.t.test < 0.05)
```

How many tests are significant ? What if you apply a Bonferroni correction ? What if you apply a FDR correction ? (use the p.adjust function if needed).

Change the parameters of the simulations and see what is the effect on the p-values.

??? done "Answer"
    ```r
    adj.bonf <- p.adjust(sim.p.welch.test, method="bonf")
    sum(adj.bonf < 0.05)
    adj.BH <- p.adjust(sim.p.welch.test, method="BH")
    sum(adj.BH < 0.05)
    ```

## Exercise 5: ANOVA
Install the library faraway

```r
library(faraway)
data(coagulation)
```

The dataset comes from Faraway (2002) and comprises a set of 24 blood coagulation times. 24 animals were randomly assigned to four different diets and the samples were taken in a random order.


1. Load the data and explore the dataset

??? done "Answer"
    ```r
    data(coagulation)

    # check the data
    summary(coagulation)

    coagulation %>% group_by(diet) %>% get_summary_stats(coag, type = "mean_sd") 

    boxplot(coagulation$coag ~ coagulation$diet)

    ggboxplot(coagulation, x="diet",y="coag")

    ```



2. Fit an ANOVA model, this also means checking assumptions!
??? done "Answer"
    ```r
    # check normality

    ?ggqqplot
    ggqqplot(coagulation[coagulation$diet=="A",], "coag")
    ggqqplot(coagulation[coagulation$diet=="B",], "coag")
    ggqqplot(coagulation[coagulation$diet=="C",], "coag")
    ggqqplot(coagulation[coagulation$diet=="D",], "coag")

    shapiro.test(coagulation[coagulation$diet=="A","coag"])
    shapiro.test(coagulation[coagulation$diet=="B","coag"])
    shapiro.test(coagulation[coagulation$diet=="C","coag"])
    shapiro.test(coagulation[coagulation$diet=="D","coag"])

    # check variance equality
    levene_test(coagulation,coag~diet)
    # if the command above does not work, use the levene test from the car package
    car::leveneTest(coag~diet, coagulation, center = "median")

    # do anova
    anova_diet <- aov(coagulation$coag~coagulation$diet)

    summary(anova_diet)
    ```
3. Is there some differences between the groups? If yes, which group(s) is different ?
??? done "Answer"
    ```r
    # check pairwise 

    TukeyHSD(anova_diet)

    pairwise.t.test(coagulation$coag,coagulation$diet,p.adj="bonf")
    pairwise.t.test(coagulation$coag,coagulation$diet,p.adj="holm")
    ```
    





