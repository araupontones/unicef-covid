#'scrap flags from "https://www.worldometers.info/img/flags"
#'
library(httr)



isos <- worldSf_details$iso2

worldSf <- rio::import("data/map/worldSF.rds")

#download in bulk
flags <- lapply(isos, function(x){download_flag(iso = x)})

#download countries spoted as missing
#to change the iso of a country go to clean_world_shapeFile.R
worldSf_details$iso2[worldSf_details$Country == "Montenegro"]
download_flag(iso = "mj")
