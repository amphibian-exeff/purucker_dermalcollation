library(dplyr)
library(tidyr)

amphibdir <- path.expand("C:/Users/epauluko/OneDrive - Environmental Protection Agency (EPA)/Profile/Documents/GitHub/amphib_dermal_collation/")
amphibdir_data_in <- paste(amphibdir,'data_in/',sep='')
amphibdir_data_out <- paste(amphibdir,'data_out/',sep='')
amphibdir_graphics <- paste(amphibdir,'graphics/',sep='')
amphibdir_src <- paste(amphibdir,'src/',sep='')

r19al <- file.path(amphibdir,"data_in/rvm2019_alachlor.csv")
r19al <-read.csv(r19al)
r19at <- file.path(amphibdir,"data_in/rvm2019_atrazine.csv")
r19at <-read.csv(r19at)
r19al$app_rate_g_cm2<-(34.8/1000000)
r19at$app_rate_g_cm2<-(23.6/1000000)
r19al$chemical<-'alachlor'
r19at$chemical<-'atrazine'
r19<-rbind(r19al,r19at)

runal <- file.path(amphibdir, "data_in/rvmunpub_alachlor.csv")
runal<-read.csv(runal)
runat <- file.path(amphibdir, "data_in/rvmunpub_atrazine.csv")
runat <- read.csv(runat)
runal$chemical<-'alachlor'
runat$chemical<-'atrazine'
runal$app_rate_g_cm2<-(34.8/1000000)
runat$app_rate_g_cm2<-(23.6/1000000)
run<-rbind(runal,runat)

bw <- file.path(amphibdir, "data_in/bw_RVM.csv")
bw <- read.csv(bw)
lab <- file.path(amphibdir,"data_out/amphib_dermal_collated.csv")
lab  <- read.csv(lab)

lab<-lab[,c(2:13)]


#no need to convert ppm to ug/g
#need to get appliation rates from van meter 2019
#need to clarify that the application rate is soil
#need to note that body weight is not available in raw data, ask
# exp_duration is 8 hours
# species is southern leopard frog
# body weight is NA (for now)
# app rate for atrazine: 23.6 ug/cm2, for alachlor: 34.8 ug/cm2 - 1000000 conversion factor
##add in BW, soil info

#soil is Unicorn Sassafras Loam for both rvm
#body weights match to ID



## rvm19
r19$bw<-bw[match(r19$ID, bw$Frog.ID),5]
r19<-na.omit(r19)

colnames(r19)[1]<-'sample_id'
colnames(r19)[6]<-'tissue_conc_ugg'
colnames(r19)[10]<-'body_weight_g'
r19$application<-'soil'
r19$exp_duration<-8
r19$formulation<-0
r19$species<-'Southern Leopard Frog'
r19$soil_type<-'USLOAM'
r19$source<-'rvm2019'
r19$soil_conc_ugg<-r19$tissue_conc_ugg/r19$BCF

r19<-r19[c("app_rate_g_cm2" ,"application", "body_weight_g","chemical","exp_duration","formulation",
         "sample_id", "soil_conc_ugg", "soil_type","source", "species","tissue_conc_ugg")]

##rvm unpub
run$bw<-bw[match(run$ID, bw$Frog.ID),5]
run<-na.omit(run)

colnames(run)[1]<-'sample_id'
colnames(run)[5]<-'tissue_conc_ugg'
colnames(run)[6]<-'soil_conc_ugg'
colnames(run)[10]<-'body_weight_g'
run$application<-'soil'
run$exp_duration<-8
run$formulation<-0
run$species<-'Southern Leopard Frog'
run$soil_type<-'USLoam'
run$source<-'rvmunpub'


run<-run[c("app_rate_g_cm2" ,"application", "body_weight_g","chemical","exp_duration","formulation",
           "sample_id", "soil_conc_ugg", "soil_type","source", "species","tissue_conc_ugg")]

#rvm19 <-rbind(r19, run)

rvm2019 <- file.path(amphibdir,"data_in/rvm2019.csv")
write.csv(r19, rvm2019)


rvm2021 <- file.path(amphibdir,"data_in/rvm2021.csv")
write.csv(run, rvm2021)


# updated_amphib_dermal_collated<-rbind(lab,add_lab)
# write.csv(updated_amphib_dermal_collated,"data_out/updated_amphib_dermal_collated.csv")
