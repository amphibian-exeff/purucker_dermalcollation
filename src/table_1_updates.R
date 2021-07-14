### Table 1 Updates 7.12.21
library(dplyr)
library(tidyr)

amphibdir <- path.expand("C:/Users/epauluko/OneDrive - Environmental Protection Agency (EPA)/Profile/Documents/GitHub/amphib_dermal_collation/")
amphibdir_data_in <- paste(amphibdir,'data_in/',sep='')
amphibdir_data_out <- paste(amphibdir,'data_out/',sep='')
amphibdir_graphics <- paste(amphibdir,'graphics/',sep='')
amphibdir_src <- paste(amphibdir,'src/',sep='')

#read in primary derm file; note that some files will need to be uploaded from their raw dataset
all_derm_file <- paste(amphibdir_data_out,"updated_amphib_dermal_collated.csv", sep="")
file.exists(all_derm_file)
derm <- read.table(all_derm_file, header = TRUE, sep = ",")
names(derm)
derm$BCF<-derm$tissue_conc_ugg/derm$soil_conc_ugg

##RVM 2014/2015 ----
vm2015_file <- paste(amphibdir_data_in,"vm2014_data.csv", sep="")
file.exists(vm2015_file)
vm2015 <- read.table(vm2015_file, header = TRUE, sep = ",")

#2014
calc_2014<-vm2015 %>% 
  filter(Application == 'Soil') %>%
  group_by(Chemical, Species) %>% 
  summarise(min = round(min(BCF),3), max = round(max(BCF),3), avg = round(mean(BCF),3))

new_2014 <- calc_2014 %>%  unite(vals, min:avg, sep=", ")
vm_2014_sum <- file.path(amphibdir,"data_in/vm2014_data_summarized.csv")
write.csv(new_2014, vm_2014_sum)

#2015
calc_2015<-vm2015 %>% 
  filter(Application == 'Overspray') %>%
  group_by(Chemical, Species) %>% 
  summarise(min = round(min(BCF),3), max = round(max(BCF),3), avg = round(mean(BCF),3))

new_2015 <- calc_2015 %>%  unite(vals, min:avg, sep=", ")
vm_2015_sum <- file.path(amphibdir,"data_in/vm2015_data_summarized.csv")
write.csv(new_2015, vm_2015_sum)



##RVM 2016 ----
rvm2016<-filter(derm, source== 'rvm2016') 
calc_rvm2016<-rvm2016 %>% 
  group_by(chemical, species) %>% 
  summarise(min = round(min(BCF),3), max = round(max(BCF),3), avg = round(mean(BCF),3))

rvm_2016 <- calc_rvm2016 %>%  unite(vals, min:avg, sep=", ")
rvm_2016_sum <- file.path(amphibdir,"data_in/vm2016_data_summarized.csv")
write.csv(rvm_2016, rvm_2016_sum)

##RVM 2018----
r181 <- file.path(amphibdir,"data_in/rvm2018_hif.csv")
r181 <-read.csv(r181)
r182 <- file.path(amphibdir,"data_in/rvm2018_herbs.csv")
r182 <-read.csv(r182)
r18 <- file.path(amphibdir,"data_in/vm2017_merge.csv")
r18 <-read.csv(r18)

names(r182)
r181<-r181[,c(7,10,11)]
r182<-r182[,c(10,11, 12)]

r18_c<-rbind(r181,r182)
colnames(r18_c)[1]<-'tissue_conc_ugg'

rvm18<-dplyr::inner_join(r18, r18_c, by = c("tissue_conc_ugg", "sample_id"))
rvm18<-rvm18[!duplicated(rvm18), ]
rvm2018 <- file.path(amphibdir,"data_in/rvm2018.csv")
write.csv(rvm18, rvm2018)

rvm18$BCF<-rvm18$tissue_conc_ugg/rvm18$soil
calc_rvm18<-rvm18 %>% 
  group_by(chemical, species) %>% 
  summarise(min = round(min(BCF),3), max = round(max(BCF),3), avg = round(mean(BCF),3))

rvm18 <- calc_rvm18 %>%  unite(vals, min:avg, sep=", ")
rvm_2018_sum <- file.path(amphibdir,"data_in/rvm2018_data_summarized.csv")
write.csv(rvm18, rvm_2018_sum)


