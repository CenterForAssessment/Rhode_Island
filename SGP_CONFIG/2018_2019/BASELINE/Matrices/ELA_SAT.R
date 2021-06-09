################################################################################
###                                                                          ###
###      ELA BASELINE matrix configurations (sequential and skip-year)       ###
###                                                                          ###
################################################################################

ELA_SAT_BASELINE.config <- list(
	list(
		sgp.baseline.content.areas=c("ELA_PSAT_10", "ELA_SAT"),
		sgp.baseline.panel.years=c("2017_2018", "2018_2019"),
		sgp.baseline.grade.sequences=c("EOCT", "EOCT"),
		sgp.baseline.grade.sequences.lags=1)
)
