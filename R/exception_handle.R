#' Interprets HTTP status codes returned during API interactions and prints human-readable explanations for each known status code to the console. Primarily used for handling errors in API communication. It is intended for internal use within the package to handle errors during communication with the API.
#' @param status_code An integer representing the HTTP status code returned by an API request.
#' @return A message string explaining the error corresponding to the status code. The function directly prints the explanation to the console.
#' @noRd
handle_error_code <- function(status_code) {

  explanation <- switch(as.character(status_code),
                        "401" = "Authentication invalid or key incorrect or not part of the organization.",
                        "429" = "Rate limit reached or quota exceeded.",
                        "403" = "Access forbidden. You may not have the necessary permissions.",
                        "500" = "Server error during request processing. You may want to try again later.",
                        "503" = "Service unavailable or engine overloaded. Try again later.",
                        "404" = "Resource not found. Please check your URL address.",
                        "400" = "Bad request. Please check your request format.",
                        "502" = "Bad Gateway. The server received an invalid response from the upstream server.",
                        "503" = "Service unavailable. Please try again later.",
                        default = paste("Unknown error. Status code:", status_code)
  )

  message(explanation)

}


