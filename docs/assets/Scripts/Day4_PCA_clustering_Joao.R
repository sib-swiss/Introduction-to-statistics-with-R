#####################################
# Introduction to Statistics with R #
# PCA and Clustering                #
# Joao Lourenco                     #
# 29.01.2026                        #
#####################################

# clear the environment
rm(list = ls())

######################################
# Example: PCA - The Iris data set  #
######################################

# load the Iris dataset
data(iris) 
?iris

# explore
dim(iris)
#[1] 150   5
summary(iris) 
# Sepal.Length    Sepal.Width     Petal.Length    Petal.Width          Species  
# Min.   :4.300   Min.   :2.000   Min.   :1.000   Min.   :0.100   setosa    :50  
# 1st Qu.:5.100   1st Qu.:2.800   1st Qu.:1.600   1st Qu.:0.300   versicolor:50  
# Median :5.800   Median :3.000   Median :4.350   Median :1.300   virginica :50  
# Mean   :5.843   Mean   :3.057   Mean   :3.758   Mean   :1.199                  
# 3rd Qu.:6.400   3rd Qu.:3.300   3rd Qu.:5.100   3rd Qu.:1.800                  
# Max.   :7.900   Max.   :4.400   Max.   :6.900   Max.   :2.500  
head(iris) 
# Sepal.Length Sepal.Width Petal.Length Petal.Width Species
# 1          5.1         3.5          1.4         0.2  setosa
# 2          4.9         3.0          1.4         0.2  setosa
# 3          4.7         3.2          1.3         0.2  setosa
# 4          4.6         3.1          1.5         0.2  setosa
# 5          5.0         3.6          1.4         0.2  setosa
# 6          5.4         3.9          1.7         0.4  setosa

# PCA (data not scaled - Covariance matrix)
?prcomp
pca.iris.cov <- prcomp(iris[,1:4], center = TRUE, scale. = FALSE)


# New coordinates
head(pca.iris.cov$x)
# PC1        PC2         PC3          PC4
# [1,] -2.684126 -0.3193972  0.02791483  0.002262437
# [2,] -2.714142  0.1770012  0.21046427  0.099026550
# [3,] -2.888991  0.1449494 -0.01790026  0.019968390
# [4,] -2.745343  0.3182990 -0.03155937 -0.075575817
# [5,] -2.728717 -0.3267545 -0.09007924 -0.061258593
# [6,] -2.280860 -0.7413304 -0.16867766 -0.024200858


# PCA Plot
plot(pca.iris.cov$x, pch = 19) # first two PCs
plot(pca.iris.cov$x[,c("PC3","PC4")], pch = 19) # any combination of PCs

# Add colors according to species
cols <- c(setosa = "gold", versicolor = "lightgreen", virginica = "lightblue")
plot(pca.iris.cov$x, col = cols[iris$Species], pch = 19) 
plot(pca.iris.cov$x[,c("PC3","PC4")],col = cols[iris$Species], pch = 19)

# Rotation matrix (the loadings)
pca.iris.cov$rotation 
#               PC1         PC2         PC3        PC4
# Sepal.Length  0.36138659 -0.65658877  0.58202985  0.3154872
# Sepal.Width  -0.08452251 -0.73016143 -0.59791083 -0.3197231
# Petal.Length  0.85667061  0.17337266 -0.07623608 -0.4798390
# Petal.Width   0.35828920  0.07548102 -0.54583143  0.7536574


# sample scores and the variable loadings together in a biplot.
biplot(pca.iris.cov, scale = FALSE)
#biplot(pca.iris.cov,scale = TRUE)

# Individual variances
var(iris[, 1:4]) 
#                Sepal.Length Sepal.Width Petal.Length Petal.Width
# Sepal.Length    0.6856935  -0.0424340    1.2743154   0.5162707
# Sepal.Width    -0.0424340   0.1899794   -0.3296564  -0.1216394
# Petal.Length    1.2743154  -0.3296564    3.1162779   1.2956094
# Petal.Width     0.5162707  -0.1216394    1.2956094   0.5810063

# scree plot
screeplot(pca.iris.cov, type = "line") 

# Proportion of variance
summary(pca.iris.cov)
# Importance of components:
#   PC1     PC2    PC3     PC4
# Standard deviation     2.0563 0.49262 0.2797 0.15439
# Proportion of Variance 0.9246 0.05307 0.0171 0.00521
# Cumulative Proportion  0.9246 0.97769 0.9948 1.00000



############################
# What if we scale the data (correlation matrix)


