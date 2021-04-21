# Function for calculating confidence interval
confidence_interval <- function(x, confidenceLevel = 0.95) {
  n <- length(x)
  alpha <- 1 - confidenceLevel
  if (n < 30)
    stat <- qt(1 - alpha / 2, n - 1)
  else
    stat <- qnorm(1 - alpha / 2)
  interval <- stat * sd(x) / sqrt(n)
  mean_value <- mean(x)
  result <- c(mean_value - interval, mean_value + interval)
  names(result) <- c("lower", "upper")
  result
}

# Function for plotting data
plot_result <- function(file, start = 1) {
  data <- read.csv(file)
  data <- data[start:nrow(data), ]

  plot(data, type = "l", xlab = "Körning", ylab = "Exekveringstid (s)")
}

# Function for calculating mean
mean_result <- function(file, start = 1) {
  data <- read.csv(file)
  data <- data[start:nrow(data), ]

  mean(data$time)
}
