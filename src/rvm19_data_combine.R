library('dplyr')

r19al <- read_csv("data_in/rvm2019_alachlor.csv", skip = 1)
r19at <- read_csv("data_in/rvm2019_atrazine.csv")
runal <- read_csv("data_in/rvmunpub_alachlor.csv")
runat <- read_csv("data_in/rvmunpub_atrazine.csv")
#lab<-lab[,c(2:13)]

#no need to convert ppm to ug/g
#need to get appliation rates from van meter 2019
#need to clarify that the application rate is soil
#need to note that body weight is not available in raw data, ask
# exp_duration is 8 hours
# species is southern leopard frog
# body weight is NA (for now)
# app rate for atrazine: 23.6 ug/cm2, for alachlor: 34.8 ug/cm2 - 1000000 conversion factor

## rvm19
r19al<-na.omit(r19al)
r19at<-na.omit(r19at)
r19al<-r19al[,c(1,6)]
r19at<-r19at[,c(1,6)]
r19al$chemical<-'alachlor'
r19at$chemical<-'atrazine'
r19al$app_rate_g_cm2<-(34.8/1000000)
r19at$app_rate_g_cm2<-(23.6/1000000)

r19<-rbind(r19al,r19at)
names(r19)

colnames(r19)[1]<-'sample_id'
colnames(r19)[2]<-'tissue_conc_ugg'
r19$application<-'soil'
r19$body_weight_g<-NA
r19$exp_duration<-8
r19$formulation<-0
r19$species<-'Southern Leopard Frog'
r19$soil_type<-NA
r19$source<-'rvm2019'
r19$soil_conc_ugg<-NA


r19<-r19[c("app_rate_g_cm2" ,"application", "body_weight_g","chemical","exp_duration","formulation",
         "sample_id", "soil_conc_ugg", "soil_type","source", "species","tissue_conc_ugg")]

##rvm unpub
runal<-na.omit(runal)
runat<-na.omit(runat)
runal<-runal[,c(1,5,6)]
runat<-runat[,c(1,5,6)]
runal$chemical<-'alachlor'
runat$chemical<-'atrazine'
runal$app_rate_g_cm2<-(34.8/1000000)
runat$app_rate_g_cm2<-(23.6/1000000)

run<-rbind(runal,runat)
names(run)

colnames(run)[1]<-'sample_id'
colnames(run)[2]<-'tissue_conc_ugg'
colnames(run)[3]<-'soil_conc_ugg'
run$application<-'soil'
run$body_weight_g<-NA
run$exp_duration<-8
run$formulation<-0
run$species<-'Southern Leopard Frog'
run$soil_type<-NA
run$source<-'rvmunpub'


run<-run[c("app_rate_g_cm2" ,"application", "body_weight_g","chemical","exp_duration","formulation",
           "sample_id", "soil_conc_ugg", "soil_type","source", "species","tissue_conc_ugg")]

add_lab<-rbind(r19,run)

updated_amphib_dermal_collated<-rbind(lab,add_lab)
write.csv(updated_amphib_dermal_collated,"data_out/updated_amphib_dermal_collated.csv")
