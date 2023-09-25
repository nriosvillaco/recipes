#load recipe block url
load_recipe_block_urls <- function(recipe_page)
{
  recipe_page_html <- read_content(recipe_page)
  #select url from CSS selectors
  main_content_card <- html_code %>%
    html_node("#content > section.module-1 > div:nth-child(1) > div > div > div > div.category-card-content > a")
  #extract href attribute
  content_url <- if (!is.null(main_content_card)) {
    url <- main_content_card %>% 
      html_attr("href")
    print(url)
  } else {
    print("URL not found")
  }
}

#load individual recipe urls----------------------------


#load html from website
read_content <- function(url)
{
  page <- read_html(url)
  return(page)
}


#create list of selectors
selectors <- list(
  name = "title",
  number_reviews = "div.rating",
  total_time = "div.total-time",
  servings = "div.makes",
  ingredients = "ul.recipe-ingredients__list li",
  directions = "ol.recipe-directions__list li span"
)


#extract recipe details from HTML code
extract_details <- function(html_code, selectors)
{
  #create empty list
  details <- list()
  #extract the corresponding information for each selector
  for(selector in names(selectors))
  {
    extracted_info <- html_code %>%
      html_nodes(selectors[[selector]]) %>%
      html_text() %>%
      str_replace_all("\\s+", " ") %>%
      trimws()
    details[[selector]] <- extracted_info
  }
  return(details)
}