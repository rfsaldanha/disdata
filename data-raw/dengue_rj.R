## code to prepare `dengue_rj` dataset goes here

# dengue_rj <- microdatasus::fetch_datasus(year_start = 2010, year_end = 2010, uf = "RJ", information_system = "SINAN-DENGUE")

dengue_rj <- arrow::read_parquet(file = "../dengue/dengue_data_files/dengue_data/parquets/dengue_2020.parquet") %>%
  dplyr::filter(substr(ID_MUNICIP, 0, 2) == "33") %>%
  dplyr::mutate(DT_SIN_PRI = lubridate::as_date(DT_SIN_PRI)) %>%
  dplyr::filter(DT_SIN_PRI >= as.Date("2020-01-01") & DT_SIN_PRI <= as.Date("2020-12-31"))

usethis::use_data(dengue_rj, overwrite = TRUE)
