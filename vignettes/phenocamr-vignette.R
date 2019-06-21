## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

# check if server is reachable
# returns bolean TRUE if so
phenocam_running <- function(url = "http://phenocam.sr.unh.edu"){
  ct <- try(httr::GET(url))
  if(inherits(ct,"try-error")){return(FALSE)}
  if(ct$status_code > 400){
    FALSE  
  } else {
    TRUE
  }
}

# load the library
library(phenocamr)

check <- phenocam_running()

## ----eval = check--------------------------------------------------------
sites <- list_sites()
head(sites)

## ----eval = check--------------------------------------------------------
rois <- list_rois()
head(rois)

## ----eval = check--------------------------------------------------------
  download_phenocam(site = "harvard$",
                    veg_type = "DB",
                    roi_id = "1000",
                    frequency = 3,
                    outlier_detection = FALSE,
                    smooth = FALSE,
                    out_dir = tempdir())

## ----eval = check--------------------------------------------------------
df <- read_phenocam(file.path(tempdir(),"harvard_DB_1000_3day.csv"))
print(str(df))

## ----eval = check--------------------------------------------------------
df <- expand_phenocam(df)

## ----eval = check--------------------------------------------------------
  df <- detect_outliers(df)

## ----eval = check--------------------------------------------------------
  df <- smooth_ts(df)

## ----eval = check--------------------------------------------------------
start_of_season <- transition_dates(df)
print(head(start_of_season))

## ----eval = check--------------------------------------------------------
phenology_dates <- phenophases(df, internal = TRUE)

## ----fig.width = 7, fig.height = 3, eval = check-------------------------
plot(as.Date(df$data$date),
     df$data$smooth_gcc_90,
     type = "l",
     xlab = "date",
     ylab = "Gcc")

# rising "spring" greenup dates
abline(v = phenology_dates$rising$transition_50,
       col = "green")

# falling "autumn" senescence dates
abline(v = phenology_dates$falling$transition_50,
       col = "brown")


