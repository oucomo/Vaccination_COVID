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

alldat <- readRDS(file = file.path("..", "tuann349_vad", "private_clinic.rds"))
alldat2 <- alldat[(vacdate >= ymd("2017-01-01")) & (vacdate < ymd("2020-12-31")) & (vacdate >= dob), .(vacname, dob, vacdate)] %>%
  mutate(age = (vacdate - dob)/dyears(1),
         vyear = year(vacdate)) %>%
  select(vacname, age, vacdate, vyear)
saveRDS(unique(alldat2), file = file.path("..", "tuann349_vad", "vacname_private.rds"))

vacname <- readRDS(file = file.path("..", "tuann349_vad", "vacname_private.rds"))
vacname2017 <- vacname[vyear==2017] %>% select(vacname, age)

tbl_summary(data = vacname2017, by = vacname)


# TCMR --------------------------------------------------------------------

# source: http://www.tiemchungmorong.vn/sites/default/files/lich_tiem_chung.jpg
# source: http://www.ninhthuan.gov.vn/chinhquyen/soyt/Admin/Huong%20dan%20su%20dung%20vac%20xin%20ComBE%20Five.pdf
# Quinvaxem: stop in 2018, change to DPT_HepB_Hib (ComBE Five)

vacinfo <- as.data.table(
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
    cbind(vacname = "Measle_Rubella", epi = 1, shot = 1, start = 18),
    cbind(vacname = "DPT",            epi = 1, shot = 1, start = 18),
    cbind(vacname = "JEV",            epi = 1, shot = 1, start = 12),
    cbind(vacname = "Td",             epi = 0, shot = 1, start = 84)
  )
) %>%
  mutate(epi = as.numeric(epi),
         shot = as.numeric(shot),
         start = as.numeric(start))

vacname2 <- as.data.table(
  rbind(
    cbind(vacname = "BCG", vacname2 = "BCG", D1 = "Tuberculosis", D2 = NA, D3 = NA, D4 = NA, D5 = NA),
    cbind(vacname = "BKT 0,1ml tu khoa (BCG)", vacname2 = "BCG", D1 = "Tuberculosis", D2 = NA, D3 = NA, D4 = NA, D5 = NA),
    cbind(vacname = "BKT 0.1ml (BCG)", vacname2 = "BCG", D1 = "Tuberculosis", D2 = NA, D3 = NA, D4 = NA, D5 = NA),
    cbind(vacname = "BKT 0.5 ml", vacname2 = "Unk", D1 = NA, D2 = NA, D3 = NA, D4 = NA, D5 = NA),
    cbind(vacname = "BKT 1 ml", vacname2 = "Unk", D1 = NA, D2 = NA, D3 = NA, D4 = NA, D5 = NA),
    cbind(vacname = "BKT 5 ml", vacname2 = "Unk", D1 = NA, D2 = NA, D3 = NA, D4 = NA, D5 = NA),
    cbind(vacname = "ComBE Five", vacname2 = "DPT_HepB_Hib", D1 = "Diptheria", D2 = "Pertussis", D3 = "Tetanus", D4 = "HepB", D5 = "Hib"),
    cbind(vacname = "DPT", vacname2 = "DPT", D1 = "Diptheria", D2 = "Pertussis", D3 = "Tetanus", D4 = NA, D5 = NA),
    cbind(vacname = "DPT-VGB-HIB (SII)", vacname2 = "DPT_HepB_Hib", D1 = "Diptheria", D2 = "Pertussis", D3 = "Tetanus", D4 = "HepB", D5 = "Hib"),
    cbind(vacname = "IPV", vacname2 = "IPV", D1 = "Polio", D2 = NA, D3 = NA, D4 = NA, D5 = NA),
    cbind(vacname = "OPV", vacname2 = "OPV", D1 = "Polio", D2 = NA, D3 = NA, D4 = NA, D5 = NA),
    cbind(vacname = "MR", vacname2 = "Measle_Rubella", D1 = "Measle", D2 = "Rubella", D3 = NA, D4 = NA, D5 = NA),
    cbind(vacname = "Soi", vacname2 = "Measle", D1 = "Measle", D2 = NA, D3 = NA, D4 = NA, D5 = NA),
    cbind(vacname = "Quinvaxem", vacname2 = "DPT_HepB_Hib", D1 = "Diptheria", D2 = "Pertussis", D3 = "Tetanus", D4 = "HepB", D5 = "Hib"),
    cbind(vacname = "Uon van", vacname2 = "Tetanus", D1 = "Tetanus", D2 = NA, D3 = NA, D4 = NA, D5 = NA),
    cbind(vacname = "Vac xin uon van bach hau hap phu (Td) (Hop 10 lo 5ml)", vacname2 = "Td", D1 = "Diptheria", D2 = "Tetanus", D3 = NA, D4 = NA, D5 = NA),
    cbind(vacname = "VAT (Lo 20 lieu)", vacname2 = "VAT", D1 = "Tetanus", D2 = NA, D3 = NA, D4 = NA, D5 = NA),
    cbind(vacname = "Viem gan B", vacname2 = "HepBN", D1 = "HepB", D2 = NA, D3 = NA, D4 = NA, D5 = NA),
    cbind(vacname = "Viem gan B so sinh", vacname2 = "HepBN", D1 = "HepB", D2 = NA, D3 = NA, D4 = NA, D5 = NA),
    cbind(vacname = "VNNB", vacname2 = "JEV", D1 = "JEV", D2 = NA, D3 = NA, D4 = NA, D5 = NA)
  )
)

