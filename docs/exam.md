## **EXAM** :scream:

The participants who need credits must answer the following questions and send the results as an R script with comments to rachel.marcone@sib.swiss until latest end of January 2024.

Data: A set of data collected by Heinz et al.(* Heinz G, Peterson LJ, Johnson RW, Kerk CJ Journal of Statistics Education Volume 11, Number 2 (2003)
jse.amstat.org/v11n2/datasets.heinz.html, by Grete Heinz, Louis J. Peterson, Roger W. Johnson, and Carter J. Kerk, all rights reserved) is available in the file IS_24_exam.csv


Goals: Get to know the overall structure of the data. Summarize variables numerically and graphically. Model relationships between variables.

[Download exercise material](assets/exercises/IS_24_exam.csv){: .md-button }

## Observations
1. Have look at the file in a text editor to get familiar with it
2. Open a new script file in R studio, comment it and save it.
3. Read the file, assign it to object "IS_24_exam". Examine "IS_24_exam".
a) How many observations and variables does the dataset have ?
b) What are the names and types of the variables ?
c) Get the summary statistics of "IS_24_exam".
4. Make a scatter plot of all pairs of variables in the dataset.
5. Calculate the BMI of each person and add it as an extra variable "bmi" to your dataframe (Google the BMI formula).

## Modelling

1. Is there a significant difference in bmi means between males and females?
2. How strong is the linear (Pearson) correlation between chest girth and height? Is it significant?
3. If you model a linear relationship, how much does the chest girth increase per added cm of height? Is the change significant? What if you do this for males and females separately?
4. Come up with a question for hypothesis testing of your own that includes one or more variable(s) of your choosing from the data set.
5. Make plots as seen in the course to try to give visualization based answers to this question.
6. Test your hypothesis using the tests and modeling techniques from the course, based on the type of variables you have. Include tests of the assumptions where appropriate.

