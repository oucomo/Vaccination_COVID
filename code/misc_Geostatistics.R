tb <- readRDS(file = file.path("..", "tuann349_vad", "tuberculosis.rds")) %>%
  group_by(pid) %>%
  arrange(vacdate) %>%
  slice(1) %>%
  ungroup()
tb$byear <- year(tb$dob)
tb <- as.data.table(tb)

## describe
tb_sum <- tb[, .(n = length(unique(pid))), by = .(province, byear)]

## sample 10%
tb_sp <- NULL

set.seed(22042021)
for (i in c(1:nrow(tb_sum))) {
  province <- tb_sum$province[i]
  year <- tb_sum$byear[i]
  pid_all <- unique(tb$pid[tb$province == province & tb$byear == year])
  id <- sample(x = pid_all, size = round(0.1 * tb_sum$n[i]), replace = FALSE)
  tb_sp <- rbind(tb_sp,
                 tb[pid %in% id, .(pid, province, byear, dob, sex)])
}

## get measle data
measle <- readRDS(file = file.path("..", "tuann349_vad", "measle.rds"))
measle9 <- measle[vacname2 == "Measle"] %>%
  group_by(pid) %>%
  arrange(vacdate) %>%
  slice(1) %>%
  ungroup()
measle9$byear <- year(measle9$dob)

measle_sp <- merge(tb_sp, measle9[, c("pid", "province", "byear", "district", "commune", "sex", "dob", "vacname2", "start", "vacdate", "vyear", "vmonth", "vagem2", "vdelay")],
                       by = c("pid", "province", "byear", "dob", "sex"), all.x = TRUE)
save(measle_sp, file = file.path("..", "tuann349_vad", "measle_sp.Rdata"))
