library(rvest)
library(xml2)
library(here)
library(stringr)
library(tidyverse)


#load recipe_extraction_functions
extraction <- here("code/tasteofhome/source", "recipe_extraction_functions.R")
source(extraction)

recipe_page <- 'https://www.tasteofhome.com/recipes/'

#set extraction date
extraction_date <- Sys.time() %>%
  format(format = "%m-%d-%Y")

#load url block
recipe_block_urls <- load_recipe_block_urls(recipe_page)

#load individual recipes
recipe_urls <- load_urls_from_blocks(recipe_block_urls)
recipe_urls <- clean_recipe_urls(recipe_urls)
recipe_urls

#extract recipe details
all_recipes_details <- list()

for(url in recipe_urls)
{
  #introduce a delay to avoid hitting rate limits
  Sys.sleep(1) #adjust number of seconds as needed
  
  html_code <- read_content(url)
  
  recipe_details <- extract_details(html_code, selectors, extraction_date, url)
  all_recipes_details[[length(all_recipes_details) + 1]] <- recipe_details
}

#clean up data
for (i in seq_along(all_recipes_details))
{
  recipe_details <- all_recipes_details[[i]]
  recipe_details[["name"]] <- recipe_details[["name"]][1]
  recipe_details[["number_reviews"]] <- as.numeric(gsub("\\D", "", recipe_details[["number_reviews"]]))
  recipe_details[["servings"]] <- as.numeric(gsub("\\D", "", recipe_details[["servings"]]))
  
  all_recipes_details[[i]] <- recipe_details
}


#load previous data
saved_filepath <- here("data")

if (file.exists("data/recipe_data.RData")) {
  load("data/recipe_data.RData")
  loaded_data <- recent_recipe_data
  rm(recent_recipe_data)
} else {
  loaded_data <- data.frame() #create an empty data frame if the file doesn't exist
}

#append new data
recipe_data <- as.data.frame(do.call(rbind, all_recipes_details), stringsAsFactors = FALSE)
colnames(recipe_data) <- c(
  "extraction_date",
  "url",
  "name",
  "number_reviews",
  "total_time",
  "servings",
  "ingredients",
  "directions"
)

#combine loaded data with new data
recent_recipe_data <- rbind(loaded_data, recipe_data)

save(recent_recipe_data, file = paste0(saved_filepath, "/", "recipe_data.RData"))
