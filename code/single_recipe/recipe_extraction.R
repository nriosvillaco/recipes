library(rvest)
library(xml2)
library(here)
library(stringr)


#load recipe_extraction_functions
extraction <- here("code/single_recipe/source", "recipe_extraction_functions.R")
source(extraction)


#load html from website
url <- "https://www.tasteofhome.com/recipes/easy-fresh-strawberry-pie/"
webpage <- read_content(url)


#extract recipe details
recipe_details <- extract_details(webpage, selectors)

#clean up data
recipe_details[["name"]] <- recipe_details[["name"]][1]