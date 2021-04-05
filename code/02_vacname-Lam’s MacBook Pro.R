#  ---
#  title: Data on type of vaccine
#  date:  2020-02-02
#  LamPK
#  ---


# load data ---------------------------------------------------------------

library(data.table)
library(lubridate)
library(tidyverse)

alldat <- readRDS(file = file.path("..", "tuann349_vad", "alldat.rds"))
alldat2 <- alldat[(vacdate >= ymd("2017-01-01")) & (vacdate < ymd("2021-01-26")) & (vacdate >= dob), .(vacname, dob, vacdate)] %>%
  mutate(age = (vacdate - dob)/dyears(1)) %>%
  select(vacname, age)
saveRDS(unique(alldat2), file = file.path("..", "tuann349_vad", "vacname.rds"))

vacname <- readRDS(file = file.path("..", "tuann349_vad", "vacname.rds"))
