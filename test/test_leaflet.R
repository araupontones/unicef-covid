
#check that the map works in leaflet
library(leaflet)
library(sf)
library(dplyr)
#to map efficienty in leaflet
sf::sf_use_s2(FALSE)


wordlSF <- rio::import("data/map/worldSF.rds")
ref_raw <- rio::import("reference_docs/Layout_Mar17 DN.xlsx")
names(ref_raw) <- ref_raw[1,]

ref_countries <- ref_raw[-1,] %>%
  select(Country) %>%
  filter(!is.na(Country),
         !stringr::str_detect(Country, "Denis"),
         Country != "Regional") %>%
  mutate(target = "Yes")



test <- wordlSF %>%
  left_join(ref_countries, by = "Country") %>%
  mutate(target = if_else(is.na(target), "No", "Yes"),
         target = factor(target)) 



#factor pallete
factpal <- colorFactor(c("#E5E5EB", "#008237"), test$target)

labels <- sprintf(
  "<strong>%s</strong><br/> Iso2: %s",
  test$Country, test$iso2
) %>% lapply(htmltools::HTML)

leaflet(test) %>%
  addPolygons(
    color = "white",
    fillColor = ~factpal(target),
    fillOpacity = 1,
    weight = 1,
    label = labels)


