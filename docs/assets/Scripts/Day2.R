#-----------------
#-----------------
# Introduction to statistics with R
# January 2025
# In Lausanne 
#-----------------
#-----------------

library(faraway)
library(ggpubr)
library(ISwR)
library(rstatix)
library(tidyverse)



#-----------------
#-----------------
#-----------------
# 1st exercise
#-----------------

data(intake)
?intake
attach(intake)
intake 
names(intake)
summary(intake)
mean(intake$pre)
sd(intake$pre)

# Assumption: no significant outliers in the data

ggboxplot(intake$pre, width = 0.5, add = c("mean","jitter"), 
          ylab = "premenstrual intake", xlab = F)

identify_outliers(as.data.frame(intake$pre))

# Assumption: normality

qqnorm(intake$pre)
qqline(intake$pre)

ggqqplot(intake,"pre")

shapiro_test(intake$pre)

# t test

t.test(pre, mu=7725) #one sample two sided t test
t.test(pre, mu=7725, alternative="less") #one sample one sided t test



#-----------------
#-----------------
# 2nd exercise: two samples t-test 
#-----------------

data(energy)
?energy
energy 

# assumption 1: data in each group are normally distributed.

ind.obese <- which(energy[,"stature"] == "obese")
ind.lean <- which(energy$stature == "lean")

shapiro_test(energy$expend[ind.obese]) 
qqnorm(energy$expend[ind.obese])
qqline(energy$expend[ind.obese])
shapiro_test(energy$expend[ind.lean])
qqnorm(energy$expend[ind.lean])
qqline(energy$expend[ind.lean])
# assumption 2: the variances for the two independent groups are equal.

levene_test(energy, expend~stature)
# if the command above does not work, use the levene test from the car package
car::leveneTest(expend~stature, energy, center = "median")

# t test

t.test(energy$expend ~ energy$stature,var.equal=TRUE)

t.test(energy$expend ~ energy$stature)

t.test(energy$expend[ind.obese],energy$expend[ind.lean])
t.test(expend~stature,data=energy)

ggqqplot(energy[ind.lean,], "expend")
identify_outliers(as.data.frame(energy[ind.lean,"expend"]))

#-----------------
#-----------------
# 3rd exercise: paired t-test
#-----------------

data(intake)
?intake
attach(intake)
intake 

# assumption 1: Each of the paired measurements must be obtained from the same subject
# check your sampling design !

# assumption 2: The measured differences are normally distributed.

intake.diff <- intake$post - intake$pre
#intake.diff.df <- as.data.frame(intake.diff)

shapiro_test(intake.diff) 

# t test

t.test(intake$pre, intake$post, paired = T)



#-----------------
#-----------------
# 4th exercise: simulations of datasets
#-----------------
## change these how you want!
#rnorm
KO <- runif(10, min=27, max=34)
WT <- runif(10, min=27, max=34)
KO <- as.data.frame(KO)
names(KO) <- "weight"
KO$genotype <- "KO"
WT <- as.data.frame(WT)
names(WT) <- "weight"
WT$genotype <- "WT"

KO_WT <- rbind(KO,WT)
shapiro.test(WT$weight)
shapiro.test(KO$weight)

boxplot(KO_WT$weight ~ KO_WT$genotype, main="Mice weight at 18 weeks", xlab="", ylab="")

res.welch.test <- t.test(KO_WT$weight ~ KO_WT$genotype)
res.t.test <- t.test(KO_WT$weight ~ KO_WT$genotype, var.equal = T)

res.welch.test
res.t.test

res.welch.test$p.value
res.t.test$p.value

sim.p.welch.test <- NULL
sim.p.t.test <- NULL
sim.p.wilcox.test <- NULL

for (i in 1:1000) {
  KO <- runif(3, min=30, max=34)
  WT <- runif(3, min=27, max=29)
  KO <- as.data.frame(KO)
  names(KO) <- "weight"
  KO$genotype <- "KO"
  WT <- as.data.frame(WT)
  names(WT) <- "weight"
  WT$genotype <- "WT"
  
  KO_WT <- rbind(KO,WT)
  
  res.welch.test <- t.test(KO_WT$weight ~ KO_WT$genotype)
  res.t.test <- t.test(KO_WT$weight ~ KO_WT$genotype, var.equal = T)
  res.wilcox.test <- wilcox.test(KO_WT$weight ~ KO_WT$genotype)
  sim.p.welch.test <- c(sim.p.welch.test, res.welch.test$p.value)
  sim.p.t.test <- c(sim.p.t.test, res.t.test$p.value)
  sim.p.wilcox.test <- c(sim.p.wilcox.test,res.wilcox.test$p.value)
  }

str(sim.p.welch.test)
str(sim.p.t.test)
sum(sim.p.welch.test < 0.05)
sum(sim.p.t.test < 0.05)
sum(sim.p.wilcox.test<0.05)
plot(sim.p.t.test,sim.p.welch.test)

adj.bonf <- p.adjust(sim.p.welch.test, method="bonf")
sum(adj.bonf < 0.05)
adj.BH <- p.adjust(sim.p.welch.test, method="BH")
sum(adj.BH < 0.05)



#-----------------
#-----------------
# 5th exercise: ANOVA
#-----------------

data(coagulation)

# check the data
summary(coagulation)

get_summary_stats(group_by(coagulation,diet),coag, type = "mean_sd") 


coagulation %>% group_by(diet) %>% get_summary_stats(coag, type = "mean_sd") 

boxplot(coagulation$coag ~ coagulation$diet)

ggboxplot(coagulation, x="diet",y="coag",add="jitter")

# check normality
ind.A <- which(coagulation$diet=="A")
?ggqqplot
ggqqplot(coagulation[ind.A,], "coag")
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

# check pairwise 

TukeyHSD(anova_diet)

pairwise.t.test(coagulation$coag,coagulation$diet,p.adj="bonf")
pairwise.t.test(coagulation$coag,coagulation$diet,p.adj="BH")
