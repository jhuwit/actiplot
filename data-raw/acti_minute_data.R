## code to prepare `acti_minute_data` dataset goes here
library(actimetrics)
file = "~/Dropbox/Projects/upper_limb_gt3x_prosthesis/data/group_without_prosthesis/AI3_CLE2B21130054_2017-06-02.gt3x.gz"
if (file.exists(file)) {
 acti_minute_data = acti_process(file)
 usethis::use_data(acti_minute_data, overwrite = TRUE)
}
