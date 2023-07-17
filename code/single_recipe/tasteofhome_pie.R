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
  html_node("div.rating") %>%
  html_text()

#extract total time needed
recipe_totaltime <- page %>%
  html_node("div.total-time") %>%
  html_text() %>%
  str_replace_all("\\s+", " ")

#extract number of portions
recipe_portion_count <- page %>%
  html_node("div.makes") %>%
  html_text() %>%
  str_replace_all("\\s+", " ")

#extract ingredients
recipe_ingredients <- page %>%
  html_node("ul.recipe-ingredients__list") %>%
  html_nodes("li") %>%
  html_text()

#extract directions
recipe_directions <- page %>%
  html_nodes("li.recipe-directions__item") %>%
  html_nodes("span") %>%
  html_text()