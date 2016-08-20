library("monkeylearn")
library("dplyr")
load("data/parsed_first7jobs.RData")
request <- c(first7jobs_parsed$wordsgroup)
# classify with Job Roles Classifier
# https://app.monkeylearn.com/main/classifiers/cl_i7vMzUB7/
output <- monkeylearn_classify(request,
                               classifier_id = "cl_i7vMzUB7")
dim(output)
save(output, file = "data/output.RData")
