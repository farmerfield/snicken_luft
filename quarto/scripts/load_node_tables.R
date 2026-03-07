load_node_tables <- function(log_dir = NULL, target_date = NULL) {
  if (is.null(log_dir) || !nzchar(log_dir)) {
    log_dir <- Sys.getenv("PMS_LOG_DIR", unset = NA)
  }

  if (is.na(log_dir) || !nzchar(log_dir)) {
    log_dir <- "~/pms_logs"
  }

  log_dir <- path.expand(log_dir)

  if (!dir.exists(log_dir)) {
    stop(paste("Log directory not found:", shQuote(log_dir)))
  }

  pattern <- if (!is.null(target_date)) {
    paste0("__", target_date, "\\.csv$")
  } else {
    "__\\d{4}-\\d{2}-\\d{2}\\.csv$"
  }

  files <- list.files(log_dir, pattern = pattern, full.names = TRUE)

  if (length(files) == 0) {
    return(list())
  }

  parse_topic <- function(safe_topic) {
    m <- regexec("^sensors_pms5003_(node-[^_]+)_sensor_(.*)_state$", safe_topic)
    parts <- regmatches(safe_topic, m)[[1]]
    if (length(parts) >= 3) {
      return(list(node = parts[2], metric = parts[3]))
    }
    return(list(node = NA, metric = NA))
  }

  node_tables <- list()

  for (f in files) {
    df <- read.csv(f, stringsAsFactors = FALSE)

    if (!all(c("epoch", "value") %in% names(df))) {
      if (ncol(df) >= 2) {
        names(df)[1:2] <- c("epoch", "value")
      }
    }

    df$epoch <- suppressWarnings(as.numeric(df$epoch))
    df$value <- suppressWarnings(as.numeric(df$value))
    df <- df[is.finite(df$epoch) & is.finite(df$value), ]

    if (nrow(df) == 0) {
      next
    }

    base <- basename(f)
    date_tag <- sub(".*__(\\d{4}-\\d{2}-\\d{2})\\.csv$", "\\1", base)
    safe_topic <- sub("__\\d{4}-\\d{2}-\\d{2}\\.csv$", "", base)
    meta <- parse_topic(safe_topic)

    if (is.na(meta$node) || is.na(meta$metric)) {
      next
    }

    out <- data.frame(
      date = date_tag,
      epoch = df$epoch,
      value = df$value,
      metric = meta$metric,
      topic = safe_topic,
      stringsAsFactors = FALSE
    )

    if (is.null(node_tables[[meta$node]])) {
      node_tables[[meta$node]] <- out
    } else {
      node_tables[[meta$node]] <- rbind(node_tables[[meta$node]], out)
    }
  }

  node_tables
}