##RVM 2019 ----
r19al <- file.path(amphibdir,"data_in/rvm2019_alachlor.csv")
r19al <-read.csv(r19al)
r19at <- file.path(amphibdir,"data_in/rvm2019_atrazine.csv")
r19at <-read.csv(r19at)
r19at<-na.omit(r19at)

rvm19_1<-r19al %>% summarise(min = round(min(BCF),3), max = round(max(BCF),3), avg = round(mean(BCF),3))
rvm19_2<-r19at %>% summarise(min = round(min(BCF),3), max = round(max(BCF),3), avg = round(mean(BCF),3))

rvm_20191 <- rvm19_1 %>%  unite(vals, min:avg, sep=", ") #just left as is, easy to copy and paste
rvm_20192 <- rvm19_2 %>%  unite(vals, min:avg, sep=", ") #just left as is, easy to copy and paste

##RVM 2021----
runal <- file.path(amphibdir, "data_in/rvmunpub_alachlor.csv")
runal<-read.csv(runal)
runat <- file.path(amphibdir, "data_in/rvmunpub_atrazine.csv")
runat <- read.csv(runat)

rvm21_1<-runal %>% summarise(min = round(min(BCF),3), max = round(max(BCF),3), avg = round(mean(BCF),3))
rvm21_2<-runat %>% summarise(min = round(min(BCF),3), max = round(max(BCF),3), avg = round(mean(BCF),3))

rvm_20211 <- rvm21_1 %>%  unite(vals, min:avg, sep=", ")
rvm_20212 <- rvm21_2 %>%  unite(vals, min:avg, sep=", ")

##DAG 2018a----
dag2018a<-filter(derm, source== 'dag_dehydration') 
dag2018a$BCF<-dag2018a$tissue_conc_ugg/dag2018a$soil_conc_ugg
calc_dag2018a<-dag2018a %>% 
  group_by(chemical, species) %>% 
  summarise(min = round(min(BCF),3), max = round(max(BCF),3), avg = round(mean(BCF),3))

dag_2018a <- calc_dag2018a %>%  unite(vals, min:avg, sep=", ")
dag_2018a_sum <- file.path(amphibdir,"data_in/dag2018a_data_summarized.csv")
write.csv(dag_2018a, dag_2018a_sum)

##DAG 2018b----
dag2018b<-filter(derm, source== 'dag_metabolites') 
dag2018b$BCF<-dag2018b$tissue_conc_ugg/dag2018b$soil_conc_ugg
calc_dag2018b<-dag2018b %>% 
  group_by(chemical, species) %>% 
  summarise(min = round(min(BCF),3), max = round(max(BCF),3), avg = round(mean(BCF),3))

dag_2018b <- calc_dag2018b %>%  unite(vals, min:avg, sep=", ")
dag_2018b_sum <- file.path(amphibdir,"data_in/dag2018b_data_summarized.csv")
write.csv(dag_2018b, dag_2018b_sum)


unique(derm$source)
##DAG 2019----
dag2019<-filter(derm, source== 'dag_biomarker') 
dag2019$BCF<-dag2019$tissue_conc_ugg/dag2019$soil_conc_ugg
calc_dag2019<-dag2019 %>% 
  group_by(chemical, species) %>% 
  summarise(min = round(min(BCF),3), max = round(max(BCF),3), avg = round(mean(BCF),3))

dag_2019 <- calc_dag2019 %>%  unite(vals, min:avg, sep=", ")
dag_2019_sum <- file.path(amphibdir,"data_in/dag2019_data_summarized.csv")
write.csv(dag_2019, dag_2019_sum)

##DAG 2020----
dag2020<-filter(derm, source== 'dag_dermal_routes') 
dag2020$BCF<-dag2020$tissue_conc_ugg/dag2020$soil_conc_ugg
calc_dag2020<-dag2020 %>% 
  group_by(chemical, species) %>% 
  summarise(min = round(min(BCF),3), max = round(max(BCF),3), avg = round(mean(BCF),3))

dag_2020 <- calc_dag2020 %>%  unite(vals, min:avg, sep=", ")
dag_2020_sum <- file.path(amphibdir,"data_in/dag2020_data_summarized.csv")
write.csv(dag_2020, dag_2020_sum)
