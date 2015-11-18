MATHEMATICS_2014_2015.config <- list(
    MATHEMATICS.2015 = list(
                sgp.content.areas=rep('MATHEMATICS', 6),
                sgp.panel.years=paste(2009:2014, 2010:2015, sep="_"),
                sgp.grade.sequences=list(c('3', '4'), c('3', '4', '5'), c('3', '4', '5', '6'), c('3', '4', '5', '6', '7'), c('3', '4', '5', '6', '7', '8'))),
	GEOMETRY.2015 = list(
                sgp.content.areas=c(rep('MATHEMATICS', 5), 'GEOMETRY'),
                sgp.panel.years=paste(2009:2014, 2010:2015, sep="_"),
                sgp.grade.sequences=list(c('3', '4', '5', '6', '8', 'EOCT')),
                sgp.projection.grade.sequences=as.list("NO_PROJECTIONS")),
	ALGEBRA_I.2015 = list(
                sgp.content.areas=c(rep('MATHEMATICS', 5), 'ALGEBRA_I'),
                sgp.panel.years=paste(2009:2014, 2010:2015, sep="_"),
                sgp.grade.sequences=list(c('3', '4', '5', '6', '7', 'EOCT'), c('4', '5', '6', '7', '8', 'EOCT')),
                sgp.projection.grade.sequences=as.list(rep("NO_PROJECTIONS", 2))))
