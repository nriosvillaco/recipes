library(rvest)
library(xml2)
library(here)
library(stringr)

#load html from website
recipe_url <- "https://www.tasteofhome.com/recipes/easy-fresh-strawberry-pie/"
page <- read_html(recipe_url)

#extract recipe name
recipe_name <- page %>%
  html_node("title") %>%
  html_text()

#extract number of reviews
recipe_review_count <- page %>%
  html_node("div.rating a.recipe-comments-scroll") %>%
  html_text()