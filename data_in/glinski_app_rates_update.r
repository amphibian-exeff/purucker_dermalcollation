# -------------------------------------------------------------------
# Compute Glinski application rates
# -------------------------------------------------------------------


#the conversion to calculate the application rate would be for bifenthrin (density of 1.3 g/cm3):
#  (50 ml * (1 cm3/1 ml) * (1.3g/cm3)) / (surface area in cm2)



# Glinski Biomarkers ------------------------------------------------
# Surface area of circle = pi*r^2
# 1 bowl surface area = pi*(7.5^2) = 176.7146 cm2
bowl_1_sa <- pi*(7.5^2)
# 8 bowls surface area =  1413.717 cm2
bowl_8_sa <- 8*bowl_1_sa

# Application Rate variables
applied <- 75 #should this actually be 75*8 (multiplied by the number of bowls)
conversion <- 1
density_bif <- 1.3 #g/cm3
density_meto <- 1.1 #g/cm3
density_triad <- 1.22 #g/cm3

# Compute application rate
bio_ar_bif <- (applied * conversion * density_bif) / bowl_8_sa
bio_ar_meto <- (applied * conversion * density_meto) / bowl_8_sa
bio_ar_triad <- (applied * conversion * density_triad) / bowl_8_sa




# Glinski Dehydration -----------------------------------------------
# Surface area of circle = pi*r^2
# 1 bowl surface area = pi*(7.5^2) = 176.7146 cm2
bowl_1_sa <- pi*(7.5^2)
# 6 bowls surface area =  1413.717 cm2
bowl_6_sa <- 6*bowl_1_sa

# Application Rate variables
applied <- 50
conversion <- 1
density_atrazine <- 1.19 #g/cm3
density_chloro <- 1.8 #g/cm3
density_imid <- 1.6 #g/cm3
density_meto <- 1.1 #g/cm3
density_triad <- 1.22 #g/cm3
  

# Compute application rate
dehy_ar_atrazine <- (applied * conversion * density_atrazine) / bowl_6_sa
dehy_ar_chloro <- (applied * conversion * density_chloro) / bowl_6_sa
dehy_ar_imid <- (applied * conversion * density_imid) / bowl_6_sa
dehy_ar_meto <- (applied * conversion * density_meto) / bowl_6_sa
dehy_ar_triad <- (applied * conversion * density_triad) / bowl_6_sa


# Glinski Metabolites -------------------------------------------------
#not sure about surface area because used a 10 gallon tank
tank_sa <- 


# Application Rate variables
applied <- 50
conversion <- 1
density_atrazine <- 1.19 #g/cm3
density_fip <- 1.5515 #g/cm3
density_triad <- 1.22 #g/cm3


# Compute application rate
met_ar_atrazine <- (applied * conversion * density_atrazine) / tank_sa
met_ar_fip <- (applied * conversion * density_fip) / tank_sa
met_ar_triad <- (applied * conversion * density_triad) / tank_sa


# Glinski Dermal Routes -----------------------------------------------
# Surface area of circle = pi*r^2
# 1 bowl surface area = pi*(7.5^2) = 176.7146 cm2
bowl_1_sa <- pi*(7.5^2)
# 6 bowls surface area =  1413.717 cm2
bowl_8_sa <- 8*bowl_1_sa

# Application Rate variables
applied <- 50
conversion <- 1
density_bif <- 1.3 #g/cm3
density_chlor <- 1.4 #g/cm3
density_trif <- 1.36 #g/cm3



# Compute application rate
derm_ar_bif <- (applied * conversion * density_bif) / bowl_8_sa
derm_ar_chlor <- (applied * conversion * density_chlor) / bowl_8_sa
derm_ar_trif <- (applied * conversion * density_trif) / bowl_8_sa

  
  
  
  
  