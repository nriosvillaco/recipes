#load recipe block url
load_recipe_block_urls <- function(recipe_page)
{
  recipe_page_html <- read_content(recipe_page)
  #select url from CSS selectors
  main_content_card <- recipe_page_html %>%
    html_node("#content > section.module-1 > div:nth-child(1) > div > div > div > div.category-card-content > a")
  #extract href attribute
  content_url <- if(!is.null(main_content_card)) {
    url <- main_content_card %>%
      html_attr("href")
    print(url)
  } else {
    print("URL not found")
  }
}

#load individual recipe urls
load_urls_from_blocks <- function(recipe_block_urls)
{
  block_page <- read_html(recipe_block_urls)
  
  #extract all links within the #content section
  recipe_urls <- block_page %>%
    html_nodes("#content a") %>%
    html_attr("href")
  
  #filter out non-recipe URLs if needed
    return(recipe_urls)
}

urls_to_remove <- c(
  "https://www.tasteofhome.com/",
  "https://www.tasteofhome.com/recipes/meal-types/",
  "https://www.tasteofhome.com/recipes/meal-types/dinner/",
  "https://www.tasteofhome.com/recipes/"
)

#clean individual recipe vector
clean_recipe_urls <- function(recipe_urls)
{
  #filter URLs that start with "http" or "https"
  valid_urls <- grep("^https?://", recipe_urls, value = TRUE, ignore.case = TRUE)
  #remove empty values and NAs
  valid_urls <- valid_urls[!is.na(valid_urls) & valid_urls != ""]
  #remove URLs that do not contain "recipes/"
  valid_urls <- valid_urls[grepl("recipes/", valid_urls, ignore.case = TRUE)]
  #remove URLs with "collection/"
  valid_urls <- valid_urls[!grepl("collection/", valid_urls, ignore.case = TRUE)]
  #remove specific URLs not needed
  valid_urls <- valid_urls[!valid_urls %in% urls_to_remove]
  #remove duplicate URLs
  valid_urls <- unique(valid_urls)

  return(valid_urls)
}

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
extract_details <- function(html_code, selectors, extraction_date, url)
{
  #create empty list
  details <- list()
  #add date and url
  details$extraction_date <- extraction_date
  details$url <- url
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