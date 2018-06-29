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
dermal_af = 0.5
sd = 2

# loop aggregated exposure factor
dermal_af <- seq(0,2,by=0.01)
n_loop <- length(dermal_af)
n_frogs <- length(tissue_conc)
fail_rate <- vector(mode = "numeric", length = n_loop)

for(i in 1:n_loop){
  pred = (app_rate * conv_rate * sa_amphib_hutchinson * sa_tim_default_frac * dermal_af[i])/body_weight
  # View(cbind(pred,tissue_conc))
  fail_rate[i] <- sum(pred<tissue_conc)/n_frogs
}

# this is fine but doesn't deal with dependencies inherent
# in the species and chemicals that we selected
par(mfrow=c(1,1))
plot(dermal_af,fail_rate)
