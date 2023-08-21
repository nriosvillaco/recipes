library(rvest)
library(xml2)
library(here)
library(stringr)


#load recipe_extraction_functions
extraction <- here("code/tasteofhome/source", "recipe_extraction_functions.R")
source(extraction)


#load html from website
recipe_urls <- c(
  "https://www.tasteofhome.com/recipes/easy-fresh-strawberry-pie/",
  "https://www.tasteofhome.com/recipes/creamy-tomato-fettuccine-with-zucchini/",
  "https://www.tasteofhome.com/article/mexican-street-corn-salad-esquites/",
  "https://www.tasteofhome.com/recipes/greek-chicken-meat-loaf/",
  "https://www.tasteofhome.com/article/crispy-pork-belly/",
  "https://www.tasteofhome.com/recipes/pesto-chicken-bake/",
  "https://www.tasteofhome.com/recipes/salmon-tacos-fish-tacos/",
  "https://www.tasteofhome.com/recipes/planter-s-punch/",
  "https://www.tasteofhome.com/article/cookie-salad/",
  "https://www.tasteofhome.com/recipes/cherries-jubilee/"
)

#extract recipe details
all_recipes_details <- list()

for(url in recipe_urls)
{
  html_code <- read_content(url)
  
  recipe_details <- extract_details(html_code, selectors)
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
