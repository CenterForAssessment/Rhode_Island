#######
# 2018
#######

require(SGP)
require(data.table)

setwd("/Users/avi/Dropbox (SGP)/Github_Repos/Documentation/Rhode_Island/SGP_Reports/2018")

load("~/Dropbox (SGP)/SGP/Rhode_Island/Data/Rhode_Island_SGP.Rdata")

load("~/Dropbox (SGP)/SGP/Rhode_Island/Data/ARCHIVE/PARCC 2015 to 2017/Rhode_Island_SGP_LONG_Data_2015_2016.Rdata")
load("~/Dropbox (SGP)/SGP/Rhode_Island/Data/ARCHIVE/PARCC 2015 to 2017/Rhode_Island_SGP_LONG_Data_2016_2017.Rdata")
load("~/Dropbox (SGP)/SGP/Rhode_Island/Data/Rhode_Island_SGP_LONG_Data_2017_2018.Rdata")
load("~/Dropbox (SGP)/SGP/Rhode_Island/Data/Rhode_Island_SGP_LONG_Data.Rdata")

Rhode_Island_SGP_LONG_Data_2015_2016 <- Rhode_Island_SGP_LONG_Data_2015_2016[, grep("SGP_TARGET_|PERCENTILE_CUT_", names(Rhode_Island_SGP_LONG_Data_2015_2016), invert=T, value=T), with=F]
Rhode_Island_SGP_LONG_Data_2016_2017 <- Rhode_Island_SGP_LONG_Data_2016_2017[, grep("SGP_TARGET_|PERCENTILE_CUT_|SGP_PROJECTION_GROUP_", names(Rhode_Island_SGP_LONG_Data_2016_2017), invert=T, value=T), with=F]
setnames(Rhode_Island_SGP_LONG_Data_2015_2016,  c("SCALE_SCORE_ACTUAL", "SCALE_SCORE"), c("SCALE_SCORE", "SCALE_SCORE_THETA"))
setnames(Rhode_Island_SGP_LONG_Data_2016_2017,  c("SCALE_SCORE_ACTUAL", "SCALE_SCORE"), c("SCALE_SCORE", "SCALE_SCORE_THETA"))

Rhode_Island_Data_LONG <- rbindlist(
	list(
		Rhode_Island_SGP_LONG_Data_2015_2016,
		Rhode_Island_SGP_LONG_Data_2016_2017,
		Rhode_Island_SGP_LONG_Data_2017_2018), fill = TRUE)

Rhode_Island_Data_LONG <- Rhode_Island_Data_LONG[, names(Rhode_Island_SGP_LONG_Data), with = FALSE]

sats <- c("ELA_PSAT_10", "ELA_SAT", "MATHEMATICS_PSAT_10", "MATHEMATICS_SAT")
Rhode_Island_Data_LONG[CONTENT_AREA %in% sats, STATE_ENROLLMENT_STATUS := "Enrolled State: Yes"]
Rhode_Island_Data_LONG[CONTENT_AREA %in% sats, DISTRICT_ENROLLMENT_STATUS := "Enrolled District: Yes"]
Rhode_Island_Data_LONG[CONTENT_AREA %in% sats, SCHOOL_ENROLLMENT_STATUS := "Enrolled School: Yes"]

Rhode_Island_Data_LONG[CONTENT_AREA == "PSAT_EBRW", CONTENT_AREA := "ELA_PSAT_10"]
Rhode_Island_Data_LONG[CONTENT_AREA == "PSAT_MATH", CONTENT_AREA := "MATHEMATICS_PSAT_10"]


### Split SGP_NORM_GROUP
my.tmp.split <- strsplit(as.character(Rhode_Island_Data_LONG$SGP_NORM_GROUP), "; ")

