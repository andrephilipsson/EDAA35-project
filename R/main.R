source("R/utils.R")

# Ugly place for this, might want to move it
if(!dir.exists(file.path("results"))) dir.create(file.path("results"))

# The CUT_OFF runs we want to start the calculations from.
# A value of 1 means that we want to use all runs.
CUT_OFF <- 1


get_command_and_filename <- function(language, data, quicksort) {
  command <- ""
  filename <- "results/"

  if (language == "java") {
    command <- "java -cp Java Main"
    filename <- paste(filename, "java", sep="")
  } else if (language == "c") {
    command <- "./C/a.out"
    filename <- paste(filename, "c", sep="")
  } else if (language == "python") {
    command <- "python3 Python/main.py"
    filename <- paste(filename, "python", sep="")
  } else {
    stop(paste("Not a supported language:", language))
  }

  if (data == 1) {
    command <- paste(command, "indata/data1.txt output.csv")
    filename <- paste(filename, "data1", sep="_")
  } else if (data == 2) {
    command <- paste(command, "indata/data2.txt output.csv")
    filename <- paste(filename, "data2", sep="_")
  } else if (data == 3) {
    command <- paste(command, "indata/data3.txt", "output.csv")
    filename <- paste(filename, "data3", sep="_")
  } else {
    stop(paste("Not supported data:", data))
  }

  if (quicksort) {
    command <- paste(command, "true")
    filename <- paste(filename, "quicksort", sep="_")
  } else {
    command <- paste(command, "true")
    filename <- paste(filename, "builtin", sep="_")
  }

  c(command, filename)
}


create_graph <- function(language, data, quicksort) {
  command_and_filename <- get_command_and_filename(language, data, quicksort)
  command <- command_and_filename[1]
  filename <- command_and_filename[2]

  system(command)
  pdf(paste(filename, ".pdf", sep=""))
  plot_result("output.csv", CUT_OFF)
  dev.off()
  file.remove("output.csv")
}


calculate_mean <- function(language, data, quicksort) {
  command_and_filename <- get_command_and_filename(language, data, quicksort)
  command <- command_and_filename[1]
  filename <- command_and_filename[2]

  mean_runs <- c()
  for (i in 1:100) {
    system(command)
    mean_runs <- append(mean_runs, mean_result("output.csv", CUT_OFF))
    file.remove("output.csv")
  }

  sink(paste(filename, ".txt", sep=""))
  print("Mean 100 runs:")
  print(mean(mean_runs))

  print("Confidence interval 100 runs (95%):")
  print(confidence_interval(mean_runs))
  sink()
}


# Where the magic happens
for (lang in c("java", "c", "python")) {
  for (data in 1:3) {
    for (quick in c(TRUE, FALSE)) {
      create_graph(lang, data, quick)
      calculate_mean(lang, data, quick)
    }
  }
}
