################################################################################
###                                                                          ###
###              SGP Configurations for 2017 EOCT ELA subjects               ###
###                                                                          ###
################################################################################

ELA_2016_2017.config <- list(
  ELA.2015_2016 = list(
    sgp.content.areas=rep('ELA', 3),
		sgp.panel.years=c('2014_2015', '2015_2016', '2016_2017'),
    sgp.grade.sequences=list(c('3', '4'), c('3', '4', '5'), c('4', '5', '6'), c('5', '6', '7'), c('6', '7', '8'), c('7', '8', '9'))))


PSAT_EBRW_2016_2017.config <- list(
	PSAT_EBRW.2016_2017 = list(
		sgp.content.areas=c('ELA', 'ELA', 'PSAT_EBRW'),
		sgp.panel.years=c('2014_2015', '2015_2016', '2016_2017'),
		sgp.grade.sequences=list(c('9', '10', 'EOCT')),
		sgp.exact.grade.progression=TRUE,
    sgp.projection.grade.sequences=list('NO_PROJECTIONS'),
		sgp.norm.group.preference=0L),

	PSAT_EBRW.2016_2017 = list(
		sgp.content.areas=c('ELA', 'PSAT_EBRW'),
		sgp.panel.years=c('2015_2016', '2016_2017'),
		sgp.grade.sequences=list(c('10', 'EOCT')),
		sgp.exact.grade.progression=TRUE,
    sgp.projection.grade.sequences=list('NO_PROJECTIONS'),
		sgp.norm.group.preference=1L),

	PSAT_EBRW.2016_2017 = list(
		sgp.content.areas=c('ELA', 'ELA', 'PSAT_EBRW'),
		sgp.panel.years=c('2014_2015', '2015_2016', '2016_2017'),
		sgp.grade.sequences=list(c('8', '9', 'EOCT')),
		sgp.exact.grade.progression=TRUE,
    sgp.projection.grade.sequences=list('NO_PROJECTIONS'),
		sgp.norm.group.preference=2L),

	PSAT_EBRW.2016_2017 = list(
		sgp.content.areas=c('ELA', 'PSAT_EBRW'),
		sgp.panel.years=c('2015_2016', '2016_2017'),
		sgp.grade.sequences=list(c('9', 'EOCT')),
		sgp.exact.grade.progression=TRUE,
    sgp.projection.grade.sequences=list('NO_PROJECTIONS'),
		sgp.norm.group.preference=3L),

	PSAT_EBRW.2016_2017 = list(
		sgp.content.areas=c('ELA', 'PSAT_EBRW'),
		sgp.panel.years=c('2014_2015', '2016_2017'),
		sgp.grade.sequences=list(c('8', 'EOCT')),
		sgp.exact.grade.progression=TRUE,
    sgp.projection.grade.sequences=list('NO_PROJECTIONS'),
		sgp.norm.group.preference=4L))
