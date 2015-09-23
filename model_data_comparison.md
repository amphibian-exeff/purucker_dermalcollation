---
title: "Create database of amphibian dermal exposure data"
---



Introduction
========================================================
Comparison of proposed amphibian dermal exposure model (Draft 8/19/15) with collected dermal exposure data. Data set is from Van Meter et al. 2014 and Van Meter et al. 2015.

Computational environment
========================================================
Location of this repository: 
https://github.com/puruckertom/amphib_data

Version and installed libraries.

```r
R.Version()$version.string
```

```
## [1] "R version 3.0.3 (2014-03-06)"
```

```r
Sys.info()[4]
```

```
##                    nodename 
## "Marcias-MacBook-Pro.local"
```



Import data from consolidated database


Proposed dermal exposure model parameters for amphibians (Document 8/19/15):

Dermal dose through direct spray-
**** Equation 12. ****
Dermal spray dose = [(Arate * 11.2) (SAtotal * 0.5) * DAF / BW ]* Fred

Arate = application rate (lb a.i./A)
11.2 = conversion from lb a.i./A to ug a.i./g-bw
SAtotal = Total surface area of organism
0.5 = Assumed that either the top half or the bottom half of the animal will be in contact with the ground or direct spray
DAF = dermal adsorption fraction used to account for pesticide specific data that define a fraction of the pesticide mass present on the animal that is actually absorbed
BW = body weight
Fred = Dermal route equivalency factor applied to dermal exposure to derive an estimate of oral dose. Assumed to be 1 for amphibians.
SAtotal = Surface area total = a3 * BW^b3
a3 = 1.131
b3= 0.579

Same surface area formula used by Van Meter et al. 

Dermal exposure function for dermal spray dose

```
## [1] 713743.3
```

```
## [1] 3104.64
```

Dermal dose through foliage contact-
**** Equation 15. **** 
Dermal contact foliar dose = ( Cplant(t) * Fdfr * Rfoliar contact ^ (8*SAtotal*0.079*0.1)     / BW ) * Fred

Cplant = Concentration of the pesticide in crop foliage at time t. Residue value used for broadleaf foliage concentration in the assessment of dietary exposure
For broadleaf plants Cplant = 135 * application rate (lbs a.i./hectare)
Fdfr = Dislodgeable foliar residue adjustment factor
Rfoliar contact = Rate of foliar contact
8 = number of hours per day the animal is active
SAtotal = surface area total of the organism
0.079 = represents the fraction of the animal in contact with the foliage
0.1 = unit conversion to ug a.i./g-bw
BW = body weight of organism
Fred = Dermal route equivalency factor (1 for amphibians)

Dermal exposure function for indirect dermal dose through foliage contact

```
## [1] 377185508
```

Use input values from Van Meter et al. database to get estimated dermal spray dose through direct spray and compare with measured body burdens

Use input values from Van Meter et al. database to get estimated dermal spray dose through indirect foliage and compare with measured body burdens


Plots comparing modeled with measured endpoints for direct vs. direct and indirect vs. indirect

```r
#plots for direct spray dose equation
max1<-max(combined_data$TissueConc, na.rm=TRUE)
min<-0
plot(combined_data$dermal_spray_dose_out~combined_data$TissueConc, xlim=c(min,max1), ylim=c(min,max1), xlab="Measured body burden", ylab="DUST direct spray")
abline(0, 1, col="red")
title(main=c("Direct spray with all body burden data"))
```

![plot of chunk unnamed-chunk-10](figure/unnamed-chunk-10-1.png) 

```r
#histogram of ratios
hist(combined_data$ratio_out)
```

![plot of chunk unnamed-chunk-10](figure/unnamed-chunk-10-2.png) 

```r
#plots for indirect foliage dose 
max1<-max(combined_data$dermal_foliage_dose_out, na.rm=TRUE)
min<-0
plot(combined_data$dermal_foliage_dose_out~combined_data$TissueConc, xlim=c(min,max1), ylim=c(min,max1), xlab="Measured body burden", ylab="DUST indirect foliage")
abline(0, 1, col="red")
title(main=c("Indirect foliage spray with all body burden data"))
```

