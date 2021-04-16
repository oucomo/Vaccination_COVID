#  ---
#  title: Clean data (private clinic)
#  date:  2021-04-08
#  LamPK
#  ---


# library -----------------------------------------------------------------

library(readxl)
library(data.table)
library(lubridate)
library(stringi)


# data --------------------------------------------------------------------

private_clinic <- readRDS(file = file.path("..", "tuann349_vad", "private_clinic.rds"))


# clean vacname -----------------------------------------------------------

# private_vacname <- private_clinic[, list(vacname, age = (vacdate - dob)/dyears(1))][, list(age_min = min(age), age_max = max(age)), by = "vacname"]
# write.csv(private_vacname, file = file.path("..", "misc", "private_vacname.csv"))

load(file.path("..", "tuann349_vad", "vacinfo.Rdata"))
names(vacinfo) <- c("vacname2", "epi", "shot", "start")

tmp1 <- merge(vaccine_clean, vacname3[, c("vacname", "vacname2")], by = "vacname", all.x = TRUE, sort = FALSE)
tmp2 <- tmp1[, .(province, district, commune, sex, dob, vacname, vacdate, shot = order(vacdate)), by = .(pid, vacname2)][order(pid, vacname2, shot)]
tmp3 <- merge(tmp2, vacname3[, c("vacname", "tub", "heb", "dip", "per", "tes", "hib", "pol", "msl", "rub", "jev")], by = "vacname", all.x = TRUE, sort = FALSE)
tmp1 <- merge(tmp3, vacinfo, by = c("vacname2", "shot"), all.x = TRUE, sort = FALSE)
rm(list = c("tmp2", "tmp3"))
gc()