vacname3 <- as.data.table(
  rbind(
    cbind(vacname = "BCG",                     vacname2 = "BCG",            tub = 1, heb = 0, dip = 0, per = 0, tes = 0, hib = 0, pol = 0, msl = 0, rub = 0, jev = 0),
    cbind(vacname = "BKT 0,1ml tu khoa (BCG)", vacname2 = NA,               tub = 0, heb = 0, dip = 0, per = 0, tes = 0, hib = 0, pol = 0, msl = 0, rub = 0, jev = 0),
    cbind(vacname = "BKT 0.1ml (BCG)",         vacname2 = NA,               tub = 0, heb = 0, dip = 0, per = 0, tes = 0, hib = 0, pol = 0, msl = 0, rub = 0, jev = 0),
    cbind(vacname = "BKT 0.5 ml",              vacname2 = NA,               tub = 0, heb = 0, dip = 0, per = 0, tes = 0, hib = 0, pol = 0, msl = 0, rub = 0, jev = 0),
    cbind(vacname = "BKT 1 ml",                vacname2 = NA,               tub = 0, heb = 0, dip = 0, per = 0, tes = 0, hib = 0, pol = 0, msl = 0, rub = 0, jev = 0),
    cbind(vacname = "BKT 5 ml",                vacname2 = NA,               tub = 0, heb = 0, dip = 0, per = 0, tes = 0, hib = 0, pol = 0, msl = 0, rub = 0, jev = 0),
    cbind(vacname = "ComBE Five",              vacname2 = "DPT_HepB_Hib",   tub = 0, heb = 1, dip = 1, per = 1, tes = 1, hib = 1, pol = 0, msl = 0, rub = 0, jev = 0),
    cbind(vacname = "DPT",                     vacname2 = "DPT",            tub = 0, heb = 0, dip = 1, per = 1, tes = 1, hib = 0, pol = 0, msl = 0, rub = 0, jev = 0),
    cbind(vacname = "DPT-VGB-HIB (SII)",       vacname2 = "DPT_HepB_Hib",   tub = 0, heb = 1, dip = 1, per = 1, tes = 1, hib = 1, pol = 0, msl = 0, rub = 0, jev = 0),
    cbind(vacname = "IPV",                     vacname2 = "IPV",            tub = 0, heb = 0, dip = 0, per = 0, tes = 0, hib = 0, pol = 1, msl = 0, rub = 0, jev = 0),
    cbind(vacname = "OPV",                     vacname2 = "OPV",            tub = 0, heb = 0, dip = 0, per = 0, tes = 0, hib = 0, pol = 1, msl = 0, rub = 0, jev = 0),
    cbind(vacname = "MR",                      vacname2 = "Measle_Rubella", tub = 0, heb = 0, dip = 0, per = 0, tes = 0, hib = 0, pol = 0, msl = 1, rub = 1, jev = 0),
    cbind(vacname = "Soi",                     vacname2 = "Measle",         tub = 0, heb = 0, dip = 0, per = 0, tes = 0, hib = 0, pol = 0, msl = 1, rub = 0, jev = 0),
    cbind(vacname = "Quinvaxem",               vacname2 = "DPT_HepB_Hib",   tub = 0, heb = 1, dip = 1, per = 1, tes = 1, hib = 1, pol = 0, msl = 0, rub = 0, jev = 0),
    cbind(vacname = "Uon van",                 vacname2 = "Tetanus",        tub = 0, heb = 0, dip = 0, per = 0, tes = 1, hib = 0, pol = 0, msl = 0, rub = 0, jev = 0),
    cbind(vacname = "Vac xin uon van bach hau hap phu (Td) (Hop 10 lo 5ml)", vacname2 = "Td", tub = 0, heb = 0, dip = 1, per = 0, tes = 1, hib = 0, pol = 0, msl = 0, rub = 0, jev = 0),
    cbind(vacname = "VAT (Lo 20 lieu)",        vacname2 = "Tetanus",            tub = 0, heb = 0, dip = 0, per = 0, tes = 1, hib = 0, pol = 0, msl = 0, rub = 0, jev = 0),
    cbind(vacname = "Viem gan B",              vacname2 = "HepBN",          tub = 0, heb = 1, dip = 0, per = 0, tes = 0, hib = 0, pol = 0, msl = 0, rub = 0, jev = 0),
    cbind(vacname = "Viem gan B so sinh",      vacname2 = "HepBN",          tub = 0, heb = 1, dip = 0, per = 0, tes = 0, hib = 0, pol = 0, msl = 0, rub = 0, jev = 0),
    cbind(vacname = "VNNB",                    vacname2 = "JEV",            tub = 0, heb = 0, dip = 0, per = 0, tes = 0, hib = 0, pol = 0, msl = 0, rub = 0, jev = 1)
  )
) %>%
  mutate(tub = as.numeric(tub),
         heb = as.numeric(heb),
         dip = as.numeric(dip),
         per = as.numeric(per),
         tes = as.numeric(tes),
         hib = as.numeric(hib),
         pol = as.numeric(pol),
         msl = as.numeric(msl),
         rub = as.numeric(rub),
         jev = as.numeric(jev))


save(vacinfo, vacname2, vacname3, file = file.path("..", "tuann349_vad", "vacinfo.Rdata"))
