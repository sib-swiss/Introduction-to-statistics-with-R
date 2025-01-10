## Starting point in R 

## R is a calculator

2*3
log(4)
exp(3)
pi - 3

## R can store variables

x <- 2 

# equivalent to 

x = 2 

# then we can calculate
1/x
# and store it as a variable
y <- 1/x

# a vector is stored with the command c() separated by commas

x <- c(1,10,3,0.4)
 
# a vector with NA values

x2 <- c(NA,10,NA,0.4)

# one can use a vector variable to create a new one

y <- c(x,x,1,3)

# or do operation with variables
y <- 2*x

# generating number
z <- 1:10
z <- c(1,2,3,4,5,6,7,8,9,10)

## lets see our first functions in R 

# To access the help of a function use help() or ? 

?mean
mean(z)
mean(x2) ## will show NA as there are NA values
mean(x2,na.rm=T) ## na.rm is an argument that is boolean, i.e. either T or F
                 ## explaning what to do with the NAs in the data 


?seq
x <- seq(from=1,to=5,length=17)

#if we want to know which values of x are smaller than 4 we can use "<" which 
#is the boolean operator

x < 4
sum(x<4)

# subselecting some vector entries

x[1]
x[2:5]
x[c(2,5,8)]

## working directory
getwd()

## always set your right environment
setwd()

## open files 

read.delim()
read.csv()
read.table()

#if you have a matrix 
data <- matrix(c(1,2,3,5,6,7),nrow=2)

# you can access the row 2 and the column 3 
data[2,3]

# you can also have dataframes (mix of matrix with different types for the columns)

x <- 1:10
y <- seq(from=5,to=10,length=10)
z <- c("A","B","B","A","A","A","B","A","B","B")
df <- data.frame(d1=x, d2=y, fact=z)

summary(df)
df$fact
df$fact == "B"
!(df$fact == "B") ## changed all TRUE to FALSE
df[ df$fact == "B", "d2" ]

