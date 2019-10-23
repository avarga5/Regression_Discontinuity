*Regression Discontinuity: Almond, Doyle, Kowalski and Williams (2010) replication

clear
capture cd "\\toaster\homes\a\v\avarga5\nt>"
set more off

********************************************************************************
************************PreAnalysis*********************************************
use sample1500g.dta, clear

*need to normalize birth weight
*cutoff (r) = 1500 but need = 0 
gen bwtnorm = bweight - 1500    /* r */
sort bwtnorm 

*get rid of unneccesary variables
*drop match-mom_ed gest-apgar5_7 gr_mult5-person_id

********************************************************************************
*********************************Part A*****************************************
*1.a
*bin 1 gram
gen bin01 = bwtnorm + 0.5
preserve
collapse (count) bwtnorm, by (bin01)
scatter bwtnorm bin01, title("Figure 1: 1gram bins")
graph export scatter_bin01.png, replace
restore

*1.b
*bin 10 grams
*below gives the mean number for every ten numbers
gen bin10 = floor(bwtnorm/10)*10 + 5 /*because 5 is mean of 10*/
preserve
collapse (count) bwtnorm, by (bin10)
scatter bwtnorm bin10, title("Figure 2: 10gram bins")
graph export scatter_bin10.png, replace
restore

*1.c
*bin 25 grams
gen bin25 = floor(bwtnorm/25)*25 + 12.5 /*becasuse 12.5 is mean of 25*/
preserve
collapse (count) bwt, by (bin25)
scatter bwtnorm bin25, title("Figure 3: 25gram bins")
graph export scatter_bin25.png, replace
restore

**Is the distribution of birth weights smooth? NO!

*2.a
*bin 1 gram
*E[y|r] = alpha + theta 1(r<0) + beta*r + gamma*r*1(r<0)
*dummy variables for running variable
preserve
collapse (count) bwt, by (bin01)
gen rdum = 0                                 
replace rdum = 1 if bin01 < 0                   /* 1(r<0) */
gen bin01_rdum = bin01 * rdum                  /* r 1(r<0) */

eststo clear
eststo: reg bwtnorm rdum bin01 bin01_rdum if abs(bin01)<=150, vce(robust)
eststo: reg bwtnorm rdum bin01 bin01_rdum if abs(bin01)<=100, vce(robust)
eststo: reg bwtnorm rdum bin01 bin01_rdum if abs(bin01)<=50, vce(robust)

esttab, title("Table 1: Test Discontinuity 1gram bins") ///
		b() se() r2 ar2 varwidth(20) modelwidth(10) ///
	    mtitles("1g bwt150" "1g bwt100" "1g bwt50")
restore

*2.b
*bin 10 grams
*E[y|r] = alpha + theta 1(r<0) + beta*r + gamma*r*1(r<0)
*dummy variables for running variable
preserve
collapse (count) bwt, by (bin10)
gen rdum = 0                                 
replace rdum = 1 if bin10 < 0                   /* 1(r<0) */
gen bin10_rdum = bin10 * rdum                  /* r 1(r<0) */

eststo clear
eststo: reg bwtnorm rdum bin10 bin10_rdum if abs(bin10)<=150, vce(robust)
eststo: reg bwtnorm rdum bin10 bin10_rdum if abs(bin10)<=100, vce(robust)
eststo: reg bwtnorm rdum bin10 bin10_rdum if abs(bin10)<=50, vce(robust)

esttab, title("Table 2: Test Discontinuity 10gram bins") ///
		b() se() r2 ar2 varwidth(20) modelwidth(10) ///
	    mtitles("10g bwt150" "10g bwt100" "10g bwt50")
restore

*2.c
*bin 25 grams
*E[y|r] = alpha + theta 1(r<0) + beta*r + gamma*r*1(r<0)
*dummy variables for running variable
preserve
collapse (count) bwt, by (bin25)
gen rdum = 0                                 
replace rdum = 1 if bin25 < 0                   /* 1(r<0) */
gen bin25_rdum = bin25 * rdum                  /* r 1(r<0) */

eststo clear
eststo: reg bwtnorm rdum bin25 bin25_rdum if abs(bin25)<=150, vce(robust)
eststo: reg bwtnorm rdum bin25 bin25_rdum if abs(bin25)<=100, vce(robust)
eststo: reg bwtnorm rdum bin25 bin25_rdum if abs(bin25)<=50, vce(robust)

