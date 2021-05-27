library(MplusAutomation)
library(texreg)
library(doParallel)

createModels("model.txt")

num_of_class = "depression.inp"

file <- list.files(pattern=num_of_class, full.name=T)

cl <- makeCluster(parallel::detectCores()-1)
registerDoParallel(cl)
time_elapsed <- foreach(i=file,.packages = c("MplusAutomation"),.combine = "rbind") %dopar%{
   runModels(i)
}
stopCluster(cl) 

num_of_class = "depression.out"
files <- list.files(pattern=num_of_class, full.name=T)

result <- readModels('dartfull_n4_depression.out',quiet = TRUE,recursive = T) #n_4 can be changed as desired
SummaryTable(result)
cl <- makeCluster(parallel::detectCores()-1)
registerDoParallel(cl)
results <- foreach(i = files,.packages = c("MplusAutomation"),.combine = "rbind") %dopar%{
  temp <- readModels(i,quiet = TRUE)
  c(SummaryTable(temp)$'BIC')}
stopCluster(cl)
mean(results)

for(i in results){
  entropy<-c(entropy,i$summaries$Entropy)
}
mean(entropy)
mean(time_elapsed)


Mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}
file <- list.files(pattern='N4_prob.txt', full.name=T) #N_4 can be changed as desired

cl <- makeCluster(parallel::detectCores()-1)
registerDoParallel(cl)
pclassification <- foreach(i = file,.combine = 'rbind') %dopar% {
  postclass = read.table(i)
  c(sum(postclass[1:3000,]$V19==Mode(postclass[1:3000,]$V19))/3000,
    sum(postclass[3001:4000,]$V19==Mode(postclass[3001:4000,]$V19))/1000,
    sum(postclass[4001:5000,]$V19==Mode(postclass[4001:5000,]$V19))/1000)
}
stopCluster(cl)
apply(pclassification, 2, mean)
