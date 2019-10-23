# Regression_Discontinuity
Here we will replicate Almond, Doyle, Kowalski, and Williams (2010) paper with a few extensions

This do file allows us to analyze the effect of very low birth weight classification (i.e., having a
recorded birth weight strictly less than 1500 grams) using a regression discontinuity design. 

Problem: Low birth weight classification triggers additional treatment that might promote infant health.

Data Notes:
- The data file, sample1500g.dta, is based on Vital Statistics Linked Birth and Infant
Death Data. Each observation corresponds to a birth. Because the births have been matched to
death data, we can see whether a given child does or does not survive one hour, 24-hours, etc.
- This data is available for 1983-1992 and 1994-2002.
- Data has been limited to children with birth weights between 1350 grams and 1650 grams.
- Running variable: birth weight in grams (bweight).  
- Potential outcome variables: one-hour mortality, 24-hour mortality, one-week mortality, 28-day
mortality, and one-year mortality. These correspond to agedth1-agedth5, respectively.

PreAnalysis:
1) Create a normalized birth weight (bwtnorm) variable for which 1500g corresponds to zero.
- Normalizing the data makes the interpretation easier

Part A: Validity of Research Design
1) Show the distribution of birth weights around the 1500-gram cutoff in three ways. 
- Plot the frequencies using 1-gram bins, 10-gram bins, and 25-gram bins with bins radiating out from the
1500-gram cutoff.
2) Check for non-random sorting across the treatment-threshold by considering if the distribution is discontinuous at the treatment threshold. 
- Using the bins and associated frequencies from part A.1 as your observations, estimate whether the distribution is discontinuous at the 1500-gram threshold. 
- Estimate the discontinuity using a regression that is linear in birth weights, allowing the slope to be different on each side of the cutoff, using bandwidths of 150 grams,100-grams, and 50 grams. 
- Use robust standard errors. 
3) Alternative to check for non-random sorting is by comparing the underlying (or pre-existing) characteristics of those on each side of the cutoff (ie., want the characteristics to be smooth across the cutoff).
- Obtain RD estimates for discontinuities in whether the mother is white and whether she has less
than a high school education. 
-Present estimates based on the following specifications (clustering standard errors on birth weights): 
i. Bandwidth=90, rectangular kernelweights, slope flexible on each side of threshold 
ii. Bandwidth=60, rectangular kernel weights, slope flexible on each side of threshold 
iii. Bandwidth=30, rectangular kernel weights, slope flexible on each side of threshold 
iv-vi. Same as above but using triangular kernel weights.
4) We may be concerned that covariates might be discontinuous where the distribution is discontinuous (i.e., where there are large heaps at birth weights at ounce multiples and at the 1500-gram threshold) 
- Use a linear regression (clustering standard errors on grams) to test whether the characteristics considered in part A.3 “jump off thetrend-line” at the 51, 52, 53, and 54 ounce heaps
- Use a 25-gram bandwidth and omit observations at 1500 grams where applicable. 
- Repeat for the 1500-gram threshold but omit from the analysis any observations corresponding to ounce multiples.

Part B: Estimated Effects on Outcomes
1) Estimate the effect of very low birth weight classification on one-year mortality (agedth5) using
the same specifications as those in part A.3 but use robust standard errors. 
- Are the estimates sensitive to the bandwidth or weighting scheme?
2) Repeat B.1 after dropping observations that fall exactly at the 1500-gram cutoff. 
- Have the results changed? Should RD estimates ever be sensitive to dropping observations exactly at the cutoff?
3. Repeat B.2 after also dropping observations with weights recorded exact ounces. 
- How have the results changed?
4. Now return to the sample used in B.2 (which omits observations falling exactly at the 1500-gram
cutoff) and control flexibly for those at ounce heaps by including an indicator variable for being
at an ounce heap and an interaction of this indicator with each slope variable. 
- What do these results show?
- Which set of estimates are you most inclined to believe? Why? 
- What do you conclude about the effect of very low birth weight classification on infant mortality?

