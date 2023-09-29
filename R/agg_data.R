#' Aggregate data by grouping and time variables
#'
#' This function aggregates data by grouping and time variables and return time series of same size.
#'
#' @param x a `tibble`.
#' @param g_var Grouping variable name.
#' @param d_var Date variable. Must be of class `Date`.
#' @param a_unit Aggregate unit. `day`, `week`, `month` or `year`.
#' @param ... arguments passed to `timetk::summarise_by_time` function, including `.week_start`.
#'
#' @return a `tibble`.
#' @export
#'
#' @importFrom rlang .data
#'
#' @examples
#' agg_data(x = dengue_rj, g_var = "ID_MN_RESI", d_var = "DT_SIN_PRI", a_unit = "week")
#'
agg_data <- function(x, g_var, d_var, a_unit, ...){
  # Check assertions
  checkmate::assert_choice(g_var, choices = names(x))
  checkmate::assert_choice(d_var, choices = names(x))
  checkmate::assert_class(get({d_var}, x), classes = "Date")
  checkmate::assert_choice(a_unit, choices = c("day", "week", "month", "year"))

  x %>%
    # Create variable to separate original from padded rows
    dplyr::mutate(original_row = TRUE) %>%
    # Group by grouping variable
    dplyr::group_by(!!dplyr::sym(g_var)) %>%
    # Pad rows by day, considering minimum and maximum date values
    timetk::pad_by_time(
      .date_var = !!dplyr::sym(d_var),
      .by = "day",
      .start_date = min(get({d_var}, x)),
      .end_date = max(get({d_var}, x))
    ) %>%
    # Count original rows that represent cases (not padded rows)
    # by a unit of time
    timetk::summarise_by_time(
      .date_var = !!dplyr::sym(d_var),
      .by = a_unit,
      freq = sum(.data$original_row, na.rm = TRUE),
      ...
    ) %>%
    # Ungroup
    dplyr::ungroup()
}
