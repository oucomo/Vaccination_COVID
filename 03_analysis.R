#  ---
#  title: Analysis
#  date:  2020-02-21
#  LamPK
#  ---


# library -----------------------------------------------------------------

library(data.table)
library(tidyverse)
library(lubridate)
library(ggplot2)
library(gt)
library(gtsummary)


# Quick look at vaccine shots ---------------------------------------------

vaccine_vad <- readRDS(file = file.path("..", "tuann349_vad", "vaccine_vad.rds"))
vaccine_overall <- vaccine_vad[, .N, by = .(vyear, vmonth)]
vaccine_province <- vaccine_vad[, .N, by = .(vyear, vmonth, province)]
vaccine_vacname <- vaccine_vad[, .N, by = .(vyear, vmonth, vacname2)]
vaccine_province_vacname <- vaccine_vad[, .N, by = .(vyear, vmonth, province, vacname2)]
vaccine_sum <- list(
  province = vaccine_vad[, .N, by = .(province)],
  vacname = vaccine_vad[, .N, by = .(vacname2)],
  year = vaccine_vad[, .N, by = .(vyear)]
)
save(vaccine_overall, vaccine_province, vaccine_vacname, vaccine_province_vacname, vaccine_sum, file = file.path("..", "tuann349_vad", "vaccine.Rdata"))

