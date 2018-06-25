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
View(cbind(app_rate,tissue_conc,pred))
plot(pred,tissue_conc)
singlelikelihoods = dnorm(tissue_conc, mean = pred, sd = sd, log = T)
sumll = sum(singlelikelihoods)
sumll
####

# likelihood
likelihood <- function(param){
  dermal_af = param[1]
  sd = param[2]
  
  # pred = a*x + b
  pred = (app_rate * conv_rate * sa_amphib_hutchinson * sa_tim_default_frac * dermal_af)/body_weight
  n_under <- sum(pred<tissue_conc)
  n_justright <- sum(tissue_conc < pred & pred < tissue_conc*1000)
  n_over <- sum(pred>tissue_conc*1000)
  singlelikelihoods = n_justright/n
  sumll = sum(singlelikelihoods)
  return(sumll)   
}

# likelihood
likelihood_trinomial <- function(param){
  dermal_af = param[1]
  sd = param[2]
  
  # pred = a*x + b
  pred = (app_rate * conv_rate * sa_amphib_hutchinson * sa_tim_default_frac * dermal_af)/body_weight
  singlelikelihoods = dnorm(tissue_conc, mean = pred, sd = sd, log = T)
  sumll = sum(singlelikelihoods)
  return(sumll)   
}

# prior
prior <- function(param){
  a = param[1]
  sd = param[2]
  aprior = dunif(a, min=0, max=4, log = T)
  sdprior = dunif(sd, min=0, max=10, log = T)
  return(aprior+sdprior)
}

#posterior
posterior <- function(param){
  return (likelihood(param) + prior(param))
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
run_metropolis_MCMC <- function(startvalue, iterations){
  chain = array(dim = c(iterations+1,2))
  chain[1,] = startvalue
  for (i in 1:iterations){
    proposal = proposalfunction(chain[i,])
    
    probab = exp(posterior(proposal) - posterior(chain[i,]))
    if (runif(1) < probab){
      chain[i+1,] = proposal
    }else{
      chain[i+1,] = chain[i,]
    }
  }
  return(chain)
}

#metropolis
run_metropolis_MCMC_trinomial <- function(startvalue, iterations){
  chain = array(dim = c(iterations+1,2))
  chain[1,] = startvalue
  for (i in 1:iterations){
    proposal = proposalfunction(chain[i,])
    
    probab = exp(posterior_trinomial(proposal) - posterior_trinomial(chain[i,]))
    if (runif(1) < probab){
      chain[i+1,] = proposal
    }else{
      chain[i+1,] = chain[i,]
    }
  }
  return(chain)
}

# run the mcmc
startvalue = c(1,2)
# chain = run_metropolis_MCMC(startvalue, 500000)
chain = run_metropolis_MCMC_trinomial(startvalue, 500000)
dim(chain)
summary(chain)
burnIn = 5000
acceptance = 1-mean(duplicated(chain[-(1:burnIn),]))
acceptance

par(mfrow = c(2,2))
hist(chain[-(1:burnIn),1],nclass=30, , main="Posterior of dermal_af", xlab="")
abline(v = mean(chain[-(1:burnIn),1]), col="red")
hist(chain[-(1:burnIn),2],nclass=30, main="Posterior of sd", xlab="")
abline(v = mean(chain[-(1:burnIn),2]), col="red" )
plot(chain[-(1:burnIn),1], type = "l", xlab="Step #" , ylab = "Parameter", main = "Chain values of dermal_af", )
abline(h = mean(chain[-(1:burnIn),1]), col="red" )
plot(chain[-(1:burnIn),2], type = "l", xlab="Step #" , ylab = "Parameter", main = "Chain values of sd", )
abline(h = mean(chain[-(1:burnIn),2]), col="red" )

# for comparison:
summary(lm(y~x))
