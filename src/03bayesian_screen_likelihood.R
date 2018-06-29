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
#test predictions (not used, just checking)
dermal_af = 0.5
sd = 2
pred = (app_rate * conv_rate * sa_amphib_hutchinson * sa_tim_default_frac * dermal_af)/body_weight
# View(cbind(app_rate,tissue_conc,pred))
# plot(pred,tissue_conc)
singlelikelihoods = dnorm(tissue_conc, mean = pred, sd = sd, log = T)
sumll = sum(singlelikelihoods)
sumll
####


# likelihood
# derive the likelihood function given the data that we have
# the likelihood is the probability (density) with which we would expect the 
# observed data to occur conditional on the parameters of the model that we look at
likelihood <- function(param){
  dermal_af = param[1]
  sd = param[2]
  
  # pred = a*x + b
  pred = (app_rate * conv_rate * sa_amphib_hutchinson * sa_tim_default_frac * dermal_af)/body_weight
  # the probability of obtaining the test data above under this model
  # we simply calculate the difference between predictions the predicted y and 
  # the observed y, and then we have to look up the probability densities (using dnorm) 
  # for such deviations to occur
  singlelikelihoods = dnorm(tissue_conc, mean = pred, sd = sd, log = T)
  # sum the likelihoods across all the obeserved differences
  # we sum the logs as convention to avoid numerical issues, etc.
  sumll = sum(singlelikelihoods)
  return(sumll)   
}

# prior
# specify our prior distribution for the dermal factor
# and for the standard deviation
prior <- function(param){
  a = param[1]
  sd = param[2]
  aprior = dunif(a, min=0, max=4, log = T)
  sdprior = dunif(sd, min=0, max=10, log = T)
  return(aprior+sdprior)
}

#posterior
# the posterior is the product of the prior (2) and the likelihood
posterior <- function(param){
  return (likelihood(param) + prior(param))
}

#proposal 
# draw from our priors for the next likelihood
proposalfunction <- function(param){
  return(rnorm(2,mean = param, sd= c(0.1,0.3)))
}

#metropolis
run_metropolis_MCMC <- function(startvalue, iterations){
  chain = array(dim = c(iterations+1,3))
  chain[1,1:2] = startvalue
  for (i in 1:iterations){
    proposal = proposalfunction(chain[i,1:2])
    
    probab = exp(posterior(proposal) - posterior(chain[i,1:2]))
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
chain = run_metropolis_MCMC(startvalue, iterations)
dim(chain)
summary(chain)
burnIn = 50000
acceptance = 1-mean(duplicated(chain[-(1:burnIn),1:2]))
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
