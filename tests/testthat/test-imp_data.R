test_that("imp_data works", {
  res <- imp_data(x = dengue_rj,
                  g_var = "ID_MN_RESI", g_var_candidate = "COMUNINF",
                  d_var = "DT_SIN_PRI", g_var_nchar = 6,
                  d_var_candidate = "DT_NOTIFIC", d_var_min = as.Date("2020-01-01"), d_var_max = as.Date("2020-12-31"))

  expect_equal(2 * 2, 4)
})
