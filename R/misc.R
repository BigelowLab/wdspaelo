#' Retrieve an example filename
#' 
#' @export
#' @param what char, one of 'template' or 'seguin_whitney2022' or 'lower-spies2020'
#' @return character URL
example_filename = function(what = c("template", "seguin_whitney2022", "lower-spies2020")[2]){
  base_uri = "https://www.ncei.noaa.gov/pub/data/paleo"
  file.path(base_uri,
     switch(tolower(what[1]),
       "seguin_whitney2022" = "contributions_by_author/whitney2022/seguin_whitney2022.txt",
       "lower-spies2020" = "contributions_by_author/lower-spies2020/lower-spies2020-c14.txt",
       "templates/noaa-wds-paleo-template-instructions.txt")
  )
}
