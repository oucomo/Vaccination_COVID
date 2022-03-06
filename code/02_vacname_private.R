#  ---
#  title: Data on type of vaccine
#  date:  2020-04-15
#  LamPK, DucDH
#  ---


# load data ---------------------------------------------------------------

library(data.table)
library(lubridate)
library(tidyverse)
library(gt)
library(gtsummary)
library(readxl)

alldat <- readRDS(file = file.path("..", "tuann349_vad", "private_clinic.rds"))
alldat2 <- alldat[(vacdate >= ymd("2017-01-01")) & (vacdate < ymd("2020-12-31")) & (vacdate >= dob), .(vacname, dob, vacdate)] %>%
  mutate(age = (vacdate - dob)/dyears(1),
         vyear = year(vacdate)) %>%
  select(vacname, age, vacdate, vyear)
saveRDS(unique(alldat2), file = file.path("..", "tuann349_vad", "vacname_private.rds"))

vacname <- readRDS(file = file.path("..", "tuann349_vad", "vacname_private.rds"))
vacname2017 <- vacname[vyear==2017] %>% select(vacname, age)

tbl_summary(data = vacname2017, by = vacname)


# All vaccines --------------------------------------------------------------------

vacinfo_private <- as.data.table(
  rbind(
    cbind(vacname = "BCG",            epi = 1, shot = 1, start = 0),
    cbind(vacname = "HepBN",          epi = 1, shot = 1, start = 0),
    cbind(vacname = "DPT_HepB_Hib",   epi = 1, shot = 1, start = 2),
    cbind(vacname = "DPT_HepB_Hib",   epi = 1, shot = 2, start = 3),
    cbind(vacname = "DPT_HepB_Hib",   epi = 1, shot = 3, start = 4),
    cbind(vacname = "OPV",            epi = 1, shot = 1, start = 2),
    cbind(vacname = "OPV",            epi = 1, shot = 2, start = 3),
    cbind(vacname = "OPV",            epi = 1, shot = 3, start = 4),
    cbind(vacname = "IPV",            epi = 1, shot = 1, start = 5),
    cbind(vacname = "Measle",         epi = 1, shot = 1, start = 9),
    cbind(vacname = "Measle_Mumps_Rubella",         epi = 0, shot = 1, start = 12),
    cbind(vacname = "Measle_Rubella", epi = 1, shot = 1, start = 18),
    cbind(vacname = "DPT",            epi = 1, shot = 1, start = 18),
    cbind(vacname = "JEV",            epi = 1, shot = 1, start = 12),
    cbind(vacname = "Td",             epi = 0, shot = 1, start = 84)
  )
) %>%
  mutate(epi = as.numeric(epi),
         shot = as.numeric(shot),
         start = as.numeric(start))

vacname3 <- read_excel("data/vacname.xlsx") %>% as.data.table
save(vacinfo_private, vacname3, file = file.path("~", "updated_dataset", "vacinfo_private.Rdata"))
