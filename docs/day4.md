# Clustering and PCA

In this section, you will find the R code that we will use during the course. We will explain the code and output during correction of the exercises.

Slides of lectures:

[Download slides](assets/pdf/Clustering.pdf){: .md-button }




## The Iris data set 

We will study the iris data set, containing measurements of the petal length and width and the sepal length and width for 150 iris flowers of three different types. The data set is available within R. First, we load the data, display its structure and summarize its content. 
```r
data(iris) 
str(iris) 
summary(iris) 
head(iris) 
```

Are the range of values for the individual variables comparable? 

What is the dimensionality of the data (the number of coordinates used to represent the samples)? 

Next, we create univariate plots to visualize the variables individually or pairwise. 
```r
boxplot(iris[, 1:4]) 
pairs(iris[,1:4], col = iris$Species, pch = 19) 
```

What do the colors represent? Are there any apparent associations between the variables? 

We can also create boxplots of the individual variables stratified by iris type. 
```r
boxplot(iris$Petal.Width ~ iris$Species) 
```

Now, we apply PCA to the data, using the prcomp function. Make sure that you know what the arguments to the function stand for. 


```r
pca.iris.cov = prcomp(iris[, 1:4], center = TRUE, scale. = FALSE) 
plot(pca.iris.cov$x, col = iris$Species, pch = 19) 
```

What can you see in the sample plot? 

In addition to the sample configuration, we also look at the variable loadings, to see which variables contribute most to the principal components, and at the fraction of variance that is explained by each principal component. 

```r
pca.iris.cov$rotation 
summary(pca.iris.cov) 
```

Which variables have the strongest influence on each of the first two principal components? How can you use this information to interpret the sample PCA representation? 

We can now visualize the sample scores and the variable loadings together in a biplot. 
```r
biplot(pca.iris.cov, scale = 0) 
```

What do the different objects in the biplot represent? How are they connected to the output from prcomp? 

The sample scores from PCA are obtained as linear combinations of the four measured variables, with weights given by the variable loadings. Verify that this is the case e.g. for the scores for the first flower. 

```r
iris.centered = scale(iris[, 1:4], center = TRUE, scale = FALSE) # compute linear combination scores.sample1 = iris.centered[1, ] %*% pca.iris.cov$rotation # compare to PCA scores 
pca.iris.cov$x[1, ]/scores.sample1 
```

The PCA just applied was based on the non-standardized variables, that is, on the covariance matrix. 

Where was this specified? Can we gain some understanding of the results (the variable loadings) by studying the individual variable variances? 

```r
var(iris[, 1:4]) 
```

Next, we rerun the analysis with standardized variables. 
```r
pca.iris.corr = prcomp(iris[, 1:4], center = TRUE, scale. = TRUE) 
plot(pca.iris.corr$x, col = iris$Species, pch = 19) 
pca.iris.corr$rotation summary(pca.iris.corr) 
biplot(pca.iris.corr, scale = 0) 
```

How did the results change? Can we understand the change by using the information form the pairwise scatterplots and the individual variances? Which variables appear to be most important for separating the two groups of iris flowers seen in the PCA plot? 

To see the amount of variance captured by each of the principal components, construct scree plots for the two PCAs. 

```r
par(mfrow = c(1, 2)) 
screeplot(pca.iris.cov, type = "line") 
screeplot(pca.iris.corr, type = "line") 
```

How many principal components are needed to explain most of the variance in the data? 

## Dengue fever example 

In this example, we will use a gene expression data set aimed at studying the differences between patients with dengue fever and healthy controls or convalescents. The data set corresponds to a publication by Kwissa et al (Cell Host & Microbe 16:115-127 (2014)), and the expression matrix has been deposited in Gene Expression Omnibus (GEO) with accession number GDS5093. 

### Data retrieval 

We will use the GEOquery package to retrieve the data and platform annotation information. 

The GEOquery package is available from Bioconductor, and can be installed in the following way: 
```r
source("https://bioconductor.org/biocLite.R") biocLite("GEOquery")  
```
And the data retrieved like this and then have a look at the downloaded data :
```r
library(GEOquery)  
## Retrieve the data from GEO 
gds <- getGEO("GDS5093") 
## If you have already downloaded the data, you can load the soft file directly 
## gds <- getGEO("GDS5093.soft.gz")  

## Look at the elements of the downloaded data head(Columns(gds)) 
head(Table(gds)) 
head(Meta(gds))  

## Convert the gds object to an expression set 
eset <- GDS2eSet(gds) 
```

We have converted the downloaded object to a so called expression set. The expression set is a special Bioconductor data container that is commonly used to store all information associated with a microarray experiment. Using different accessor functions, we can extract the different types of information stored in the expression set (expression values, sample annotations, variable annotations) 

