library(rvest)
library(xml2)
library(here)
library(stringr)


extraction <- here("code/single_recipe/source", "recipe_extraction_function.R")
source(extraction)


#load html from website
url <- "https://www.tasteofhome.com/recipes/easy-fresh-strawberry-pie/"
webpage <- read_content(url)