esttab, title("Table 3: Test Discontinuity 25gram bins") ///
		b() se() r2 ar2 varwidth(20) modelwidth(10) ///
	    mtitles("25g bwt150" "25g bwt100" "25g bwt50")
restore

*Based on the nine estimates, do we conclude that the running variable is smooth
*across the threshold? YES!

*3.a 
*E[y|r] = alpha + theta 1(r<0) + beta*r + gamma*r*1(r<0)
*check for discontinuities in observables near the threshold (mother race and edu)
gen rdum = 0
replace rdum =1 if bwtnorm < 0
gen bwtnorm_rdum = bwtnorm * rdum

gen mom_white = 0
replace mom_white = 1 if mom_race == 1  

*rectangular weights
eststo clear
eststo: reg mom_white rdum bwtnorm bwtnorm_rdum if abs(bwtnorm) <= 90
eststo: reg mom_white rdum bwtnorm bwtnorm_rdum if abs(bwtnorm) <= 60
eststo: reg mom_white rdum bwtnorm bwtnorm_rdum if abs(bwtnorm) <= 30
eststo: reg mom_ed1 rdum bwtnorm bwtnorm_rdum if abs(bwtnorm) <= 90
eststo: reg mom_ed1 rdum bwtnorm bwtnorm_rdum if abs(bwtnorm) <= 60
eststo: reg mom_ed1 rdum bwtnorm bwtnorm_rdum if abs(bwtnorm) <= 30

esttab, title("Table 4: Covariate Test with Rectangular Weights") ///
		b() se() r2 ar2 varwidth(20) modelwidth(10) ///
	    mtitles("90g White" "60g White" "30g White" "90g Less HS" "60g Less HS" "30g Less HS")

*3.b
*E[y|r] = alpha + theta 1(r<0) + beta*r + gamma*r*1(r<0)
*check for discontinuities in observables near the threshold (mother race and edu)
*triangular weights
gen weight_90 = 1 - abs(bwtnorm/90)
gen weight_60 = 1 - abs(bwtnorm/60)
gen weight_30 = 1 - abs(bwtnorm/30)

eststo clear
eststo: reg mom_white rdum bwtnorm bwtnorm_rdum [pw = weight_90] if abs(bwtnorm) <= 90
eststo: reg mom_white rdum bwtnorm bwtnorm_rdum [pw = weight_60] if abs(bwtnorm) <= 60
eststo: reg mom_white rdum bwtnorm bwtnorm_rdum [pw = weight_30] if abs(bwtnorm) <= 30
eststo: reg mom_ed1 rdum bwtnorm bwtnorm_rdum [pw = weight_90] if abs(bwtnorm) <= 90
eststo: reg mom_ed1 rdum bwtnorm bwtnorm_rdum [pw = weight_60] if abs(bwtnorm) <= 60
eststo: reg mom_ed1 rdum bwtnorm bwtnorm_rdum [pw = weight_30] if abs(bwtnorm) <= 30

esttab, title("Table 5: Covariate Test with Triangular Weights") ///
		b() se() r2 ar2 varwidth(20) modelwidth(10) ///
	    mtitles("90g White" "60g White" "30g White" "90g Less HS" "60g Less HS" "30g Less HS")

*Are the results sensitive to the choice of bandwidth or the choise of weighting strategy? NO!
*Does the RD design pass the "balanced covariates test? YES!

*4.a 
*normalize bwt by 51 oz = 1446 g
gen bwt_51 = bweight - 1446
gen rdum_51 = 0
replace rdum_51 = 1 if bwt_51 < 0 

*regress
regress mom_white rdum_51 bwt_51 if bweight != 1500 & abs(bwt_51) <= 25, vce(robust)
eststo reg1
regress mom_ed1 rdum_51 bwt_51 if bweight != 1500 & abs(bwt_51) <= 25, vce(robust)
eststo reg2

*4.b 
*normalize bwt by 52 oz = 1474
gen bwt_52 = bweight - 1474
gen rdum_52 = 0
replace rdum_52 = 1 if bwt_52 < 0 

*regress
regress mom_white rdum_52 bwt_52 if bweight != 1500 & abs(bwt_52) <= 25, vce(robust)
eststo reg3
regress mom_ed1 rdum_52 bwt_52 if bweight != 1500 & abs(bwt_52) <= 25, vce(robust)
eststo reg4

*4.c
*normalize bwt by 53 oz = 1503 g
gen bwt_53 = bweight - 1503
gen rdum_53 = 0
replace rdum_53 = 1 if bwt_53 < 0 

