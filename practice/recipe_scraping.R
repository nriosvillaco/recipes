library(rvest)
library(xml2)
library(here)

#find practice file path
path <- here("practice", "practice_recipe.html")
raw_html <- read_html(path)