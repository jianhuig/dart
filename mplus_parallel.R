library(MplusAutomation)
library(texreg)
library(doParallel)

createModels("model.txt")

num_of_class = "dart.inp" # can be changed to dart_tr.out

file <- list.files(pattern=num_of_class, full.name=T)

cl <- makeCluster(parallel::detectCores()-1)
registerDoParallel(cl)
time_elapsed <- foreach(i=file,.packages = c("MplusAutomation"),.combine = "rbind") %dopar%{
   runModels(i)
}
stopCluster(cl) 

num_of_class = "dart.out" # can be changed to dart_tr.out
files <- list.files(pattern=num_of_class, full.name=T)

result <- readModels('dart_n4.out',quiet = TRUE,recursive = T) #n_4 can be changed as desired
SummaryTable(result)


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
