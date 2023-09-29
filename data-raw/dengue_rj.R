## code to prepare `dengue_rj` dataset goes here

# dengue_rj <- microdatasus::fetch_datasus(year_start = 2010, year_end = 2010, uf = "RJ", information_system = "SINAN-DENGUE")

important_vars <- c("ID_AGRAVO", "DT_NOTIFIC", "ID_UNIDADE",
                    "DT_SIN_PRI", "CS_SEXO", "CS_GESTANT",
                    "CS_RACA", "CS_ESCOL_N", "ID_MN_RESI",
                    "COUFINF", "COMUNINF", "ID_OCUPA_N",
                    "DT_SORO", "RESUL_SORO", "SOROTIPO",
                    "CLASSI_FIN", "CRITERIO", "EVOLUCAO",
                    "DT_OBITO", "HOSPITALIZ", "DT_INTERNA")

dengue_rj <- arrow::read_parquet(file = "../dengue/dengue_data_files/dengue_data/parquets/dengue_2020.parquet") %>%
  dplyr::select(dplyr::all_of(important_vars)) %>%
  dplyr::filter(substr(ID_MN_RESI, 0, 2) == "33") %>%
  dplyr::mutate(DT_SIN_PRI = lubridate::as_date(DT_SIN_PRI)) %>%
  dplyr::filter(DT_SIN_PRI >= as.Date("2019-01-01") & DT_SIN_PRI <= as.Date("2021-12-31"))

usethis::use_data(dengue_rj, overwrite = TRUE)
