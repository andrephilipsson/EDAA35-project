# function for plotting data
plotresult <- function(file , start = 1) {
  data <- read.csv(file)
  data <- data[start : nrow(data),]
  plot(data, type = 'l')
}
#system("./a.out input output true")
#system("python main.py input output true")
system("java main input output true")
plotresult("output.txt") 
pdf("output.txt") 
plotresult("output.txt") 
sumMedel <- c()
for (i in 1:100) {
  #system("./a.out input output1 true")
  data <- read.csv("output1")
  data <- data[250:nrow(data),]
  sumMedel <- c(sumMedel, mean(data))
  file.remove("output1")
}
#print(sumMedel)
#medel = mean(sumMedel)
#print(medel)
#t.test(sumMedel)

