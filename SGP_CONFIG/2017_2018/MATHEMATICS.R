################################################################################
###                                                                          ###
###              SGP Configurations for 2018 EOCT Math subjects              ###
###                                                                          ###
################################################################################

MATHEMATICS_2017_2018.config <- list(
  MATHEMATICS.2017_2018 = list(
    sgp.content.areas=rep('MATHEMATICS', 3),
		sgp.panel.years=c('2015_2016', '2016_2017', '2017_2018'),
    sgp.grade.sequences=list(c('3', '4'), c('3', '4', '5'), c('4', '5', '6'), c('5', '6', '7'), c('6', '7', '8'))))


MATHEMATICS_PSAT_10_2017_2018.config <- list(
  MATHEMATICS_PSAT_10.2017_2018 = list(
		sgp.content.areas=c('MATHEMATICS', 'ALGEBRA_I', 'MATHEMATICS_PSAT_10'),
		sgp.panel.years=c('2015_2016', '2016_2017', '2017_2018'),
		sgp.grade.sequences=list(c('8', 'EOCT', 'EOCT')),
    sgp.exact.grade.progression=TRUE,
    sgp.projection.grade.sequences=list('NO_PROJECTIONS'),
		sgp.norm.group.preference=0L),

  MATHEMATICS_PSAT_10.2017_2018 = list(
		sgp.content.areas=c('ALGEBRA_I', 'MATHEMATICS_PSAT_10'),
		sgp.panel.years=c('2016_2017', '2017_2018'),
		sgp.grade.sequences=list(c('EOCT', 'EOCT')),
    sgp.projection.grade.sequences=list('NO_PROJECTIONS'),
		sgp.norm.group.preference=1L),

	MATHEMATICS_PSAT_10.2017_2018 = list(
		sgp.content.areas=c('ALGEBRA_I', 'GEOMETRY', 'MATHEMATICS_PSAT_10'),
		sgp.panel.years=c('2015_2016', '2016_2017', '2017_2018'),
		sgp.grade.sequences=list(c('EOCT', 'EOCT', 'EOCT')),
    sgp.exact.grade.progression=TRUE,
    sgp.projection.grade.sequences=list('NO_PROJECTIONS'),
		sgp.norm.group.preference=2L),

  MATHEMATICS_PSAT_10.2017_2018 = list(
		sgp.content.areas=c('GEOMETRY', 'MATHEMATICS_PSAT_10'),
		sgp.panel.years=c('2016_2017', '2017_2018'),
		sgp.grade.sequences=list(c('EOCT', 'EOCT')),
    sgp.projection.grade.sequences=list('NO_PROJECTIONS'),
		sgp.norm.group.preference=3L)
)


MATHEMATICS_SAT_2017_2018.config <- list(
  MATHEMATICS_SAT.2017_2018 = list(
		sgp.content.areas=c('ALGEBRA_I', 'MATHEMATICS_PSAT_10', 'MATHEMATICS_SAT'),
    sgp.panel.years = c('2015_2016', '2016_2017', '2017_2018'),
		sgp.grade.sequences=list(c('EOCT', 'EOCT', 'EOCT')),
    sgp.exact.grade.progression=TRUE,
    sgp.projection.grade.sequences=list('NO_PROJECTIONS'),
		sgp.norm.group.preference=0L),

  MATHEMATICS_SAT.2017_2018 = list(
		sgp.content.areas=c('MATHEMATICS_PSAT_10', 'MATHEMATICS_SAT'),
    sgp.panel.years = c('2016_2017', '2017_2018'),
		sgp.grade.sequences=list(c('EOCT', 'EOCT')),
    sgp.projection.grade.sequences=list('NO_PROJECTIONS'),
		sgp.norm.group.preference=1L)

  ###   Add second config for Geom to PSAT to SAT?  1848 kids ...  OR ...  better to go with single prior (7392 total in cohort)

)
