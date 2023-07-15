library(rvest)
library(xml2)
library(here)

#find practice file path
path <- here("practice", "practice_recipe.html")
recipe_page <- read_html(path)

#extract recipe name
recipe_name <- recipe_page %>%
  html_node("title") %>%
  #extracts text content
  html_text()

#extract ingredients
recipe_ingredients <- recipe_page %>%
  #select <ul> element from inside the the section with ID "ingredients"
  html_node("section#ingredients ul") %>%
  #select all "li" elements within previous selection
  html_nodes("li") %>%
  html_text()

#extract preparation
recipe_prep <- recipe_page %>%
  #selects <h3> element containing the text "Preparation"
  html_node("section h3:contains('Preparation')") %>%
  #selects <ul> element following previous selection
  html_node(xpath = "./following-sibling::ul[1]") %>%
  html_nodes("li") %>%
  html_text()
