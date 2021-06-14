#####################################################################################
###                                                                               ###
###       Rhode Island Learning Loss Analyses -- Create Baseline Matrices         ###
###                                                                               ###
#####################################################################################

### Load necessary packages
require(SGP)
require(data.table)
options(warn=2)

###   Load the results data from the 'official' 2019 SGP analyses
load("Data/Rhode_Island_SGP_LONG_Data.Rdata")

###   Create a smaller subset of the LONG data to work with.
Rhode_Island_Baseline_Data <- data.table(Rhode_Island_SGP_LONG_Data[, c("VALID_CASE", "CONTENT_AREA", "YEAR", "ID", "GRADE", "SCALE_SCORE", "ACHIEVEMENT_LEVEL"),])

### Modify knots/boundaries in SGPstateData to use equated scale scores properly
SGPstateData[["RI"]][["Achievement"]][["Knots_Boundaries"]][["ELA"]] <- SGPstateData[["RI"]][["Achievement"]][["Knots_Boundaries"]][["ELA.2017_2018"]]
SGPstateData[["RI"]][["Achievement"]][["Knots_Boundaries"]][["MATHEMATICS"]] <- SGPstateData[["RI"]][["Achievement"]][["Knots_Boundaries"]][["MATHEMATICS.2017_2018"]]
SGPstateData[["RI"]][["Achievement"]][["Knots_Boundaries"]][["ELA_PSAT_10"]] <- SGPstateData[["RI"]][["Achievement"]][["Knots_Boundaries"]][["ELA_PSAT_10.2017_2018"]]
SGPstateData[["RI"]][["Achievement"]][["Knots_Boundaries"]][["MATHEMATICS_PSAT_10"]] <- SGPstateData[["RI"]][["Achievement"]][["Knots_Boundaries"]][["MATHEMATICS_PSAT_10.2017_2018"]]
SGPstateData[["RI"]][["Achievement"]][["Knots_Boundaries"]][["ELA.2017_2018"]] <- NULL
SGPstateData[["RI"]][["Achievement"]][["Knots_Boundaries"]][["ELA_PSAT_10.2017_2018"]] <- NULL
SGPstateData[["RI"]][["Achievement"]][["Knots_Boundaries"]][["MATHEMATICS.2017_2018"]] <- NULL
SGPstateData[["RI"]][["Achievement"]][["Knots_Boundaries"]][["MATHEMATICS_PSAT_10.2017_2018"]] <- NULL

### Put 2015_2016 and 2016_2017 scores on RICAS scale (>= 2017_2018) -- Just ELA and MATHEMATICS Grades 3 to 8
SGPstateData[["RI"]][["Assessment_Program_Information"]][["Assessment_Transition"]][["Year"]] <- "2017_2018"

data.for.equate <- Rhode_Island_Baseline_Data[YEAR <= "2017_2018" & CONTENT_AREA %in% c("ELA", "MATHEMATICS")]
tmp.equate.linkages <- SGP:::equateSGP(
                                tmp.data=data.for.equate,
                                state="RI",
                                current.year="2017_2018",
                                equating.method=c("identity", "mean", "linear", "equipercentile"))

setkey(data.for.equate, VALID_CASE, CONTENT_AREA, YEAR, GRADE, SCALE_SCORE)

data.for.equate <- SGP:::convertScaleScore(data.for.equate, "2017_2018", tmp.equate.linkages, "OLD_TO_NEW", "equipercentile", "RI")
data.for.equate[YEAR %in% c("2015_2016", "2016_2017"), SCALE_SCORE:=SCALE_SCORE_EQUATED_EQUIPERCENTILE_OLD_TO_NEW]
data.for.equate[,SCALE_SCORE_EQUATED_EQUIPERCENTILE_OLD_TO_NEW:=NULL]

Rhode_Island_Baseline_Data <- rbindlist(list(data.for.equate, Rhode_Island_Baseline_Data[YEAR >= "2018_2019"], Rhode_Island_Baseline_Data[YEAR <= "2017_2018" & !CONTENT_AREA %in% c("ELA", "MATHEMATICS")]))
setkey(Rhode_Island_Baseline_Data, VALID_CASE, CONTENT_AREA, YEAR, ID)

###   Read in Baseline SGP Configuration Scripts and Combine
source("SGP_CONFIG/2018_2019/BASELINE/Matrices/ELA.R")
source("SGP_CONFIG/2018_2019/BASELINE/Matrices/ELA_PSAT_10.R")
source("SGP_CONFIG/2018_2019/BASELINE/Matrices/ELA_SAT.R")
source("SGP_CONFIG/2018_2019/BASELINE/Matrices/MATHEMATICS.R")
source("SGP_CONFIG/2018_2019/BASELINE/Matrices/MATHEMATICS_PSAT_10.R")
source("SGP_CONFIG/2018_2019/BASELINE/Matrices/MATHEMATICS_SAT.R")

RI_BASELINE_CONFIG <- c(
	ELA_BASELINE.config,
	ELA_PSAT_10_BASELINE.config,
	ELA_SAT_BASELINE.config,
	MATHEMATICS_BASELINE.config,
	MATHEMATICS_PSAT_10_BASELINE.config,
	MATHEMATICS_SAT_BASELINE.config
)

###
###   Create Baseline Matrices

Rhode_Island_SGP <- prepareSGP(Rhode_Island_Baseline_Data, create.additional.variables=FALSE)

RI_Baseline_Matrices <- baselineSGP(
				Rhode_Island_SGP,
				sgp.baseline.config=RI_BASELINE_CONFIG,
				return.matrices.only=TRUE,
				calculate.baseline.sgps=FALSE,
				goodness.of.fit.print=FALSE,
				parallel.config = list(
					BACKEND="PARALLEL", WORKERS=list(TAUS=7))
)

###   Save results
save(RI_Baseline_Matrices, file="Data/RI_Baseline_Matrices.Rdata")

### Create SCALE_SCORE_NON_EQUATED and turn (2016) SCALE_SCORE into SCALE_SCORE_EQUATED to Rhode_Island_SGP_LONG_Data and save results
setkey(Rhode_Island_SGP_LONG_Data, VALID_CASE, CONTENT_AREA, YEAR, GRADE, ID)
setkey(Rhode_Island_Baseline_Data, VALID_CASE, CONTENT_AREA, YEAR, GRADE, ID)
Rhode_Island_SGP_LONG_Data[,SCALE_SCORE_NON_EQUATED:=SCALE_SCORE]
Rhode_Island_SGP_LONG_Data[,SCALE_SCORE:=Rhode_Island_Baseline_Data$SCALE_SCORE]

save(Rhode_Island_SGP_LONG_Data, file="Data/Rhode_Island_SGP_LONG_Data.Rdata")