*regress
regress mom_white rdum_53 bwt_53 if bweight != 1500 & abs(bwt_53) <= 25, vce(robust)
eststo reg5
regress mom_ed1 rdum_53 bwt_53 if bweight != 1500 & abs(bwt_53) <= 25, vce(robust)
eststo reg6

*4.d 
*normalize bwt by 54 oz = 1531 g
gen bwt_54 = bweight - 1531
gen rdum_54 = 0
replace rdum_54 = 1 if bwt_54 < 0 

*regress
regress mom_white rdum_54 bwt_54 if bweight != 1500 & abs(bwt_54) <= 25, vce(robust)
eststo reg7
regress mom_ed1 rdum_54 bwt_54 if bweight != 1500 & abs(bwt_54) <= 25, vce(robust)
eststo reg8

*4.e
*1500g
regress mom_white rdum bwtnorm if ounce != 1 & abs(bwtnorm) <= 25, vce(robust)
eststo reg9
regress mom_ed1 rdum bwtnorm if ounce != 1 & abs(bwtnorm) <= 25, vce(robust)
eststo reg10

esttab reg1 reg3 reg5 reg7 reg9, title("Table 6: Mother Race and Birth Weight Heaps") ///
	b() se() r2 ar2 varwidth(20) modelwidth(10) /// 
	mtitles("51 White" "52 White" "53 White" "54 White" "1500 white")
	
esttab reg2 reg4 reg6 reg8 reg10, title("Table 7: Mother Education and Birth Weight Heaps") ///
	b(5) se(5) r2 ar2 varwidth(20) modelwidth(10) /// 
	mtitles("51 LessHS" "52 LessHS" "53 LessHS" "54 LessHS" "1500 LessHS")	

*Are the characteristics of children at ounce heaps systemically different from
*the characteristics of children with similar birth weights whose weights are not 
*recorded at ounce hepas? YES! but only with respect to whether the mother was white
*but the the heaps were not different for children of mothers with less than HS edu

*How about those at the 1500-gram heap? YES! for both characteristics (mother race and edu)

********************************************************************************
*********************************Part B*****************************************
*1.
*same as A.3.c, replace with agedth5
eststo clear
eststo: reg agedth5 rdum bwtnorm bwtnorm_rdum if abs(bwtnorm) <= 90, vce(robust)
eststo: reg agedth5 rdum bwtnorm bwtnorm_rdum if abs(bwtnorm) <= 60, vce(robust)
eststo: reg agedth5 rdum bwtnorm bwtnorm_rdum if abs(bwtnorm) <= 30, vce(robust)
eststo: reg agedth5 rdum bwtnorm bwtnorm_rdum [pw = weight_90] if abs(bwtnorm) <= 90, vce(robust)
eststo: reg agedth5 rdum bwtnorm bwtnorm_rdum [pw = weight_60] if abs(bwtnorm) <= 60, vce(robust)
eststo: reg agedth5 rdum bwtnorm bwtnorm_rdum [pw = weight_30] if abs(bwtnorm) <= 30, vce(robust)

esttab, title("Table 8: Low Birth Rate and One Year Mortality (agedth5)") ///
		b() se() r2 ar2 varwidth(20) modelwidth(10) ///
	    mtitles("90g Rw" "60g Rw" "30g Rw" "90g Tw" "60g Tw" "30g Tw")

*Are the estimates sensitive to bandwidth or weighting scheme? YES to both!
		
*2.
*same as B.1, drop 1500g cutoff
eststo clear
eststo: reg agedth5 rdum bwtnorm bwtnorm_rdum if bweight != 1500 & abs(bwtnorm) <= 90, vce(robust)
eststo: reg agedth5 rdum bwtnorm bwtnorm_rdum if bweight != 1500 & abs(bwtnorm) <= 60, vce(robust)
eststo: reg agedth5 rdum bwtnorm bwtnorm_rdum if bweight != 1500 & abs(bwtnorm) <= 30, vce(robust)
eststo: reg agedth5 rdum bwtnorm bwtnorm_rdum [pw = weight_90] if bweight != 1500 & abs(bwtnorm) <= 90, vce(robust)
eststo: reg agedth5 rdum bwtnorm bwtnorm_rdum [pw = weight_60] if bweight != 1500 & abs(bwtnorm) <= 60, vce(robust)
eststo: reg agedth5 rdum bwtnorm bwtnorm_rdum [pw = weight_30] if bweight != 1500 & abs(bwtnorm) <= 30, vce(robust)

