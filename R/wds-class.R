#' WDSpaleo to access NOAA template files
#'
#' R6 class for accessing WDS-paelo template format
WDSpaleo = R6::R6Class("WDSpaleo",
  public = list(
    #' @field filename char, the URL (generally) of filename 
    filename = NULL,
    #' @field raw char, character vector of raw data by line, don't mess with this
    raw = NULL,
    #' @field data tibble of data (or NULL)
    data = NULL,
    
    #' @description
    #' Create a new WDSpaleo instance
    #' @param filename char, the URL or filename to read
    initialize = function(filename = example_filename("seguin_whitney2022")){
      self$filename = filename[1]
      if (self$read_file()) self$parse_data()
    },
    
    
    #' @description 
    #' Read the file storing either raw character data or NULL
    #' @param token char, the pattern to look for
    #' @param fixed logical, passed to \code{\link[base]{grep}}
    #' @param ... other arguments for \code{\link[base]{grep}}
    #' @return logical, TRUE if successful
    find_token = function(token = "# Data:", fixed = TRUE, ...){
      if (is.null(self$raw)){
        ix = -1
      } else {
        ix = grep(token, self$raw, fixed = TRUE, ...)
      }
      ix
    },
  
    #' @description 
    #' Read the file storing either raw character data or NULL
    #' @return WDSpaleo object (suitable for piping)
    parse_data = function(){
      i0 = self$find_token("# Data:")
      if (i0 < 0 || is.null(self$raw)) {
        message("token (`# Data:`) not found - is the data loaded?")
        return(self)
      }
      i2 = length(self$raw)
      txt = self$raw[seq(from = i0, to = i2, by = 1)]
      txt = txt[!grepl("^#", txt)]  # leading comments
      tab = grepl("^.*\t$", txt) # trailing tab?????
      n = nchar(txt)
      txt[tab] = substring(txt[tab], 1, n[tab] - 1)
      self$data = readr::read_tsv(I(txt), 
                                  na = c("", "NA", "NaN", "na", "nan", "NAN"),
                                  show_col_types = FALSE)
      invisible(self)
    },
    
    #' @description 
    #' Read the file storing either raw character data or NULL
    #' @return logical, TRUE if successful
    read_file = function(){
      self$raw = try(readLines(self$filename))
      result = inherits(self$raw, "try-error")
      if (result) {
        print(self$raw)
        self$raw = NULL
      } else {
        self$parse_data()
      }
      result
    }
  ) # public
)

#' Create a WDSpaleo object.
#'
#' @export
#' @param filename char, the URL or filename to read
#' @return WDSpaleo object
#' @examples 
#' \dontrun{
#' X = WDS_paleo(filename = example_filename("seguin_whitney2022"))
#' }
WDS_paleo = function(filename = example_filename("seguin_whitney2022")){
  WDSpaleo$new(filename = filename)
}
          