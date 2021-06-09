################################################################################
###                                                                          ###
###      ELA BASELINE matrix configurations (sequential and skip-year)       ###
###                                                                          ###
################################################################################

ELA_PSAT_10_BASELINE.config <- list(
	list(
		sgp.baseline.content.areas=c("ELA", "ELA_PSAT_10"),
		sgp.baseline.panel.years=c("2016_2017", "2018_2019"),
		sgp.baseline.grade.sequences=c("8", "EOCT"),
		sgp.baseline.grade.sequences.lags=2),
	list(
		sgp.baseline.content.areas=c("ELA", "ELA", "ELA_PSAT_10"),
		sgp.baseline.panel.years=c("2015_2016", "2016_2017", "2018_2019"),
		sgp.baseline.grade.sequences=c("7", "8", "EOCT"),
		sgp.baseline.grade.sequences.lags=c(1,2))
)
