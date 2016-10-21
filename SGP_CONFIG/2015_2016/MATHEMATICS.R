MATHEMATICS_2015_2016.config <- list(
    MATHEMATICS.2015_2016 = list(
                sgp.content.areas=rep('MATHEMATICS', 2),
                sgp.panel.years=paste(2014:2015, 2015:2016, sep="_"),
                sgp.grade.sequences=list(c('3', '4'), c('4', '5'), c('5', '6'), c('6', '7'), c('7', '8'))),
	ALGEBRA_I.2015_2016 = list(
                sgp.content.areas=c(rep('MATHEMATICS', 1), 'ALGEBRA_I'),
                sgp.panel.years=paste(2014:2015, 2015:2016, sep="_"),
                sgp.grade.sequences=list(c('7', 'EOCT'), c('8', 'EOCT'))),
	GEOMETRY.2015_2016 = list(
                sgp.content.areas=c('ALGEBRA_I', 'GEOMETRY'),
                sgp.panel.years=paste(2014:2015, 2015:2016, sep="_"),
                sgp.grade.sequences=list(c('EOCT', 'EOCT'))))
