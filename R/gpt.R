#' Internal function to interact with llama2 on multiple prompts
#'
#' This internal function sends requests to the Huggingface API, initiating a conversation with llama2 based on multiple prompts. It uses specified parameters for the llama model.
#' @import httr
#' @import rjson
#' @param messages A character strings that users want to send to llama
#' @param temperature A numeric value controlling randomness in Boltzmann distribution (lower values make the responses more deterministic).
#' @param max_tokens An integer indicating the maximum number of tokens in the output.
#' @param top_p A numeric value between 0 and 1 indicating the cumulative probability cutoff for token selection.
#' @return A  character strings containing the llama's responses.
#' @noRd
llama_chat <- function(
    messages="hi",
    temperature = 1.0,
    max_tokens = 100,
    top_p = 0.8
){

  if (is.null(Sys.getenv("key"))) {
    stop("API key is not set.")
  }

  headers <- c(
    'Authorization' = paste('Bearer', Sys.getenv("key")),
    'Content-Type' = 'application/json'
  )

  body <- list(
    inputs = messages,
    parameters = list(
      max_new_tokens = max_tokens,
      temperature = temperature,
      top_p = top_p,
      return_full_text = FALSE
    ),
    options = list(
      use_cache = FALSE
    )
  )


  tryCatch({

    res <- POST(
      url = Sys.getenv("url"),
      body = body,
      add_headers(headers),
      encode = "json",
      config = config(ssl_verifypeer = 0L, timeout = 300)
    )


    if(res$status_code != 200){
      response_content = paste("error with code:",res$status_code)
      print(response_content)
      stop(handle_error_code(res$status_code))
    }


    generated_text <-  content(res)[[1]]$generated_text
    content_list <- trimws(generated_text)

  }, warning = function(war) {

    print(paste("Caught warning:", war$message))

  }, error = function(err) {


    stop(err)

  })

  return(content_list)

}



#' Internal function to interact with ChatGPT on multiple prompts
#'
#' This internal function sends requests to the OpenAI API, initiating a conversation with ChatGPT based on multiple prompts. It uses specified parameters for the ChatGPT model.
#' @import httr
#' @import rjson
#' @param messages A list of character strings that users want to send to ChatGPT.
#' @param system_prompt A character string used to set the context for ChatGPT.
#' @param model A character string specifying the model of GPT (e.g., "gpt-3.5-turbo").
#' @param temperature A numeric value controlling randomness in Boltzmann distribution (lower values make the responses more deterministic).
#' @param max_tokens An integer indicating the maximum number of tokens in the output.
#' @param top_p A numeric value between 0 and 1 indicating the cumulative probability cutoff for token selection.
#' @param frequency_penalty A numeric value scaling the penalty for frequently occurring tokens.
#' @param presence_penalty A numeric value scaling the penalty for new token occurrences.
#' @param n An integer specifying the number of responses to generate.
#' @return A list of character strings containing the ChatGPT's responses.
#' @noRd
openai_chat <- function(
  messages = list(),
  system_prompt="you are a helpful Ai",
  model = "gpt-3.5-turbo-1106",
  temperature = 0.7,
  max_tokens = 100,
  top_p = 1.0,
  frequency_penalty = 0.0,
  presence_penalty = 0.0,
  n=1
){

  if (is.null(Sys.getenv("key"))) {
    stop("API key is not set.")
  }

  headers <- c(
    'Authorization' = paste('Bearer', Sys.getenv("key")),
    'Content-Type' = 'application/json'
  )

  body <- list(
    model = model,
    messages = messages,
    temperature = temperature,
    max_tokens = max_tokens,
    top_p = top_p,
    frequency_penalty = frequency_penalty,
    presence_penalty = presence_penalty,
    n = n
  )


  tryCatch({

    res <- POST(
      url = Sys.getenv("url"),
      body = body,
      add_headers(headers),
      encode = "json",
      config = config(ssl_verifypeer = 0L, timeout = 300)
    )


    if(res$status_code != 200){
      response_content = paste("error with code:",res$status_code)
      print(response_content)
      stop(handle_error_code(res$status_code))
    }


    response_text <- content(res, 'text', encoding = "UTF-8")


    res_json <- rjson::fromJSON(response_text)


    choices <- res_json$choices

    content_list <- sapply(choices, function(x) x$message$content)

  }, warning = function(war) {
    print(paste("Caught warning:", war$message))

  }, error = function(err) {

    stop(err)

  })


  return(content_list)

}

