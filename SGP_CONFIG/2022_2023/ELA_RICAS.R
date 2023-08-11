################################################################################
###                                                                          ###
###              SGP Configurations for 2022-2023 ELA RICAS                  ###
###                                                                          ###
################################################################################

ELA_RICAS_2022_2023.config <- list(
	ELA_RICAS.2022_2023 = list(
		sgp.content.areas=rep('ELA', 3),
		sgp.panel.years=c('2020_2021', '2021_2022', '2022_2023'),
		sgp.grade.sequences=list(c('3', '4'), c('3', '4', '5'), c('4', '5', '6'), c('5', '6', '7'), c('7', '8')))) ### Using single prior 8th grade analyses to get median SGP of 50

ELA_RICAS_Baseline_2022_2023.config <- list(
        ELA_Baseline.2022 = list(
                sgp.content.areas=rep('ELA', 3),
                sgp.panel.years=c('2020_2021', '2021_2022', '2022_2023'),
                sgp.grade.sequences=list(c('3', '4'), c('3', '4', '5'), c('4', '5', '6'), c('5', '6', '7'), c('6', '7', '8')))
)
