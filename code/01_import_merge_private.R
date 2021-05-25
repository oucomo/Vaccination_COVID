#  ---
#  title: Import data (private clinic)
#  date:  2021-03-14
#  LamPK
#  ---

library(readxl)
library(data.table)
library(lubridate)
library(stringi)

data_path <- file.path("..", "sharefolder", "data", "private clinics")

## list all files
files <- list.files(path = data_path, recursive = TRUE)

## import and combine files
dat <- NULL
for (i in c(1:length(files))) {
  cat(i, "\n")

  ## check all sheets
  sheet <- excel_sheets(path = file.path(data_path, files[i]))
  nsheet <- sum(sheet != "SQL")

  dati <- NULL

  for (j in c(1:nsheet)) {
    ### read from excel
    if (j == 1) {
      datij <- as.data.table(read_excel(path = file.path(data_path, files[i]), sheet = j))
    } else {
      datij <- as.data.table(read_excel(path = file.path(data_path, files[i]), sheet = j, col_names = FALSE))
      names(datij) <- c("MA_DOI_TUONG", "TENTINH", "TENHUYEN", "TENXA", "NGAY_SINH", "GIOI_TINH", "TEN_VACXIN", "NGAY_TIEM")
    }


    ### remove duplication
    datij <- unique(datij, by = c("MA_DOI_TUONG", "TENTINH", "TENHUYEN", "TENXA", "NGAY_SINH", "GIOI_TINH", "TEN_VACXIN", "NGAY_TIEM"))

    ## rename
    setnames(x = datij,
             old = c("MA_DOI_TUONG", "TENTINH", "TENHUYEN", "TENXA", "NGAY_SINH", "GIOI_TINH", "TEN_VACXIN", "NGAY_TIEM"),
             new = c("pid", "province", "district", "commune", "dob", "sex", "vacname", "vacdate"))

    ## remove accent
    datij$province <- stri_trans_general(datij$province, "Latin-ASCII")
    datij$district <- stri_trans_general(datij$district, "Latin-ASCII")
    datij$commune <- stri_trans_general(datij$commune, "Latin-ASCII")
    datij$vacname <- stri_trans_general(datij$vacname, "Latin-ASCII")

    ### format date
    datij$dob <- dmy(datij$dob)
    datij$vacdate <- dmy(datij$vacdate)

    ### add source
    datij$file = files[i]

    ### combind
    dati <- rbindlist(l = list(dati, datij))
  }

  ### remove duplication
  dati <- unique(dati, by = c("pid", "province", "district", "commune", "dob", "sex", "vacname", "vacdate", "file"))

  saveRDS(dati, file = file.path("..", "tuann349_vad", paste0("private_clinic_", gsub(pattern = ".xlsx", replacement = "", x = files[i]), ".rds")))
  fwrite(x = dati, file = file.path("..", "tuann349_vad", paste0("private_clinic_", gsub(pattern = ".xlsx", replacement = "", x = files[i]), ".csv")))

  ### combind
  dat <- rbindlist(l = list(dat, dati))
}

### additional variables
dat$ddif <- (dat$vacdate - dat$dob)/ddays(1)

### individual data
individual <- unique(dat[,  .(pid, province, district, commune, dob, sex, file)])

### vaccine data
vaccine <- unique(dat[,  .(pid, province, district, commune, vacname, vacdate, ddif)])

### save
saveRDS(dat, file = file.path("..", "tuann349_vad", "private_clinic.rds"))
fwrite(x = dat, file = file.path("..", "tuann349_vad", "private_clinic.csv"))

saveRDS(individual, file = file.path("..", "tuann349_vad", "individual_private.rds"))
fwrite(x = individual, file = file.path("..", "tuann349_vad", "individual_private.csv"))

saveRDS(vaccine, file = file.path("..", "tuann349_vad", "vaccine_private.rds"))
fwrite(x = vaccine, file = file.path("..", "tuann349_vad", "vaccine_private.csv"))