```r
## Sample information 
head(pData(eset))  
## Expression matrix 
head(exprs(eset))  
## Feature information 
head(fData(eset)) 
```

## Principal component analysis 

First we perform a PCA using all the variables in the data set. We will perform the following analyses using data on probeset level, but it could also be done after summarizing the expression for all probe sets targeting the same gene. 
```r
pca <- prcomp(t(exprs(eset)), scale. = TRUE) 
```

Plot the sample representation from the PCA. How much variance is encoded by each principal component? Are the principal components encoding known information? 

```r
plot(pca$x, pch = 19, cex = 2) 
plot(pca) 
pca$sdev^2/sum(pca$sdev^2)  
plot(pca$x, pch = 19, cex = 2, col =factor(pData(eset)$disease.state)) 
legend("topright", legend = levels(factor(pData(eset)$disease.state)),col = 1:4, pch = 19) 
```

It is common practice to filter out lowly varying genes before standardizing the data set and performing PCA. We will try this approach, using two different filter thresholds, leaving 5,000 and 100 variables, respectively. 
```r
vars <- apply(exprs(eset), 1, var) 
vars.order <- order(vars, decreasing = TRUE)  
pca.5000 <- prcomp(t(exprs(eset)[vars.order[1:5000], ]), scale. = TRUE) 
plot(pca.5000$x, pch = 19, cex = 2, col = factor(pData(eset)$disease.state)) 
legend("topright", legend = levels(factor(pData(eset)$disease.state)), col = 1:4, pch = 19)  
pca.100 <- prcomp(t(exprs(eset)[vars.order[1:100], ]), scale. = TRUE) plot(pca.100$x, pch = 19, cex = 2, col = factor(pData(eset)$disease.state)) 
legend("topright", legend = levels(factor(pData(eset)$disease.state)), col = 1:4, pch = 19) 
```

What do you notice in the last plot? The PC2 clearly splits the samples into two groups. Does this correspond to any known sample annotation? 

```r
plot(pca.100$x, pch = 19, cex = 2, col = factor(pData(eset)$infection)) 
```

How can we find out what this is? One way is to look at the genes that are responsible for the split, that is, the ones that are contributing a lot to PC2. 

```r
pc2.weights <- data.frame(pca.100$rotation[, 2, drop = FALSE]) 
pc2.weights$ChromosomeLoc <- fData(eset)[rownames(pc2.weights), "Chromosome location"] 
head(pc2.weights[order(pc2.weights$PC2), ])
tail(pc2.weights[order(pc2.weights$PC2), ]) 
```

Now what do you think this component represents? 

## Golub leukemia data 

In this exercise we study a microarray data set that is available as an expression set in R, from the library golubEsets. 

We load the data and extract the expression values and a sample annotation. 
```r
library(golubEsets) 
data(Golub_Train) 
golub.expr = exprs(Golub_Train) 
golub.sample.annot = Golub_Train$ALL.AML 
```

First, we apply PCA to the unstandardized data. 

```r
pca.golub.cov = prcomp(t(golub.expr), center = TRUE, scale. = FALSE) 
plot(pca.golub.cov$x[, 1:2], col = golub.sample.annot, pch = 19) 
```

We also apply PCA to the standardized data. 

```r
pca.golub.corr = prcomp(t(golub.expr), center = TRUE, scale. = TRUE) 
plot(pca.golub.corr$x[, 1:2], col = golub.sample.annot, pch = 19) 
```

Try also to plot the second and third principal components instead of the first two. What may be the reason for the discrepancy between the two results? 

For high-dimensional data sets like microarrays it is common to filter out the variables with low variance before applying the PCA. Extract the 1,000 variables with the highest variance from the Golub data set, and apply PCA to the standardized data sets to focus mainly on the correlations between the remaining variables. 

```r
golub.expr.filtered = golub.expr[order(apply(golub.expr, 1, var), decreasing = TRUE)[1:1000], ]
pca.golub.filtered.corr = prcomp(t(golub.expr.filtered), center = TRUE, scale. = TRUE)
plot(pca.golub.filtered.corr$x[, 1:2], col = golub.sample.annot, pch = 19)
```

Compare the resulting plot to the previous two plots. What happens if you apply PCA to the unstandardized, filtered data set? 

## Swiss banknote data 

In this exercise we consider a data set containing measurements from 100 genuine Swiss banknotes and 100 counterfeit notes. For each banknote there are six measurements; the length of the bill, the width of the left and right edges, the widths of the bottom and top margin, and the length of the image diagonal. The data set is available in the R package alr3. 

