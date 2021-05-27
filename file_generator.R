library(svMisc)
library(multiplex)
library(doParallel)
cl <- makeCluster(parallel::detectCores()-1) # generate file in parallel
registerDoParallel(cl)

# Without treatment effect
foreach (i=1:1000,.packages = c("multiplex","reshape2")) %dopar% {
  sim <- function(a, b, c, n, t = 1:12) {
  lambda = a + 0.5 * b * t - 0.05 * c * t
  group <- matrix(rep(0, n * 12), ncol = 12)
  for (i in 1:ncol(group)) {
    group[, i] = rexp(n, rate = lambda[i])
  }
  return(cbind(group, rep(a, n), rep(b, n), rep(c, n)))
}
# Constant low Group
group1 <- sim(a = 2,
                b = 0,
                c = 0,
                n = 3000)
  
# Increasing Group
group2 <- sim(a = 1,
                b = 0,
                c = 1,
                n = 1000)
  
# Decreasing Group
group3 <- sim(a = 0,
                b = 1,
                c = 0,
                n = 1000)

dart <- as.data.frame(cbind(1:5000, rbind(group1, group2, group3)))
dart[,2:13] <- round(dart[,2:13])
dart[,2:13] <- apply(dart[,2:13], c(1,2),function(x) min(x,10))
dart[,2:13] <- apply(dart[,2:13], c(1,2),function(x) max(x,0))
colnames(dart) <- c("id", 1:12, "cova", 'covb', 'covc')
dart_long <- melt(data = dart,id.vars = c('id', 'cova', 'covb', 'covc'))
dart <- cbind.data.frame(dart, as.data.frame(matrix(rep(1:12,5000),byrow = T, nrow = 5000)))
write.dat(dart, paste0("~/dart",i)) # Mplus format
write.csv(dart, file = paste0('~/dart',i,".csv")) # SAS format
save(dart_long, file = paste0('~/dart',i,".RData")) # R format
}
stopCluster(cl)

# Since Mplus can have a maxium of 10 levels, we need to convert original scale to categories for Mplus
cl <- makeCluster(7)
registerDoParallel(cl)
foreach (i=1:1000) %dopar% {
dat <- read.table(file = paste0("~/dart",i,".dat"))
for(s in 1:nrow(dat)){
  for(j in 2:13){
    if(dat[s,j] <= 3){dat[s,j]=0} else if(dat[s,j] <= 7){dat[s,j]=1} else{dat[s,j]=2}
  }
}
write.table(dat,file = paste0("~/dart",i,".dat"),quote = F,row.names = F,col.names = F,sep = "\t")}
stopCluster(cl)

# With treatment effect added
foreach (i=1:1000,.packages = c("multiplex","reshape2")) %dopar% {
  sim <- function(a, b, c, n, t = 1:12) {
    treatmenttime = stats::rnbinom(1,size = 1,prob = 0.5)+1
    treatmenteffect = 0.2 
    lambda = ifelse(t < treatmenttime,a + 0.01 * b * t - 0.02 * c * t,a + 0.01 * b * t - 0.02 * c * t+treatmenteffect)
    group <- matrix(rep(0, n * 12), ncol = 12)
    for (i in 1:ncol(group)) {
      group[, i] = rexp(n, rate = lambda[i])+rnorm(n)
    }
    return(cbind(group, rep(a, n), rep(b, n), rep(c, n)))
  }
# Constant low Group
group1 <- sim(a = 0.2,
                b = 0,
                c = 0,
                n = 3000)
  
# Increasing Group
group2 <- sim(a = 0.3,
                b = 0,
                c = 1,
                n = 1000)
  
# Decreasing Group
group3 <- sim(a = 0.15,
                b = 1,
                c = 0,
                n = 1000)

dart <- as.data.frame(cbind(1:5000, rbind(group1, group2, group3)))
dart[,2:13] <- round(dart[,2:13])
dart[,2:13] <- apply(dart[,2:13], c(1,2),function(x) min(x,10))
dart[,2:13] <- apply(dart[,2:13], c(1,2),function(x) max(x,0))
colnames(dart) <- c("id", 1:12, "cova", 'covb', 'covc')
dart_long <- melt(data = dart,id.vars = c('id', 'cova', 'covb', 'covc'))
dart <- cbind.data.frame(dart, as.data.frame(matrix(rep(1:12,5000),byrow = T, nrow = 5000)))
write.dat(dart, paste0("~/dart_tr",i)) # Mplus format
write.csv(dart, file = paste0('~/dart_tr',i,".csv")) # SAS format
save(dart_long, file = paste0('~/dart_tr',i,".RData")) # R format
}
stopCluster(cl)

# Since Mplus can have a maxium of 10 levels, we need to convert original scale to categories for Mplus
cl <- makeCluster(7)
registerDoParallel(cl)
foreach (i=1:1000) %dopar% {
dat <- read.table(file = paste0("~/dart_tr",i,".dat"))
for(s in 1:nrow(dat)){
  for(j in 2:13){
    if(dat[s,j] <= 3){dat[s,j]=0} else if(dat[s,j] <= 7){dat[s,j]=1} else{dat[s,j]=2}
  }
}
write.table(dat,file = paste0("~/dart_tr",i,".dat"),quote = F,row.names = F,col.names = F,sep = "\t")}
stopCluster(cl)
