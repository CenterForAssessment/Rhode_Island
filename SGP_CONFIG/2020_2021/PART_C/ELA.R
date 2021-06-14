#####
###   Configurations for calculating LAGGED PROJECTIONS in 2020-2021
#####


ELA_2020_2021.config <- list(
     ELA.2020_2021 = list(
                 sgp.content.areas=c("ELA", "ELA"),
                 sgp.baseline.content.areas=c("ELA", "ELA"),
                 sgp.panel.years=c("2018_2019", "2020_2021"),
                 sgp.baseline.panel.years=c("2018_2019", "2020_2021"),
                 sgp.grade.sequences=list(c("3", "5")),
                 sgp.baseline.grade.sequences=list(c("3", "5")),
                 sgp.projection.sequence="ELA_GRADE_5"),
     ELA.2020_2021 = list(
                 sgp.content.areas=c("ELA", "ELA", "ELA"),
                 sgp.baseline.content.areas=c("ELA", "ELA", "ELA"),
                 sgp.baseline.panel.years=c("2017_2018", "2018_2019", "2020_2021"),
                 sgp.panel.years=c("2017_2018", "2018_2019", "2020_2021"),
                 sgp.grade.sequences=list(c("3", "4", "6")),
                 sgp.baseline.grade.sequences=list(c("3", "4", "6")),
                 sgp.projection.sequence="ELA_GRADE_6"),
     ELA.2020_2021 = list(
                 sgp.content.areas=c("ELA", "ELA", "ELA"),
                 sgp.baseline.content.areas=c("ELA", "ELA", "ELA"),
                 sgp.baseline.panel.years=c("2017_2018", "2018_2019", "2020_2021"),
                 sgp.panel.years=c("2017_2018", "2018_2019", "2020_2021"),
                 sgp.grade.sequences=list(c("4", "5", "7")),
                 sgp.baseline.grade.sequences=list(c("4", "5", "7")),
                 sgp.projection.sequence="ELA_GRADE_7"),
     ELA.2020_2021 = list(
                 sgp.content.areas=c("ELA", "ELA", "ELA"),
                 sgp.baseline.content.areas=c("ELA", "ELA", "ELA"),
                 sgp.baseline.panel.years=c("2017_2018", "2018_2019", "2020_2021"),
                 sgp.panel.years=c("2017_2018", "2018_2019", "2020_2021"),
                 sgp.grade.sequences=list(c("5", "6", "8")),
                 sgp.baseline.grade.sequences=list(c("5", "6", "8")),
                 sgp.projection.sequence="ELA_GRADE_8"),
     ELA.2020_2021 = list(
                 sgp.content.areas=c("ELA", "ELA", "ELA_PSAT_10"),
                 sgp.baseline.content.areas=c("ELA", "ELA", "ELA_PSAT_10"),
                 sgp.baseline.panel.years=c("2017_2018", "2018_2019", "2020_2021"),
                 sgp.panel.years=c("2017_2018", "2018_2019", "2020_2021"),
                 sgp.grade.sequences=list(c("7", "8", "EOCT")),
                 sgp.baseline.grade.sequences=list(c("7", "8", "EOCT")),
                 sgp.projection.sequence="ELA_GRADE_10")
)
