# Imputation of invalid variables using best candidate data

#' @importFrom rlang :=
imp_data <- function(x, g_var, g_var_candidate, g_var_nchar,
                     d_var, d_var_candidate, d_var_min, d_var_max,
                     verbose = TRUE){
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
        g_var_check == FALSE & g_var_candidate_check == TRUE ~ !!dplyr::sym(g_var_candidate),
        .default = !!dplyr::sym(g_var)),
      !!dplyr::sym(d_var) := dplyr::case_when(
        d_var_check == FALSE & d_var_candidate_check == TRUE ~ as.Date(!!dplyr::sym(d_var_candidate)),
        .default = !!dplyr::sym(d_var))
    )

  # if(verbose){
  #   message(glue::glue("From {nrow(x)} records, the variable {g_var} presented {as.numeric(table(tmp$g_var_check)['FALSE'])} records"))
  # }

  # Remove check variables
  res <- tmp %>%
    dplyr::select(-"g_var_check", -"g_var_candidate_check",
                  -"d_var_check", -"d_var_candidate_check")

  return(res)

}
