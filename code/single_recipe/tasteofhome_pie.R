library(rvest)
library(xml2)
library(here)

#load html from website
recipe_url <- "https://www.tasteofhome.com/recipes/easy-fresh-strawberry-pie/"
page <- read_html(recipe_url)

#extract recipe name
recipe_name <- page %>%
  html_node("title") %>%
  html_text()
