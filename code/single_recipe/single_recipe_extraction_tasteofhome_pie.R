library(rvest)
library(xml2)
library(here)
library(stringr)


#load html from website
recipe_url <- "https://www.tasteofhome.com/recipes/easy-fresh-strawberry-pie/"
page <- read_html(recipe_url)


#create list of selectors
selectors <- list(
  recipe_name = "title",
  recipe_review_count = "div.rating",
  recipe_totaltime = "div.total-time",
  recipe_portion_count = "div.makes",
  recipe_ingredients = "ul.recipe-ingredients__list li",
  recipe_directions = "ol.recipe-directions__list li span"
)


#extract recipe details from HTML code
extract_details <- function(html_code, selectors)
{
  #create empty list
  details <- list()
  #extract the corresponding information for each selector
  for(selector in names(selectors))
  {
    extracted_info <- page %>%
      html_nodes(selectors[[selector]]) %>%
      html_text() %>%
      str_replace_all("\\s+", " ")
    details[[selector]] <- extracted_info
  }
  return(details)
}