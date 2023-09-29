test_that("agg_data works", {

  res <- agg_data(x = dengue_rj, g_var = "ID_MN_RESI", d_var = "DT_SIN_PRI", a_unit = "week")

  expect_equal(nrow(res), 5459)
})