pca.iris.cor <- prcomp(iris[,1:4], center = TRUE, scale. = TRUE)

plot(pca.iris.cor$x, col = cols[iris$Species], pch = 19) 
plot(pca.iris.cor$x[,c("PC3","PC4")],col = cols[iris$Species], pch = 19)



# Importance of components:
summary(pca.iris.cor)
#                        PC1    PC2     PC3     PC4
# Standard deviation     1.7084 0.9560 0.38309 0.14393
# Proportion of Variance 0.7296 0.2285 0.03669 0.00518
# Cumulative Proportion  0.7296 0.9581 0.99482 1.00000

# Loadings
pca.iris.cor$rotation 
#               PC1         PC2        PC3        PC4
# Sepal.Length  0.5210659 -0.37741762  0.7195664  0.2612863
# Sepal.Width  -0.2693474 -0.92329566 -0.2443818 -0.1235096
# Petal.Length  0.5804131 -0.02449161 -0.1421264 -0.8014492
# Petal.Width   0.5648565 -0.06694199 -0.6342727  0.5235971

biplot(pca.iris.cor, scale = 0)

# Check the correlation matrix
cor(iris[, 1:4]) 
# Sepal.Length Sepal.Width Petal.Length Petal.Width
# Sepal.Length    1.0000000  -0.1175698    0.8717538   0.8179411
# Sepal.Width    -0.1175698   1.0000000   -0.4284401  -0.3661259
# Petal.Length    0.8717538  -0.4284401    1.0000000   0.9628654
# Petal.Width     0.8179411  -0.3661259    0.9628654   1.0000000

# scree plot
screeplot(pca.iris.cor, type = "line") 




#########################
# Distances             #
#########################


?dist

# compute a distance matrix between the first 10 samples from the Iris dataset
distanceMatrix <- as.matrix(dist(iris[, 1:4], 
                                 method = "euclidean", upper = TRUE, diag = TRUE))


# Heatmap (stats package)
heatmap(distanceMatrix,Rowv = NA, Colv = NA, scale="none")

# Heatmap (ComplexHeatmap package)
#BiocManager::install("ComplexHeatmap")
library(ComplexHeatmap)

?Heatmap

# simple heatmap
Heatmap(distanceMatrix, cluster_rows = F, cluster_columns = F)

# add annotation
species_annot <- HeatmapAnnotation(Species = iris$Species,
                                   col = list(Species = c(
                                     setosa = "gold",
                                     versicolor = "lightgreen",
                                     virginica = "lightblue")),
                                   annotation_name_side = "left")


Heatmap(distanceMatrix,
        cluster_rows = F, 
        cluster_columns = F,
        top_annotation = species_annot)





##########################
# Hierarchical clustering

# Create a random matrix
mat <- matrix(data = rnorm(300, mean= 100, sd=10), nrow = 150, ncol = 2)

# Euclidian distances
mat.dist<-as.matrix(dist(mat))

# show heatmap
Heatmap(mat.dist,cluster_rows = F, cluster_columns = F)

# change heatmap’s colors
colorScale <- colorRampPalette(c("blue", "green","yellow","red","darkred"))(1000)
Heatmap(mat.dist,cluster_rows = F, cluster_columns = F, col = colorScale)


?hclust

# Based on Euclidian distances
distE <- dist(mat) # not a matrix

hE <- hclust(distE,method = "complete")
plot(hE) 

Heatmap(
  mat.dist,
  cluster_rows = hE,
  cluster_columns = hE,
  col = colorScale
)


# Based on Manhattan distances
distM<-dist(mat,method="manhattan")

hM <- hclust(distM,"complete")
plot(hM) 


Heatmap(
  mat.dist,
  cluster_rows = hM,
  cluster_columns = hM,
  col = colorScale
)


##########################
# K means clustering

?kmeans

# k=3, 1 iteration
cl.1 <- kmeans(mat, 3, iter.max = 1)

# plot the samples and color by cluster
plot(mat, col = cl.1$cluster)

# add centroids (stars)
points(cl.1$centers, col = 1:5, pch = 8)


# k=3, 10 iterations
cl.10 <- kmeans(mat, 3, iter.max = 10)
plot(mat, col = cl.10$cluster)
points(cl.10$centers, col = 1:5, pch = 8)


# k=3, 100 iterations
cl.10 <- kmeans(mat, 3, iter.max = 100)
plot(mat, col = cl.10$cluster)
points(cl.10$centers, col = 1:5, pch = 8)








