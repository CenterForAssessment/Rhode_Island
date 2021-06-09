#####################################################################################
###                                                                               ###
###     Configurations for STRAIGHT (skip-year) ELA projections in 2018-2019      ###
###                                                                               ###
#####################################################################################

ELA_PSAT_10_2018_2019.config <- list(
    ELA.2018_2019 = list(
        sgp.content.areas=c("ELA", "ELA_PSAT_10"),
        sgp.baseline.content.areas=c("ELA", "ELA_PSAT_10"),
        sgp.panel.years=c("2016_2017", "2018_2019"),
        sgp.baseline.panel.years=c("2016_2017", "2018_2019"),
        sgp.grade.sequences=list(c("8", "EOCT")),
        sgp.baseline.grade.sequences=list(c("8", "EOCT")),
        sgp.projection.baseline.content.areas="ELA",
        sgp.projection.baseline.panel.years="2018_2019",
        sgp.projection.baseline.grade.sequences=list(c("8")),
        sgp.projection.sequence="ELA_GRADE_8")
)
