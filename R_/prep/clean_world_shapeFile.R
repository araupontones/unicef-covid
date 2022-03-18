#' downloads the world's shapefile and gets country details from world bank's data

library(dplyr)
gmdacr::load_functions("functions")

#define paramaters


exfile <- "data/map/worldSF.rds"



#get shapefile -----------------------------------------------------------------
worldSf_raw <- sf::st_as_sf(maps::map("world", fill=TRUE, plot=FALSE))



#clean names 
worldSf <- worldSf_raw %>%
  rename(Country = ID) %>%
  #cleaning country names to make consistent with world bank's country details
  mutate(Country = fix_name("UK", "United Kingdom", Country),
         Country = fix_name("USA", "United States", Country),
         Country = fix_name("Russia", "Russian Federation", Country),
         Country = fix_name("Macedonia", "North Macedonia", Country)
         ) %>%
  filter(!Country %in% c("Vatican"))
 



#get country information from the world bank------------------------------------
wbcountries <- wbstats::wb_countries()


countries <- wbcountries %>%
  rename(Country = country) %>%
  #keeping only countries
  filter(!is.na(capital_city) |(is.na(capital_city) & Country == "Israel")) %>%
  #cleaning country names to make it consistent with shapefile
  mutate(Country = fix_name("Venezuela, RB", "Venezuela", Country),
         Country = fix_name("Syrian Arab Republic", "Syria", Country),
         Country = fix_name("Slovak Republic", "Slovakia", Country),
         Country = fix_name("Korea, Dem. People's Rep.", "North Korea", Country),
         Country = fix_name("Korea, Rep.", "South Korea", Country),
         Country = fix_name("Kyrgyz Republic", "Kyrgyzstan", Country),
         Country = fix_name("Egypt, Arab Rep.", "Egypt", Country)
         ) %>%
  #keeping relevant variables
  select(Country,
         iso3 = iso3c,
         iso2 = iso2c,
         capital_city,
         longitude,
         latitude,
         region,
         income_level)

  
#Join country details with shapeFile -------------------------------------------

#setdiff(unique(worldSf$Country), countries$Country)

worldSf_details <- worldSf %>%
  left_join(countries, by = "Country") %>%
  #cleaning iso names to download flags from https://www.worldometers.info/geography/flags-of-the-world/
  mutate(iso2 = stringr::str_to_lower(iso2),
         iso2 = fix_name("ge", "gg", iso2),
         iso2 = fix_name("tj", "ti", iso2),
         iso2 = fix_name("ua", "up", iso2),
         iso2 = fix_name("ba", "bk", iso2),
         iso2 = fix_name("tr", "tu", iso2),
         iso2 = fix_name("me", "mj", iso2)
         )


#simplify to reduce size of shapefile and increase speed
worldSF_simply <- sf::st_simplify(worldSf_details, dTolerance = .1)

size_org <- object.size(worldSf_details)
size_simp <- object.size(worldSF_simply)
#reduction of 70%!
#(size_simp - size_org) / size_org

#export data
rio::export(worldSF_simply, exfile) 

