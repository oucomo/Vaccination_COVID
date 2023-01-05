#  ---
#  title: Import new data 2014-2022
#  date:  2020-01-31
#  LamPK
#  ---

library(readxl)
library(data.table)
library(lubridate)
library(stringi)

data_path <- file.path("~", "haiduong")
outp <- file.path("~", "updated_dataset")

## list all files
files <- list.files(path = data_path, recursive = T, full.names = T)

## import and combine files
l <- list()

for (i in c(1:length(files))) {
  cat(i, "\n")

  ## read from excel
  l[[i]] <- as.data.table(read_excel(path = files[i], sheet = 1))

  ## add source
  l[[i]]$file = files[i]
}

dat <- rbindlist(l)

saveRDS(dat, file.path(outp, "haiduong_14_22_merged.rds"))

summary(dat)
table(dat$HINH_THUC_TIEM_CHUNG)

cols <- c("MA_DOI_TUONG", "GIOI_TINH", "TO_CHAR(D.NGAY_SINH,'DD/MM/YYYY')",
          "TEN_TINH_DANG_KY", "TEN_HUYEN_DANG_KY", "TEN_XA_DANG_KY",
          "TEN_VACXIN", "TO_CHAR(LST.NGAY_TIEM,'DD/MM/YYYY')",
          "HINH_THUC_TIEM_CHUNG")
cols_rn <- c("pid", "sex", "dob", "province", "district", "commune",
             "vacname", "vacdate", "type")
## rename
dat <- dat %>% select(all_of(cols))
dat <- setnames(x = dat,
                old = cols,
                new = cols_rn)

### remove duplication
dati <- unique(dati, by = c("MA_DOI_TUONG", "TENTINH", "TENHUYEN", "TENXA", "NGAY_SINH", "GIOI_TINH", "TEN_VACXIN", "NGAY_TIEM"))

## remove accent
dati$province <- stri_trans_general(dati$province, "Latin-ASCII")
dati$district <- stri_trans_general(dati$district, "Latin-ASCII")
dati$commune <- stri_trans_general(dati$commune, "Latin-ASCII")
dati$vacname <- stri_trans_general(dati$vacname, "Latin-ASCII")

### format date
dati$dob <- dmy(dati$dob)
dati$vacdate <- dmy(dati$vacdate)

### additional variables
dat$ddif <- (dat$vacdate - dat$dob)/ddays(1)

### save
saveRDS(dat, file = file.path("..", "updated_dataset", "alldat.rds"))