esttab, title("Table 9: Low Birth Rate and One Year Mortality (agedth5) drop cutoff") ///
		b() se() r2 ar2 varwidth(20) modelwidth(10) ///
	    mtitles("90g Rw" "60g Rw" "30g Rw" "90g Tw" "60g Tw" "30g Tw")

* Have the results changed? Slightly
*Should RD estimates ever be sensitive to dropping observations exactly at the cutoff?
*Probably (need to explain)

*3.
*same as B.2, drop exact ounce
eststo clear
eststo: reg agedth5 rdum bwtnorm bwtnorm_rdum if ounce != 1 & bweight != 1500 & abs(bwtnorm) <= 90, vce(robust)
eststo: reg agedth5 rdum bwtnorm bwtnorm_rdum if ounce != 1 & bweight != 1500 & abs(bwtnorm) <= 60, vce(robust)
eststo: reg agedth5 rdum bwtnorm bwtnorm_rdum if ounce != 1 & bweight != 1500 & abs(bwtnorm) <= 30, vce(robust)
eststo: reg agedth5 rdum bwtnorm bwtnorm_rdum [pw = weight_90] if ounce != 1 & bweight != 1500 & abs(bwtnorm) <= 90, vce(robust)
eststo: reg agedth5 rdum bwtnorm bwtnorm_rdum [pw = weight_60] if ounce != 1 & bweight != 1500 & abs(bwtnorm) <= 60, vce(robust)
eststo: reg agedth5 rdum bwtnorm bwtnorm_rdum [pw = weight_30] if ounce != 1 & bweight != 1500 & abs(bwtnorm) <= 30, vce(robust)

esttab, title("Table 10: Low Birth Rate and One Year Mortality (agedth5) drop cutoff & exact ounces") ///
		b() se() r2 ar2 varwidth(20) modelwidth(10) ///
	    mtitles("90g Rw" "60g Rw" "30g Rw" "90g Tw" "60g Tw" "30g Tw")

*How have results changed? No longer significantly different
		
*4. 
*same as B.2, incllude inicator and variation
gen bwt_oz = bwtnorm * ounce
gen bwt_rdum_oz = bwtnorm_rdum * ounce

eststo clear
eststo: reg agedth5 rdum bwtnorm bwtnorm_rdum ounce bwt_oz bwt_rdum_oz if bweight != 1500 & abs(bwtnorm) <= 90, vce(robust)
eststo: reg agedth5 rdum bwtnorm bwtnorm_rdum ounce bwt_oz bwt_rdum_oz if bweight != 1500 & abs(bwtnorm) <= 60, vce(robust)
eststo: reg agedth5 rdum bwtnorm bwtnorm_rdum ounce bwt_oz bwt_rdum_oz if bweight != 1500 & abs(bwtnorm) <= 30, vce(robust)
eststo: reg agedth5 rdum bwtnorm bwtnorm_rdum ounce bwt_oz bwt_rdum_oz [pw = weight_90] if bweight != 1500 & abs(bwtnorm) <= 90, vce(robust)
eststo: reg agedth5 rdum bwtnorm bwtnorm_rdum ounce bwt_oz bwt_rdum_oz [pw = weight_60] if bweight != 1500 & abs(bwtnorm) <= 60, vce(robust)
eststo: reg agedth5 rdum bwtnorm bwtnorm_rdum ounce bwt_oz bwt_rdum_oz [pw = weight_30] if bweight != 1500 & abs(bwtnorm) <= 30, vce(robust)

esttab, title("Table 11: Low Birth Rate and One Year Mortality (agedth5) drop cutoff and include indicators") ///
		b() se() r2 ar2 varwidth(20) modelwidth(10) ///
	    mtitles("90g Rw" "60g Rw" "30g Rw" "90g Tw" "60g Tw" "30g Tw")

*What do these results show?
*The signs on the first two estimates have flipped again but there is no statistically
 *significant estimate for any of the models (table 11).

*5
*Which set of estimates are you most inclined to believe? Why? 
*I am partial to the results in table 11 because it accounts for the most variation by controlling
*for the ounce heaps and observation drops at the threshold.

*What do you conclude about the effect of very low birthweight classification on infant mortality?
*I conclude that there is no statistically significant effect of very low birth weight classification
 *on infant mortality.



























