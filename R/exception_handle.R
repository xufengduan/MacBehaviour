#' Interprets HTTP status codes returned during API interactions and prints human-readable explanations for each known status code to the console. Primarily used for handling errors in API communication. It is intended for internal use within the package to handle errors during communication with the API.
#' @param status_code An integer representing the HTTP status code returned by an API request.
#' @return A message string explaining the error corresponding to the status code. The function directly prints the explanation to the console.
#' @noRd
handle_error_code <- function(status_code) {

  explanation <- switch(as.character(status_code),
                        "401" = "Authentication invalid or key incorrect or not part of the organization.",
                        "429" = "Rate limit reached or quota exceeded.",
                        "500" = "Server error during request processing.",
                        "503" = "Engine overloaded, try again later.",
                        "404" = "check your url address",
                        "400" = "This request error",
                        default = "Unknown error."
  )

  message(explanation)

}


