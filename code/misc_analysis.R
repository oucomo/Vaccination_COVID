
# load raw data -----------------------------------------------------------

# public dataset
public <- readRDS(file = file.path("..", "tuann349_vad", "alldat.rds")) # 30.020.596 records

# private dataset
private <- readRDS(file = file.path("..", "tuann349_vad", "private_clinic.rds")) # 38.411.554 records


# extract geo-spatial information -----------------------------------------

geo_public <- unique(public[, list(province, district, commune)])
geo_private <- unique(private[, list(province, district, commune)])
geo_info <- unique(rbind(geo_public, geo_private))
write.csv(geo_info, file = file.path("data", "geo_info.csv"), row.names = FALSE)

# extract name of vaccines ------------------------------------------------

vacname <- unique(c(public$vacname, private$vacname))
write.csv(vacname, file = file.path("data", "vacname.csv"), row.names = FALSE)


# get GADM data -----------------------------------------------------------

library(raster)
library(stringi)

vnm3 <- raster::getData(name = "GADM", country = "VNM", level = 3, path = "data")

## for library units: sudo apt install libudunits2-dev
## for library sf: sudo apt install libgdal-dev
## for library rgeos: sudo apt install libgeos-dev

geo_vnm <- data.table(country_code = vnm3$GID_0,
                 country_name = vnm3$NAME_0,
                 province_code = vnm3$GID_1,
                 province_name = vnm3$NAME_1,
                 district_code = vnm3$GID_2,
                 district_name = vnm3$NAME_2,
                 commune_code = vnm3$GID_3,
                 commune_name = vnm3$NAME_3)
geo_vnm2 <- geo_vnm %>%
  mutate(province_code = as.numeric(gsub(pattern = "VNM.|_1", replacement = "", x = province_code)),
         district_code = sapply(gsub(pattern = "VNM.|_1", replacement = "", x = district_code), function(x){strsplit(x, split = "[.]")[[1]][2]}),
         commune_code = sapply(gsub(pattern = "VNM.|_1", replacement = "", x = commune_code), function(x){strsplit(x, split = "[.]")[[1]][3]}),

         province_name = stri_trans_general(province_name, "Latin-ASCII"),
         district_name = stri_trans_general(district_name, "Latin-ASCII"),
         commune_name = stri_trans_general(commune_name, "Latin-ASCII")
         )
save(geo_vnm, geo_vnm2, file = file.path("data", "geo_vnm.Rdata"))

geo_info2 <- geo_info %>%
  filter(province != "Tinh tap huan" & district != "Huyen tap huan") %>%
  mutate(province = gsub(pattern = "Thanh pho ", replacement = "", x = province),
         district = gsub(pattern = "Thanh pho |Thanh Pho |Thi Xa |Thi xa |TX ", replacement = "", x = district))

geo_vnm3 <- geo_vnm2 %>%
  mutate(district_name = gsub(pattern = "Thanh pho |Thanh Pho |Thi Xa |Thi xa | [(]Thi xa[)]| [(]Thanh pho[)]", replacement = "", x = district_name))

## check geo_info & geo_vnm
### province
tmp1 <- unique(geo_info2$province)
tmp2 <- unique(geo_vnm3$province_name)
tmp1[!tmp1 %in% tmp2] # "Thanh pho Ho Chi Minh" "Tinh tap huan"
tmp2[!tmp2 %in% tmp1] # "Ho Chi Minh"

### district
tmp1 <- unique(geo_info2$district)
tmp2 <- unique(geo_vnm3$district_name)
tmp1[!tmp1 %in% tmp2] # "Thanh pho", "Thi Xa", "Thi xa", "TX", "Thanh Pho", "Huyen tap huan"
tmp2[!tmp2 %in% tmp1] # "Thanh Pho", "Thi Xa", "(Thi xa)", "(Thanh pho)"



