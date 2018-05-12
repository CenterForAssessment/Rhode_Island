################################################################################
###                                                                          ###
###              SGP Configurations for 2017 EOCT Math subjects              ###
###                                                                          ###
################################################################################

MATHEMATICS_2016_2017.config <- list(
  MATHEMATICS.2015_2016 = list(
    sgp.content.areas=rep('MATHEMATICS', 3),
		sgp.panel.years=c('2014_2015', '2015_2016', '2016_2017'),
    sgp.grade.sequences=list(c('3', '4'), c('3', '4', '5'), c('4', '5', '6'), c('5', '6', '7'), c('6', '7', '8'))))

ALGEBRA_I_2016_2017.config <- list(
	ALGEBRA_I.2015_2016 = list(
    sgp.content.areas=c(rep('MATHEMATICS', 2), 'ALGEBRA_I'),
		sgp.panel.years=c('2014_2015', '2015_2016', '2016_2017'),
    sgp.grade.sequences=list(c('6', '7', 'EOCT'), c('7', '8', 'EOCT'))))

GEOMETRY_2016_2017.config <- list(
	GEOMETRY.2015_2016 = list(
    sgp.content.areas=c('MATHEMATICS', 'ALGEBRA_I', 'GEOMETRY'),
		sgp.panel.years=c('2014_2015', '2015_2016', '2016_2017'),
    sgp.grade.sequences=list(c('7', 'EOCT', 'EOCT'))))


PSAT_MATH_2016_2017.config <- list(
	PSAT_MATH.2016_2017 = list(
		sgp.content.areas=c('ALGEBRA_I', 'GEOMETRY', 'PSAT_MATH'),
		sgp.panel.years=c('2014_2015', '2015_2016', '2016_2017'),
		sgp.grade.sequences=list(c('EOCT', 'EOCT', 'EOCT')),
		sgp.exact.grade.progression=TRUE,
    sgp.projection.grade.sequences=list('NO_PROJECTIONS'),
		sgp.norm.group.preference=0L),

	PSAT_MATH.2016_2017 = list(
		sgp.content.areas=c('GEOMETRY', 'PSAT_MATH'),
		sgp.panel.years=c('2015_2016', '2016_2017'),
		sgp.grade.sequences=list(c('EOCT', 'EOCT')),
		sgp.exact.grade.progression=TRUE,
    sgp.projection.grade.sequences=list('NO_PROJECTIONS'),
		sgp.norm.group.preference=1L),

	PSAT_MATH.2016_2017 = list(
		sgp.content.areas=c('MATHEMATICS', 'ALGEBRA_I', 'PSAT_MATH'),
		sgp.panel.years=c('2014_2015', '2015_2016', '2016_2017'),
		sgp.grade.sequences=list(c('8', 'EOCT', 'EOCT')),
		sgp.exact.grade.progression=TRUE,
    sgp.projection.grade.sequences=list('NO_PROJECTIONS'),
		sgp.norm.group.preference=3L),

	PSAT_MATH.2016_2017 = list(
		sgp.content.areas=c('ALGEBRA_I', 'PSAT_MATH'),
		sgp.panel.years=c('2015_2016', '2016_2017'),
		sgp.grade.sequences=list(c('EOCT', 'EOCT')),
		sgp.exact.grade.progression=TRUE,
		sgp.projection.grade.sequences=list('NO_PROJECTIONS'),
		sgp.norm.group.preference=4L))