First, we load the data and look at the summary 
```r
library(alr3)
data(banknote) 
summary(banknote)
```

Then we apply PCA after scaling each variable to unit variance. 

```r
pca.banknote = prcomp(banknote[, 1:6], center = TRUE, scale. = TRUE) 
summary(pca.banknote) 
```

In this example, we will create a biplot manually, by overlaying the sample and variable PCA plots 

```r
plot(pca.banknote$x[, 1:2], col = c("black", "green")[banknote[, 7] + 1], pch = 19)
arrows(0, 0, 2*pca.banknote$rotation[, 1], 2*pca.banknote$rotation[, 2], col = "red", angle = 20, length = 0.1)
text(2.4*pca.banknote$rotation[, 1:2], colnames(banknote[, 1:6]), col = "red") 
```

In the resulting plot, the black and green points represent the genuine and counterfeit notes, respectively. The red arrows correspond to the contributions of the six variables to the principal components. 

In what ways did the counterfeiters fail to mimic the genuine notes? Look at the individual variables to verify. 

```r
par(mfrow = c(2, 3)) 
for (v in c("Length", "Left", "Right", "Bottom", "Top", "Diagonal")) {   boxplot(banknote[, v] ~ banknote[, "Y"], xlab = "Banknote status", ylab = v) } 
```


## Points in plates
1. Import the data from dataClustering.csv
2. What is the dimension of this dataset?
3. How many data point do we have?
??? done "Answer"
    ```r
    library("cluster") 
    mydata1<-read.csv("dataClustering.csv") 
    df<-data.frame(mydata1$Coord_X ,mydata1$Coord_Y ) 
    colnames(df) <- c("X", "Y")
    plot(df$X, df$Y, pch=20) 
    dim(df)
    ```
    
4. Evaluate Euclidean distance of points in a plates
??? done "Answer"
    ```r
    df.dist<-dist(df) 
    ```
    

5. Classify points to find clusters using hierarchical
clustering and the average agglomeration method

??? done "Answer"
    ```r
    df.h<-hclust(df.dist,"ave") 
    plot(df.h) 
    
    colorScale <- colorRampPalette(c("blue", "green","yellow","red","darkred"))(1000)
    heatmap(as.matrix(df.dist),Colv=NA, Rowv=NA, scale="none", col=colorScale)
    ```

6. We expect to have 3 clusters. When you apply k-means
algorithm using 1 iteration, does it differ from applying it
using 10 or 100 iterations?
??? done "Answer"
    ```r
    kmeans(df,3)
    
    cl.1 <- kmeans(df, 3, iter.max = 1)
    plot(df, col = cl.1$cluster)
    points(cl.1$centers, col = 1:5, pch = 8)
    
    kmeans(df,3)
    
    cl.1 <- kmeans(df, 3, iter.max = 1)
    plot(df, col = cl.1$cluster)
    points(cl.1$centers, col = 1:5, pch = 8)

    cl.10 <- kmeans(df, 3, iter.max = 10)
    plot(df, col = cl.10$cluster)
    points(cl.10$centers, col = 1:5, pch = 8)
    
    cl.100 <- kmeans(df, 3, iter.max = 100)
    plot(df, col = cl.100$cluster)
    points(cl.100$centers, col = 1:5, pch = 8)
    ```

7. What is the outcome of the C-means clustering?

```r
install.packages("e1071")
library(e1071)
?cmeans
```
??? done "Answer"
    ```r
    cmeans(df,3)
    
    cl.1 <- cmeans(df, 3, iter.max = 1)
    plot(df, col = cl.1$cluster)
    points(cl.1$centers, col = 1:5, pch = 8)
    
    cl.10 <- cmeans(df, 3, iter.max = 10)
    plot(df, col = cl.10$cluster)
    points(cl.10$centers, col = 1:5, pch = 8)
    
    cl.100 <- cmeans(df, 3, iter.max = 100)
    plot(df, col = cl.100$cluster)
    points(cl.100$centers, col = 1:5, pch = 8)
    ```


8. What are the top 3 models mclustBIC function suggests
based on the BIC criterion?
9. How many clusters did it find using the top model?
10. Plot the outcome
??? done "Answer"
    ```r
    library("mclust")
    BIC <- mclustBIC(df)
    plot(BIC)
    summary(BIC)
    mod1 <- Mclust(df, x = BIC)
    summary(mod1, parameters = TRUE)
    plot(mod1, what = "classification")
    
    mod2 <- Mclust(df, modelName = c("VEE"))
    plot(mod2, what = "classification")
    
    mod3 <- Mclust(df, modelName = "EEE",G=9)
    plot(mod3, what = "classification")
    ``` 