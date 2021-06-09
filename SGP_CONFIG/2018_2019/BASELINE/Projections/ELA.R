#####################################################################################
###                                                                               ###
###     Configurations for STRAIGHT (skip-year) ELA projections in 2018-2019      ###
###                                                                               ###
#####################################################################################

ELA_2018_2019.config <- list(
    ELA.2018_2019 = list(
        sgp.content.areas=rep("ELA", 2),
        sgp.baseline.content.areas=rep("ELA", 2),
        sgp.panel.years=c("2016_2017", "2018_2019"),
        sgp.baseline.panel.years=c("2016_2017", "2018_2019"),
        sgp.grade.sequences=list(c("3", "5")),
        sgp.baseline.grade.sequences=list(c("3", "5")),
        sgp.projection.baseline.content.areas="ELA",
        sgp.projection.baseline.panel.years="2018_2019",
        sgp.projection.baseline.grade.sequences=list(c("3")),
        sgp.projection.sequence="ELA_GRADE_3"),
    ELA.2018_2019 = list(
        sgp.content.areas=rep("ELA", 3),
        sgp.baseline.content.areas=rep("ELA", 3),
        sgp.baseline.panel.years=c("2015_2016", "2016_2017", "2018_2019"),
        sgp.panel.years=c("2015_2016", "2016_2017", "2018_2019"),
        sgp.grade.sequences=list(c("3", "4", "6")),
        sgp.baseline.grade.sequences=list(c("3", "4", "6")),
        sgp.projection.baseline.content.areas=rep("ELA", 2),
        sgp.projection.baseline.panel.years=c("2017_2018", "2018_2019"),
        sgp.projection.baseline.grade.sequences=list(c("3", "4")),
        sgp.projection.sequence="ELA_GRADE_4"),
    ELA.2018_2019 = list(
        sgp.content.areas=rep("ELA", 3),
        sgp.baseline.content.areas=rep("ELA", 3),
        sgp.baseline.panel.years=c("2015_2016", "2016_2017", "2018_2019"),
        sgp.panel.years=c("2015_2016", "2016_2017", "2018_2019"),
        sgp.grade.sequences=list(c("4", "5", "7")),
        sgp.baseline.grade.sequences=list(c("4", "5", "7")),
        sgp.projection.baseline.content.areas=rep("ELA", 2),
        sgp.projection.baseline.panel.years=c("2017_2018", "2018_2019"),
        sgp.projection.baseline.grade.sequences=list(c("4", "5")),
        sgp.projection.sequence="ELA_GRADE_5"),
    ELA.2018_2019 = list(
        sgp.content.areas=rep("ELA", 3),
        sgp.baseline.content.areas=rep("ELA", 3),
        sgp.baseline.panel.years=c("2015_2016", "2016_2017", "2018_2019"),
        sgp.panel.years=c("2015_2016", "2016_2017", "2018_2019"),
        sgp.grade.sequences=list(c("5", "6", "8")),
        sgp.baseline.grade.sequences=list(c("5", "6", "8")),
        sgp.projection.baseline.content.areas=rep("ELA", 2),
        sgp.projection.baseline.panel.years=c("2017_2018", "2018_2019"),
        sgp.projection.baseline.grade.sequences=list(c("5", "6")),
        sgp.projection.sequence="ELA_GRADE_6"),
    ELA.2018_2019 = list(
        sgp.content.areas=c("ELA", "ELA", "ELA_PSAT_10"),
        sgp.baseline.content.areas=c("ELA", "ELA", "ELA_PSAT_10"),
        sgp.baseline.panel.years=c("2015_2016", "2016_2017", "2018_2019"),
        sgp.panel.years=c("2015_2016", "2016_2017", "2018_2019"),
        sgp.grade.sequences=list(c("7", "8", "EOCT")),
        sgp.baseline.grade.sequences=list(c("7", "8", "EOCT")),
        sgp.projection.baseline.content.areas=rep("ELA", 2),
        sgp.projection.baseline.panel.years=c("2017_2018", "2018_2019"),
        sgp.projection.baseline.grade.sequences=list(c("7", "8")),
        sgp.projection.sequence="ELA_GRADE_8")
)
