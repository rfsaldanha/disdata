# Imputation of invalid variables using best candidate data
#'
#' This function imputates missing and not valid records from variables using data from pointed best candidate variables.
#'
#' The records of `g_var` variable are checked for presence of missing data (`NA`) and for different length than `g_var_nchar`. If any of those conditions are met, data from `g_var_candidate` is used to imputate `g_var` if it is not missing and valid.
#'
#' The records of `d_var` variable are checked for presence of missing data (`NA`) and must be in the range of `d_var_min` and `d_var_max`. If any of those conditions are met, data from `d_var_candidate` is used to imputate `d_var` if it is not missing and valid.
#'
#' @param x a `data.frame` or `tibble`.
#' @param g_var character. Grouping variable name.
#' @param g_var_candidate character. Variable candidate to imputate `g_var`
#' @param g_var_nchar numeric. Allowed length for `g_var`.
#' @param d_var date. Date variable. Must be of class `Date`.
#' @param d_var_candidate date. Date variable candidate to imputate `d_var`.
#' @param d_var_min date. Minimum date allowed.
#' @param d_var_max date. Maximum date allowed.
#'
#' @return a `tibble`.
#' @export
#'
#' @importFrom rlang :=
#'
#' @examples
#' imp_data(x = dengue_rj, g_var = "ID_MN_RESI", g_var_candidate = "COMUNINF",
#' d_var = "DT_SIN_PRI", g_var_nchar = 6, d_var_candidate = "DT_NOTIFIC",
#' d_var_min = as.Date("2020-01-01"), d_var_max = as.Date("2020-12-31"))
#'
imp_data <- function(x, g_var, g_var_candidate, g_var_nchar,
                     d_var, d_var_candidate, d_var_min, d_var_max){
  tmp <- x %>%
    # Create check variables
    dplyr::mutate(
      g_var_check = dplyr::if_else(
        nchar(!!dplyr::sym(g_var)) == g_var_nchar &
          !is.na(!!dplyr::sym(g_var)),
        true = TRUE, false = FALSE
      ),
      g_var_candidate_check = dplyr::if_else(
        nchar(!!dplyr::sym(g_var_candidate)) == g_var_nchar &
          !is.na(!!dplyr::sym(g_var_candidate)),
        true = TRUE, false = FALSE
      ),
      d_var_check = dplyr::if_else(
        !is.na(!!dplyr::sym(d_var)) &
          !!dplyr::sym(d_var) >= d_var_min &
          !!dplyr::sym(d_var) <= d_var_max,
        true = TRUE, false = FALSE
      ),
      d_var_candidate_check = dplyr::if_else(
        !is.na(!!dplyr::sym(d_var_candidate)) &
          !!dplyr::sym(d_var_candidate) >= d_var_min &
          !!dplyr::sym(d_var_candidate) <= d_var_max,
        true = TRUE, false = FALSE
      )
    ) %>%
    # Imputate with candidate when valid
    dplyr::mutate(
      !!dplyr::sym(g_var) := dplyr::case_when(
        g_var_check == FALSE &
          g_var_candidate_check == TRUE ~ !!dplyr::sym(g_var_candidate),
        .default = !!dplyr::sym(g_var)),
      !!dplyr::sym(d_var) := dplyr::case_when(
        d_var_check == FALSE &
          d_var_candidate_check == TRUE ~ as.Date(!!dplyr::sym(d_var_candidate)),
        .default = !!dplyr::sym(d_var))
    )

  # Remove check variables
  res <- tmp %>%
    dplyr::select(-"g_var_check", -"g_var_candidate_check",
                  -"d_var_check", -"d_var_candidate_check")

  return(res)

}