![plot of chunk unnamed-chunk-10](figure/unnamed-chunk-10-3.png) 

```r
hist(combined_data$ratio_out_foliage)
```

![plot of chunk unnamed-chunk-10](figure/unnamed-chunk-10-4.png) 

Plot by chemical modeled with measured endpoints for all comparisons

```r
unique.chemicals<-unique(combined_data$Chemical)
# create consistent chemical names
combined_data$Chemical[combined_data$Chemical=="ATZ"]<-"Atrazine"
combined_data$Chemical[combined_data$Chemical=="Imid"]<-"Imidacloprid"
combined_data$Chemical[combined_data$Chemical=="Fip"]<-"Fipronil"
combined_data$Chemical[combined_data$Chemical=="Pendi"]<-"Pendimethalin"
combined_data$Chemical[combined_data$Chemical=="TDN"]<-"Triadimefon"
chemicals2<-c("Atrazine","Imidacloprid","Fipronil","Pendimethalin","Triadimefon")


par(mfrow=c(1,1))
# direct dermal DUST vs. measured direct
max1<-max(combined_data$TissueConc)
min<-0 
plot(combined_data$dermal_spray_dose_out[which(combined_data$Application=="Direct")]~combined_data$TissueConc[which(combined_data$Application=="Direct")], xlab=c('Measured Tissue Concentration Direct'), ylab=c("Modeled Tissue Concentration Direct"),asp=1, pty='s', xlim=c(min,max1), ylim=c(min,max1),pch=16, col=combined_data$Species[which(combined_data$Application=="Direct")])
abline(0, 1, col="red")
title(main=c("Direct dermal DUST vs. measured direct"))
```

![plot of chunk unnamed-chunk-11](figure/unnamed-chunk-11-1.png) 

```r
# direct dermal DUST vs. measured indirect
max1<-max(combined_data$TissueConc)
min<-0 
plot(combined_data$dermal_spray_dose_out[which(combined_data$Application=="Indirect")]~combined_data$TissueConc[which(combined_data$Application=="Indirect")], xlab=c('Measured Tissue Concentration Indirect'), ylab=c("Modeled Tissue Concentration Direct"),asp=1, pty='s', xlim=c(min,max1), ylim=c(min,max1), pch=16,col=combined_data$Species[which(combined_data$Application=="Indirect")])
abline(0, 1, col="red")
title(main=c("Direct dermal DUST vs. measured indirect"))
```

![plot of chunk unnamed-chunk-11](figure/unnamed-chunk-11-2.png) 

```r
# indirect dermal DUST vs. measured indirect
max1<-max(combined_data$TissueConc)
min<-0 
plot(combined_data$dermal_foliage_dose_out[which(combined_data$Application=="Indirect")]~combined_data$TissueConc[which(combined_data$Application=="Indirect")], xlab=c('Measured Tissue Concentration Indirect'), ylab=c("Modeled Tissue Concentration Indirect"),asp=1, pty='s', xlim=c(min,max1), ylim=c(min,max1), pch=16,col=combined_data$Species[which(combined_data$Application=="Indirect")])
abline(0, 1, col="red")
title(main=c("Indirect dermal DUST vs. measured indirect"))
```

![plot of chunk unnamed-chunk-11](figure/unnamed-chunk-11-3.png) 

```r
# indirect dermal DUST vs. measured direct
max1<-max(combined_data$TissueConc[which(combined_data$Application=="Direct")])
min<-0 
plot(combined_data$dermal_foliage_dose_out[which(combined_data$Application=="Direct")]~combined_data$TissueConc[which(combined_data$Application=="Direct")], xlab=c('Measured Tissue Concentration Direct'), ylab=c("Modeled Tissue Concentration Indirect"),asp=1, pty='s', xlim=c(min,max1), ylim=c(min,max1), pch=16,col=combined_data$Species[which(combined_data$Application=="Direct")])
abline(0, 1, col="red")
title(main=c("Indirect dermal DUST vs. measured direct"))
```

![plot of chunk unnamed-chunk-11](figure/unnamed-chunk-11-4.png) 


