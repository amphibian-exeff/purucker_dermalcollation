### Table 1 Updates 7.12.21
library(dplyr)
library(tidyr)

amphibdir <- path.expand("C:/Users/epauluko/OneDrive - Environmental Protection Agency (EPA)/Profile/Documents/GitHub/amphib_dermal_collation/")
amphibdir_data_in <- paste(amphibdir,'data_in/',sep='')
amphibdir_data_out <- paste(amphibdir,'data_out/',sep='')
amphibdir_graphics <- paste(amphibdir,'graphics/',sep='')
amphibdir_src <- paste(amphibdir,'src/',sep='')

#rvm 2014/2015 get read in via vm2014 just to double check that they are partitioned correctly
#all other files get directed from the amphib dermal collated csv, BCF calculated
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
