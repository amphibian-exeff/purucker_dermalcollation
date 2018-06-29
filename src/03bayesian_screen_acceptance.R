# import data 
combined_data_filename <- paste(amphibdir_data_out,"amphib_dermal_collated.csv", sep="")
combined_data <- read.csv(combined_data_filename)
dim(combined_data)
colnames(combined_data)
# delete 593:601 -- check application units
combined_data_drops <- combined_data[-(593:601),]
dim(combined_data_drops)

# initialize
n <- length(combined_data_drops$tissue_conc_ugg)
app_rate <- combined_data_drops$app_rate_g_cm2
body_weight <- combined_data_drops$body_weight_g
summary(body_weight)
#observed tissue concs
tissue_conc <- combined_data_drops$tissue_conc_ugg
conv_rate <- 1000000.0
sa_tim_default_frac <- 0.5
sa_amphib_hutchinson <- 1.131 * (body_weight ^ 0.579)

###
#test acceptance ratios (not used, just checking)
dermal_af = 0.5
sd = 2
pred = (app_rate * conv_rate * sa_amphib_hutchinson * sa_tim_default_frac * dermal_af)/body_weight
#View(cbind(app_rate,tissue_conc,pred))
plot(pred,tissue_conc)
n_under <- sum(pred<tissue_conc)
n_justright <- sum(tissue_conc < pred & pred < tissue_conc*1000)
n_over <- sum(pred>tissue_conc*1000)
singlelikelihoods = n_justright/n
sumll = sum(singlelikelihoods)
sumll
####


# likelihood
likelihood_trinomial <- function(param){
  dermal_af = param[1]
  sd = param[2]
  
  # pred = a*x + b
  pred = (app_rate * conv_rate * sa_amphib_hutchinson * sa_tim_default_frac * dermal_af)/body_weight
  n_under <- sum(pred<tissue_conc)
  n_justright <- sum(tissue_conc < pred & pred < tissue_conc*10)
  n_over <- sum(pred>tissue_conc*10)
  singlelikelihoods = n_justright/n
  #should not be an array!
  sumll = sum(singlelikelihoods)
  return(sumll)   
}

# prior
prior <- function(param){
  a = param[1]
  sd = param[2]
  aprior = dunif(a, min=0, max=10, log = T)
  sdprior = dunif(sd, min=0, max=10, log = T)
  return(aprior+sdprior)
}

#posterior trinomial
posterior_trinomial <- function(param){
  return (likelihood_trinomial(param) + prior(param))
}

#proposal 
proposalfunction <- function(param){
  return(rnorm(2,mean = param, sd= c(0.1,0.3)))
}

#metropolis
run_metropolis_MCMC_trinomial <- function(startvalue, iterations){
  chain = array(dim = c(iterations+1,3))
  chain[1,1:2] = startvalue
  for (i in 1:iterations){
    proposal = proposalfunction(chain[i,1:2])
    
    probab = exp(posterior_trinomial(proposal) - posterior_trinomial(chain[i,1:2]))
    if (runif(1) < probab){
      chain[i+1,1:2] = proposal
    }else{
      chain[i+1,1:2] = chain[i,1:2]
    }
    chain[i+1,3] <- probab
  }
  return(chain)
}

# run the mcmc
startvalue = c(1,2)
iterations = 100000
# chain = run_metropolis_MCMC(startvalue, 500000)
chain = run_metropolis_MCMC_trinomial(startvalue, iterations)
View(chain)
dim(chain)
head(chain)
colnames(chain)
summary(chain)
burnIn = 50000
acceptance = 1-mean(duplicated(chain[-(1:burnIn),]))
acceptance
chain_burnfree <- chain[-(1:burnIn),]
chain_burnfree[which(chain_burnfree[,3]>1),3] <- 1

par(mfrow = c(2,3))
hist(chain_burnfree[,1],nclass=30, , main="Posterior of dermal_af", xlab="")
abline(v = mean(chain_burnfree[,1]), col="red")
hist(chain_burnfree[,2],nclass=30, main="Posterior of sd", xlab="")
abline(v = mean(chain_burnfree[,2]), col="red" )
hist(chain_burnfree[,3],nclass=30, main="probs", xlab="")
abline(v = mean(chain_burnfree[,3]), col="red" )
plot(chain_burnfree[,1], type = "l", xlab="Step #" , ylab = "Parameter", main = "Chain values of dermal_af", )
abline(h = mean(chain_burnfree[,1]), col="red" )
plot(chain_burnfree[,2], type = "l", xlab="Step #" , ylab = "Parameter", main = "Chain values of sd", )
abline(h = mean(chain_burnfree[,2]), col="red" )
plot(chain_burnfree[,3], type = "l", xlab="Step #" , ylab = "Parameter", main = "probs trace", )
abline(h = mean(chain_burnfree[,3]), col="red" )

# for comparison:
# summary(lm(y~x))
