
# konverterar epoch till tid i df

time_conversion <- function(.data) {
  .data %>%
    mutate(
      date_time = as_datetime(.data[[epoch_col]], tz = tz_local),
      time = hms::as_hms(date_time)
    )
}
