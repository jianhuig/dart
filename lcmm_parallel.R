library(doParallel)
library(data.table)
library(Rmpi)
cl <- makeCluster(type="MPI")
registerDoParallel(cl)
files <- list.files(pattern = ".RData$",full.names=TRUE)
result <- foreach(.packages = c("lcmm"),i = files,.export='fread',.errorhandling='pass') %dopar%{
  load(i)
  start_time <- Sys.time()
  model <-
    lcmm(
      value ~ variable,
      mixture ~ variable,
      subject = 'id',
      data = dat_long,
      link = 'thresholds',
      classmb = ~cova+covb+covc,
      ng = 3 # can be changed accordingly 
    )
  end_time <- Sys.time()
  return(c(end_time - start_time, model$BIC))
}
stopCluster(cl)

