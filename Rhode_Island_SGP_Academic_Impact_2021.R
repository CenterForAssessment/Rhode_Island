################################################################################
###
### Calculation and export script for academic impact for Rhode_Island 2020_2021
###
################################################################################

### Load packages
require(cfaTools)
require(SGP)

### Load data
load("Data/Rhode_Island_SGP.Rdata")


### Create academic impact summaries
Rhode_Island_SGP_Academic_Impact_Summaries_2020_2021 <- list()
Rhode_Island_SGP_Academic_Impact_Summaries_2020_2021[['SCHOOL_NUMBER']] <- academicImpactSummary(Rhode_Island_SGP, state='RI', current_year='2020_2021', prior_year='2018_2019', content_areas=c('ELA', 'MATHEMATICS'), all_grades=as.character(c(3:8)), sgp_grades=as.character(5:8), aggregation_group="SCHOOL_NUMBER")[['SCHOOL_NUMBER']]
Rhode_Island_SGP_Academic_Impact_Summaries_2020_2021[['DISTRICT_NUMBER']] <- academicImpactSummary(Rhode_Island_SGP, state='RI', current_year='2020_2021', prior_year='2018_2019', content_areas=c('ELA', 'MATHEMATICS'), all_grades=as.character(c(3:8)), sgp_grades=as.character(5:8), aggregation_group="DISTRICT_NUMBER")[['DISTRICT_NUMBER']]
Rhode_Island_SGP_Academic_Impact_Summaries_2020_2021[['SCHOOL_NUMBER_by_GRADE']] <- academicImpactSummary(Rhode_Island_SGP, state='RI', current_year='2020_2021', prior_year='2018_2019', content_areas=c('ELA', 'MATHEMATICS'), all_grades=as.character(c(3:8)), sgp_grades=as.character(5:8), aggregation_group=c("SCHOOL_NUMBER", "GRADE"))[['SCHOOL_NUMBER_by_GRADE']]


### Format and Save Output
save(Rhode_Island_SGP_Academic_Impact_Summaries_2020_2021, file="Data/Rhode_Island_SGP_Academic_Impact_Summaries_2020_2021.Rdata")
#variables.to.keep <- c("CONTENT_AREA", "YEAR", "SCHOOL_NUMBER", )
#tmp.school.data <- Rhode_Island_SGP_Academic_Impact_Summaries_2020_2021[['SCHOOL_NUMBER']][,variables.to.keep, with=FALSE]
#write.table(tmp.school.data, file="Data/Formatted_Output/Rhode_Island_Academic_Output_Summaries_2020_2021_SCHOOL.txt")
