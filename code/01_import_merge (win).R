<<<<<<< HEAD
<<<<<<< HEAD
#  ---
#  title: Import data
#  date:  2020-01-31
#  LamPK, DucDH
#  ---

Sys.setlocale("LC_CTYPE", locale="Vietnamese")

library(readxl)
library(data.table)
library(lubridate)
library(stringi)
library(reticulate)

## handle non-native file paths
wd <- file.path("..", "tuann349")
filename <- gsub(paste0(wd,"/"),"",rstudioapi::getActiveDocumentContext()$path)

os <- import("os")
listdir <- os$listdir(wd)
listdir <- listdir[!listdir %in% c(".bak", filename)]
listdir_translit <- stringi::stri_trans_general(listdir, "latin-ascii")

for (i in seq_along(listdir)) file.rename(listdir[[i]], listdir_translit[[i]])

## list all files
data_path <- file.path("..", "tuann349")
files <- list.files(path = data_path, recursive = TRUE)

## import and combine files
dir.create(path = file.path("..", "tuann349_vad"))
dat <- NULL
for (i in c(1:length(files))) {
  cat(i, "\n")

  ## read from excel
  dati <- as.data.table(read_excel(path = file.path(data_path, files[i]), sheet = 1))

  ### remove duplication
  dati <- unique(dati, by = c("MA_DOI_TUONG", "TENTINH", "TENHUYEN", "TENXA", "NGAY_SINH", "GIOI_TINH", "TEN_VACXIN", "NGAY_TIEM"))

  ## rename
  setnames(x = dati,
           old = c("MA_DOI_TUONG", "TENTINH", "TENHUYEN", "TENXA", "NGAY_SINH", "GIOI_TINH", "TEN_VACXIN", "NGAY_TIEM"),
           new = c("pid", "province", "district", "commune", "dob", "sex", "vacname", "vacdate"))

  ## remove accent
  dati$province <- stri_trans_general(dati$province, "Latin-ASCII")
  dati$district <- stri_trans_general(dati$district, "Latin-ASCII")
  dati$commune <- stri_trans_general(dati$commune, "Latin-ASCII")
  dati$vacname <- stri_trans_general(dati$vacname, "Latin-ASCII")

  ### format date
  dati$dob <- dmy(dati$dob)
  dati$vacdate <- dmy(dati$vacdate)

  ## add source
  dati$file = files[i]

  ## combind
  dat <- rbindlist(l = list(dat, dati))
}

### additional variables
dat$ddif <- (dat$vacdate - dat$dob)/ddays(1)

### children data
child <- unique(dat[,  .(pid, province, district, commune, dob, sex, file)])

### vaccine data
vaccine <- unique(dat[,  .(pid, province, district, commune, vacname, vacdate, ddif)])

### save
saveRDS(dat, file = file.path("..", "tuann349_vad", "alldat.rds"))
fwrite(x = dat, file = file.path("..", "tuann349_vad", "alldat.csv"))

saveRDS(child, file = file.path("..", "tuann349_vad", "child.rds"))
fwrite(x = child, file = file.path("..", "tuann349_vad", "child.csv"))

saveRDS(vaccine, file = file.path("..", "tuann349_vad", "vaccine.rds"))
fwrite(x = vaccine, file = file.path("..", "tuann349_vad", "vaccine.csv"))
=======
#  ---
#  title: Import data
#  date:  2020-01-31
#  LamPK, DucDH
#  ---

Sys.setlocale("LC_CTYPE", locale="Vietnamese")

library(readxl)
library(data.table)
library(lubridate)
library(stringi)
library(reticulate)

## handle non-native file paths
wd <- file.path("..", "tuann349")
filename <- gsub(paste0(wd,"/"),"",rstudioapi::getActiveDocumentContext()$path)

os <- import("os")
listdir <- os$listdir(wd)
listdir <- listdir[!listdir %in% c(".bak", filename)]
listdir_translit <- stringi::stri_trans_general(listdir, "latin-ascii")

for (i in seq_along(listdir)) file.rename(listdir[[i]], listdir_translit[[i]])

## list all files
data_path <- file.path("..", "tuann349")
files <- list.files(path = data_path, recursive = TRUE)

## import and combine files
dir.create(path = file.path("..", "tuann349_vad"))
dat <- NULL
for (i in c(1:length(files))) {
  cat(i, "\n")

  ## read from excel
  dati <- as.data.table(read_excel(path = file.path(data_path, files[i]), sheet = 1))

  ### remove duplication
  dati <- unique(dati, by = c("MA_DOI_TUONG", "TENTINH", "TENHUYEN", "TENXA", "NGAY_SINH", "GIOI_TINH", "TEN_VACXIN", "NGAY_TIEM"))

  ## rename
  setnames(x = dati,
           old = c("MA_DOI_TUONG", "TENTINH", "TENHUYEN", "TENXA", "NGAY_SINH", "GIOI_TINH", "TEN_VACXIN", "NGAY_TIEM"),
           new = c("pid", "province", "district", "commune", "dob", "sex", "vacname", "vacdate"))

  ## remove accent
  dati$province <- stri_trans_general(dati$province, "Latin-ASCII")
  dati$district <- stri_trans_general(dati$district, "Latin-ASCII")
  dati$commune <- stri_trans_general(dati$commune, "Latin-ASCII")
  dati$vacname <- stri_trans_general(dati$vacname, "Latin-ASCII")

  ### format date
  dati$dob <- dmy(dati$dob)
  dati$vacdate <- dmy(dati$vacdate)

  ## add source
  dati$file = files[i]

  ## combind
  dat <- rbindlist(l = list(dat, dati))
}

