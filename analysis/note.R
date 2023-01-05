list.files("/cluster_data/vaccine_registry/DVD1/101.HANOI")
df <- read_excel("/cluster_data/vaccine_registry/DVD1/101.HANOI/101.HANOI.1-1000000.xlsx")
# Ngay tiem < ngay sinh: sai => remove case (check ti le nhieu ko)
# Ten vaccine
# Vaccine cung 1 ngay tiem, cung loai vaccine, cung 1 nguoi
