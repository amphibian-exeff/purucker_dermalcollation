### Table 1 Updates 7.12.21
library(dplyr)
library(tidyr)

amphibdir <- path.expand("C:/Users/epauluko/OneDrive - Environmental Protection Agency (EPA)/Profile/Documents/GitHub/amphib_dermal_collation/")
amphibdir_data_in <- paste(amphibdir,'data_in/',sep='')
amphibdir_data_out <- paste(amphibdir,'data_out/',sep='')
amphibdir_graphics <- paste(amphibdir,'graphics/',sep='')
amphibdir_src <- paste(amphibdir,'src/',sep='')


##RVM 2014/2015 ----
vm2015_file <- paste(amphibdir_data_in,"vm2014_data.csv", sep="")
file.exists(vm2015_file)
vm2015 <- read.table(vm2015_file, header = TRUE, sep = ",")

vm_2014_atr<-filter(vm2015, Chemical== 'Atrazine' & Application == 'Soil') 
calc_2014<-vm2015 %>% 
  filter(Application == 'Soil') %>%
  group_by(Chemical, Species) %>% 
  summarise(min = min(BCF), max = max(BCF), avg = mean(BCF), )