### additional variables
dat$ddif <- (dat$vacdate - dat$dob)/ddays(1)

### children data
child <- unique(dat[,  .(pid, province, district, commune, dob, sex, file)])

### vaccine data
vaccine <- unique(dat[,  .(pid, province, district, commune, vacname, vacdate, ddif)])

### save
saveRDS(dat, file = file.path("..", "tuann349_vad", "alldat.rds"))
fwrite(x = dat, file = file.path("..", "tuann349_vad", "alldat.csv"))

saveRDS(child, file = file.path("..", "tuann349_vad", "child.rds"))
fwrite(x = child, file = file.path("..", "tuann349_vad", "child.csv"))

saveRDS(vaccine, file = file.path("..", "tuann349_vad", "vaccine.rds"))
fwrite(x = vaccine, file = file.path("..", "tuann349_vad", "vaccine.csv"))
>>>>>>> d8e64a76160c4a3384d35c38654e2c969ee4e55e
=======
#  ---
#  title: Import data
#  date:  2020-01-31
#  LamPK, DucDH
#  ---

#Sys.setlocale("LC_CTYPE", locale="Vietnamese")

library(readxl)
library(data.table)
library(lubridate)
library(stringi)
library(reticulate)

## handle non-native file paths
wd <- file.path("..", "..", "tuann349")
filename <- gsub(paste0(wd,"/"),"",rstudioapi::getActiveDocumentContext()$path)
setwd(wd)

os <- import("os")
listdir <- os$listdir(wd)
listdir <- listdir[!listdir %in% c(".bak", filename)]
listdir_translit <- stringi::stri_trans_general(listdir, "latin-ascii")

for (i in seq_along(listdir)) file.rename(listdir[[i]], listdir_translit[[i]])

## list all files
data_path <- file.path("..", "tuann349")
files <- list.files(path = data_path, recursive = TRUE)

## import and combine files
dir.create(path = file.path("..", "tuann349_vad"))
dat <- NULL
for (i in c(1:length(files))) {
  cat(i, "\n")

  ## read from excel
  dati <- as.data.table(read_excel(path = file.path(data_path, files[i]), sheet = 1))

  ### remove duplication
  dati <- unique(dati, by = c("MA_DOI_TUONG", "TENTINH", "TENHUYEN", "TENXA", "NGAY_SINH", "GIOI_TINH", "TEN_VACXIN", "NGAY_TIEM"))

  ## rename
  setnames(x = dati,
           old = c("MA_DOI_TUONG", "TENTINH", "TENHUYEN", "TENXA", "NGAY_SINH", "GIOI_TINH", "TEN_VACXIN", "NGAY_TIEM"),
           new = c("pid", "province", "district", "commune", "dob", "sex", "vacname", "vacdate"))

  ## remove accent
  dati$province <- stri_trans_general(dati$province, "Latin-ASCII")
  dati$district <- stri_trans_general(dati$district, "Latin-ASCII")
  dati$commune <- stri_trans_general(dati$commune, "Latin-ASCII")
  dati$vacname <- stri_trans_general(dati$vacname, "Latin-ASCII")

  ### format date
  dati$dob <- dmy(dati$dob)
  dati$vacdate <- dmy(dati$vacdate)

  ## add source
  dati$file = files[i]

  ## combind
  dat <- rbindlist(l = list(dat, dati))
}

### additional variables
dat$ddif <- (dat$vacdate - dat$dob)/ddays(1)

### children data
child <- unique(dat[,  .(pid, province, district, commune, dob, sex, file)])

### vaccine data
vaccine <- unique(dat[,  .(pid, province, district, commune, vacname, vacdate, ddif)])

### save
saveRDS(dat, file = file.path("..", "tuann349_vad", "alldat.rds"))
fwrite(x = dat, file = file.path("..", "tuann349_vad", "alldat.csv"))

saveRDS(child, file = file.path("..", "tuann349_vad", "child.rds"))
fwrite(x = child, file = file.path("..", "tuann349_vad", "child.csv"))

saveRDS(vaccine, file = file.path("..", "tuann349_vad", "vaccine.rds"))
fwrite(x = vaccine, file = file.path("..", "tuann349_vad", "vaccine.csv"))
>>>>>>> e81b63287dfd9b182a5658b6dee59e2e81b780f3
