################################################################################
###                                                                          ###
###              SGP Configurations for 2018 EOCT ELA subjects               ###
###                                                                          ###
################################################################################

ELA_2017_2018.config <- list(
  ELA.2017_2018 = list(
    sgp.content.areas=rep('ELA', 3),
		sgp.panel.years=c('2015_2016', '2016_2017', '2017_2018'),
    sgp.grade.sequences=list(c('3', '4'), c('3', '4', '5'), c('4', '5', '6'), c('5', '6', '7'), c('6', '7', '8'))))


ELA_PSAT_10_2017_2018.config <- list(
  ELA_PSAT_10.2017_2018 = list(
		sgp.content.areas=c('ELA', 'ELA', 'ELA_PSAT_10'),
		sgp.panel.years=c('2015_2016', '2016_2017', '2017_2018'),
		sgp.grade.sequences=list(c('8', '9', 'EOCT')),
    sgp.exact.grade.progression=TRUE,
    sgp.projection.grade.sequences=list('NO_PROJECTIONS'),
		sgp.norm.group.preference=0L),

	ELA_PSAT_10.2017_2018 = list(
		sgp.content.areas=c('ELA', 'ELA_PSAT_10'),
		sgp.panel.years=c('2016_2017', '2017_2018'),
		sgp.grade.sequences=list(c('9', 'EOCT')),
    sgp.projection.grade.sequences=list('NO_PROJECTIONS'),
		sgp.norm.group.preference=1L)
)


ELA_SAT_2017_2018.config <- list(
  ELA_SAT.2017_2018 = list(
		sgp.content.areas=c('ELA', 'ELA_PSAT_10', 'ELA_SAT'),
		sgp.panel.years=c('2015_2016', '2016_2017', '2017_2018'),
		sgp.grade.sequences=list(c('9', 'EOCT', 'EOCT')),
    sgp.exact.grade.progression=TRUE,
    sgp.projection.grade.sequences=list('NO_PROJECTIONS'),
		sgp.norm.group.preference=0L),

	ELA_SAT.2017_2018 = list(
		sgp.content.areas=c('ELA_PSAT_10', 'ELA_SAT'),
		sgp.panel.years=c('2016_2017', '2017_2018'),
		sgp.grade.sequences=list(c('EOCT', 'EOCT')),
    sgp.projection.grade.sequences=list('NO_PROJECTIONS'),
		sgp.norm.group.preference=1L)

  ###   Add skip year 9th grade to SAT?  1353 kids... (8313 total in cohort)
)
