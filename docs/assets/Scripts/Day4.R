
#####################
## Morning
#####################

############
### PCA exercise
############

### open the data

data(iris)
iris
head(iris)
summary(iris)
boxplot(iris[, 1:4])
pairs(iris[,1:4], col = iris$Species, pch = 19)
boxplot(iris$Petal.Width ~ iris$Species)
?prcomp
pca.iris.cov = prcomp(iris[, 1:4], center = TRUE, scale. = FALSE)
plot(pca.iris.cov$sdev,type="l")

plot(pca.iris.cov$x, col = iris$Species, pch = 19)


pca.iris.cov_nc = prcomp(iris[, 1:4],center=FALSE, scale. = TRUE)
plot(pca.iris.cov_nc$x, col = iris$Species, pch = 19)

pca.iris.cov_nc_ns = prcomp(iris[, 1:4],center=FALSE, scale. = FALSE)
plot(pca.iris.cov_nc_ns$x, col = iris$Species, pch = 19)

pca.iris.cov_c_s = prcomp(iris[, 1:4],center=TRUE, scale. = TRUE)
plot(pca.iris.cov_c_s$x, col = iris$Species, pch = 19)
legend("bottomright", fill = unique(iris$Species), 
       legend = c( levels(iris$Species)))

pca.iris.cov$rotation
summary(pca.iris.cov)
biplot(pca.iris.cov, scale = 0)
summary(iris)
# iris.centered_scaled = scale(iris[, 1:4], center = TRUE, scale = TRUE) # compute linear combination 
iris.centered = scale(iris[, 1:4], center = TRUE, scale = FALSE) # compute linear combination 
# summary(iris.centered_scaled)
summary(iris.centered)
scores.sample1 = iris.centered[1, ] %*% pca.iris.cov$rotation # compare to PCA scores 
pca.iris.cov$x[1, ]/scores.sample1

?prcomp

var(iris[, 1:4])


pca.iris.corr = prcomp(iris[, 1:4], center = TRUE, scale. = TRUE)
plot(pca.iris.corr$x, col = iris$Species, pch = 16) 
pca.iris.corr$rotation 
summary(pca.iris.corr) 
biplot(pca.iris.corr, scale = 0)


par(mfrow = c(1, 2)) 
screeplot(pca.iris.cov, type = "line") 
screeplot(pca.iris.corr, type = "line")


source("https://bioconductor.org/biocLite.R") 
biocLite("GEOquery") 
library(GEOquery)  ## Retrieve the data from GEO 
gds <- getGEO("GDS5093") ## If you have already downloaded the data, you can load the soft file directly ## gds <- getGEO("GDS5093.soft.gz")  ## Look at the elements of the downloaded data 
head(Columns(gds)) 
head(Table(gds)) 
head(Meta(gds))  ## Convert the gds object to an expression set 
eset <- GDS2eSet(gds)
eset[1:3,1:3]

pca <- prcomp(t(exprs(eset)), scale. = TRUE)
?prcomp
##centering?
plot(pca$x, pch = 19, cex = 2) 
plot(pca) 
round(pca$sdev^2/sum(pca$sdev^2),2)
plot(pca$x, pch = 19, cex = 2, col = factor(pData(eset)$disease.state)) 
legend("topright", legend = levels(factor(pData(eset)$disease.state)),         col = 1:4, pch = 19)


vars <- apply(exprs(eset), 1, var) 
head(vars)
vars.order <- order(vars, decreasing = TRUE)  
head(vars.order)
pca.5000 <- prcomp(t(exprs(eset)[vars.order[1:5000], ]), scale. = TRUE) 
plot(pca.5000$x, pch = 19, cex = 2, col = factor(pData(eset)$disease.state)) 
legend("topright", legend = levels(factor(pData(eset)$disease.state)),         col = 1:4, pch = 19)  
pca.100 <- prcomp(t(exprs(eset)[vars.order[1:100], ]), scale. = TRUE) 
plot(pca.100$x, pch = 19, cex = 2, col = factor(pData(eset)$disease.state)) 
legend("topright", legend = levels(factor(pData(eset)$disease.state)),         col = 1:4, pch = 19)

plot(pca.100$x, pch = 19, cex = 2, col = factor(pData(eset)$infection))

pc2.weights <- data.frame(pca.100$rotation[, 2, drop = FALSE])
pc2.weights$ChromosomeLoc <- fData(eset)[rownames(pc2.weights), "Chromosome location"] 

head(pc2.weights[order(pc2.weights$PC2), ]) 
tail(pc2.weights[order(pc2.weights$PC2), ])



#####################
## Afternooon
#####################
######
### Afternoon exercise
######


library(golubEsets) 
data(Golub_Train) 
golub.expr = exprs(Golub_Train) 
golub.sample.annot = Golub_Train$ALL.AML
dim(golub.expr)
head(golub.expr[,1:3])
summary(golub.expr)
head(golub.expr)
pca.golub.cov = prcomp(t(golub.expr), center = TRUE, scale. = FALSE)
plot(pca.golub.cov$x[, 1:2], col = golub.sample.annot, pch = 19)
legend("topleft",legend=levels(factor(golub.sample.annot)),col=1:2,pch=20)

pca.golub.corr = prcomp(t(golub.expr), center = TRUE, scale. = TRUE) 
plot(pca.golub.corr$x[, 1:2], col = golub.sample.annot, pch = 19)

golub.expr.filtered = golub.expr[order(apply(golub.expr, 1, var), decreasing = TRUE)[1:1000], ] 
pca.golub.filtered.corr = prcomp(t(golub.expr.filtered), center = TRUE, scale. = TRUE) 
plot(pca.golub.filtered.corr$x[, 1:2], col = golub.sample.annot, pch = 19)

library(mclust) 
data(banknote)
summary(banknote)

banknote.df <- banknote[,-1] 
summary(banknote.df)

pca.banknote = prcomp(banknote[, 2:7], center = TRUE, scale. = TRUE) 
summary(pca.banknote)

plot(pca.banknote$x[, 1:2], col = factor(banknote[,1]), pch = 19) 
arrows(0, 0, 2*pca.banknote$rotation[, 1], 2*pca.banknote$rotation[, 2], col = "red", angle = 20, length = 0.1) 
text(2.4*pca.banknote$rotation[, 1:2], colnames(banknote[, 2:7]), col = "red")

par(mfrow = c(2, 3)) 
for (v in c("Length", "Left", "Right", "Bottom", "Top", "Diagonal")) {   boxplot(banknote[, v] ~ banknote[, "Status"], xlab = "Banknote status", ylab = v) }


#Points in plates-continuous

library("cluster") 
mydata1<-read.csv("dataClustering.csv") 
df<-data.frame(mydata1$Coord_X ,mydata1$Coord_Y ) 
colnames(df) <- c("X", "Y")
plot(df$X, df$Y, pch=20) 



#evaluate Euclidian distance and display distance matrix
df.dist<-dist(df) 
# classify 
df.h<-hclust(df.dist,"ave") 
plot(df.h) 

colorScale <- colorRampPalette(c("blue", "green","yellow","red","darkred"))(1000)
heatmap(as.matrix(df.dist),Colv=NA, Rowv=NA, scale="none", col=colorScale)

#KMEANS
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



#CMEANS
install.packages("e1071")
library(e1071)
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



#MCLUST
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