Rhode_Island_Data_LONG$YEAR_PRIOR_1 <- sapply(strsplit(sapply(my.tmp.split, function(x) rev(x)[2]), "/"), '[', 1)
Rhode_Island_Data_LONG$CONTENT_AREA_PRIOR_1 <- sapply(sapply(strsplit(sapply(strsplit(sapply(my.tmp.split, function(x) rev(x)[2]), "/"), '[', 2), "_"), head, -1), paste, collapse="_")
Rhode_Island_Data_LONG$GRADE_PRIOR_1 <- sapply(strsplit(sapply(strsplit(sapply(my.tmp.split, function(x) rev(x)[2]), "/"), '[', 2), "_"), tail, 1)
my.tmp.split.scale_score <- strsplit(Rhode_Island_Data_LONG$SGP_NORM_GROUP_SCALE_SCORES, "; ")
Rhode_Island_Data_LONG$SCALE_SCORE_PRIOR_1 <- sapply(my.tmp.split.scale_score, function(x) rev(x)[2])

###  ACHIEVEMENT_LEVEL_PRIOR
setnames(Rhode_Island_Data_LONG, c("YEAR_PRIOR_1", "CONTENT_AREA_PRIOR_1", "GRADE_PRIOR_1", "YEAR", "CONTENT_AREA", "GRADE"), c("YEAR", "CONTENT_AREA", "GRADE", "YEAR_ORIG", "CONTENT_AREA_ORIG", "GRADE_ORIG"))
Rhode_Island_Data_LONG <- SGP:::getAchievementLevel(Rhode_Island_Data_LONG, state="RI", achievement.level.name="ACHIEVEMENT_LEVEL_PRIOR", scale.score.name="SCALE_SCORE_PRIOR_1")
setnames(Rhode_Island_Data_LONG, c("YEAR", "CONTENT_AREA", "GRADE", "YEAR_ORIG", "CONTENT_AREA_ORIG", "GRADE_ORIG"), c("YEAR_PRIOR_1", "CONTENT_AREA_PRIOR_1", "GRADE_PRIOR_1", "YEAR", "CONTENT_AREA", "GRADE"))

Rhode_Island_Data_LONG[YEAR != "2017_2018", ACHIEVEMENT_LEVEL_PRIOR := NA]
Rhode_Island_Data_LONG[YEAR == "2017_2018" & !is.na(as.numeric(SCALE_SCORE_PRIOR_1)), as.list(summary(as.numeric(SCALE_SCORE_PRIOR_1))), keyby=c("CONTENT_AREA_PRIOR_1", "ACHIEVEMENT_LEVEL_PRIOR")]

Rhode_Island_Data_LONG[, c("YEAR_PRIOR_1", "CONTENT_AREA_PRIOR_1", "GRADE_PRIOR_1", "SCALE_SCORE_PRIOR_1") := NULL]

Rhode_Island_SGP@Data <- Rhode_Island_Data_LONG
Rhode_Island_SGP <- prepareSGP(Rhode_Island_SGP)
Rhode_Island_SGP <- summarizeSGP(Rhode_Island_SGP,
																 parallel.config = list(
																 		BACKEND="PARALLEL", WORKERS=list(SUMMARY=7)))

outputSGP(Rhode_Island_SGP, output.type="LONG_Data", outputSGP.directory="~/Dropbox (SGP)/SGP/Rhode_Island/Data/")
save(Rhode_Island_SGP, file="~/Dropbox (SGP)/SGP/Rhode_Island/Data/Rhode_Island_SGP.Rdata")

Rhode_Island_SGP@Data$Most_Recent_Prior <- as.character(NA)
Rhode_Island_SGP@Data[, Most_Recent_Prior := sapply(strsplit(as.character(Rhode_Island_SGP@Data$SGP_NORM_GROUP), "; "), function(x) rev(x)[2])]


###

require(Literasee)

renderMultiDocument(rmd_input = "Rhode_Island_SGP_Report_2018.Rmd",
										report_format = c("HTML", "PDF"),
										# cover_img="../img/cover.jpg",
										# add_cover_title=TRUE, 
										# cleanup_aux_files = FALSE,
										pandoc_args = "--webtex")

renderMultiDocument(rmd_input = "Appendix_A_2018.Rmd",
										report_format = c("HTML", "PDF"),
										cover_img="../img/cover.jpg",
										add_cover_title=TRUE)

renderMultiDocument(rmd_input = "Appendix_C_2018.Rmd",
										report_format = c("HTML", "PDF"),
										cover_img="../img/cover.jpg",
										add_cover_title=TRUE)

