library(rvest)
library(xml2)
library(here)

#find practice file path
path <- here("practice", "practice_recipe.html")
recipe_page <- read_html(path)

#extract recipe name
recipe_name <- recipe_page %>%
  html_node("title") %>%
  html_text()

#extract recipe popularity
