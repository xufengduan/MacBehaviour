#' Internal function to interact with llama2
#'
#' This internal function sends requests to the Huggingface API, initiating a conversation with llama2 . It uses specified parameters for the llama model.
#' @import httr
#' @import rjson
#' @import dplyr
#' @param messages A character strings that users want to send to llama
#' @param ... Variable parameter lists allow you to input additional parameters supported by the model you're using. Note: You must ensure the validity of the parameters you enter; otherwise, an error will occur.
#' @return A  character strings containing the llama's responses.
#' @noRd
llama_chat <- function(
    messages="hi",
    ...
){

  api_key <- Sys.getenv("key")
  if (api_key == "") {
    stop("API key is required.")
  }

  headers <- c(
    'Authorization' = paste('Bearer', api_key),
    'Content-Type' = 'application/json'
  )

  body <- list(
    inputs = messages,
    parameters = modifyList(list(return_full_text = FALSE), list(...)),
    options = list(
    use_cache = FALSE
    )
  )

message(headers)
message(body)
  tryCatch({

    res <- POST(
      url = Sys.getenv("url"),
      body = body,
      add_headers(headers),
      encode = "json",
      config = config(ssl_verifypeer = 0L, timeout = 300)
    )

    if(res$status_code != 200 && res$status_code != 201){
      response_content = paste("error with code:",res$status_code)
      message(response_content)
      message(content(res, 'text', encoding = "UTF-8"))
      stop(handle_error_code(res$status_code))
    }
    
    response_text <- content(res, 'text', encoding = "UTF-8")
    message(response_text)

    generated_text <-  content(res)[[1]]$generated_text
    content_list <- trimws(generated_text)

  }, warning = function(war) {

    message(paste("Caught warning:", war$message))

  }, error = function(err) {


    stop(err)

  })

  result_list <- list(content_list = list(content_list), raw_response = response_text)
  return(result_list)

}



#' Internal function to interact with ChatGPT
#'
#' This internal function sends requests to the OpenAI API, initiating a conversation with ChatGPT. It uses specified parameters for the ChatGPT model.
#' @import httr
#' @import rjson
#' @param messages A list of character strings that users want to send to ChatGPT.
#' @param model A character string specifying the model of GPT (e.g., "gpt-3.5-turbo").
#' @param ... Variable parameter lists allow you to input additional parameters supported by the model you're using, such as n=2 / logprobs=TRUE... Note: You must ensure the validity of the parameters you enter; otherwise, an error will occur.
#' @return A list of character strings containing the ChatGPT's responses.
#' @noRd
openai_chat <- function(
    messages = list(list(role = "user", content = "Please repeat 'Setup Successful'. DON'T say anything else.")),
    model = Sys.getenv("model"),
    max_retries = 6000, 
    initial_wait_time = 10,  
    max_wait_time = 6000, 
    ...
){

  if (is.null(Sys.getenv("key"))) {
    stop("API key is not set.")
  }

  args <- list(
    model = model,
    messages = messages,
    ...
  )

  content_list <- NULL  
  response_text <- NULL  
  response_content <- NULL
  wait_time <- initial_wait_time
  
  for (attempt in 1:max_retries) {
    tryCatch({
      
      if (Sys.getenv("LOG_FILE") != "") {
        log_file_path <- Sys.getenv("LOG_FILE")
        log_file_connection <- file(log_file_path, open = "a")
        sink(log_file_connection, append = TRUE, type = "message")
        res <- POST(
          url = Sys.getenv("url"),
          body = toJSON(args),
          add_headers(
            'Content-Type' = 'application/json',
            'Authorization' = paste('Bearer', Sys.getenv("key")),
            'X-use-cache' = "false"
          ),
          verbose(data_out = TRUE, data_in = FALSE, info = FALSE)
        )
        sink(type = "message")
      } else {
        res <- POST(
          url = Sys.getenv("url"),
          body = toJSON(args),
          add_headers(
            'Content-Type' = 'application/json',
            'Authorization' = paste('Bearer', Sys.getenv("key")),
            'X-use-cache' = "false"
          )
        )
      }
      
      if(res$status_code == 200 || res$status_code == 201){
        response_text <- content(res, 'text', encoding = "UTF-8")
        res_json <- fromJSON(response_text)
        choices <- res_json$choices
        content_list <- sapply(choices, function(x) x$message$content)
        break  
      }

      if(res$status_code == 429) {
        message(paste("Too many requests. Retrying in", wait_time, "seconds..."))
        Sys.sleep(wait_time)
        wait_time <- min(wait_time + wait_time, max_wait_time)  
      } else {
        response_content <- paste("error with code:", res$status_code)
        message(response_content)
        message(content(res, 'text', encoding = "UTF-8"))
        stop(paste("Request failed with status code", res$status_code))
      }
      
    }, warning = function(war) {
      message(paste("Caught warning:", war$message))
    }, error = function(err) {
      if (!is.null(response_content)) {
        message(response_content)
      }
      stop(err)
    })
    
    if (attempt == max_retries) {
      stop("Maximum retries exceeded. Unable to complete the request.")
    }
  }
  
  result_list <- list(content_list = content_list, raw_response = response_text)
  return(result_list)
}



#' Internal function to interact with claude
#'
#' This internal function sends requests to the claude API, initiating a conversation with claude. It uses specified parameters for the claude model.
#' @import httr
#' @import rjson
#' @param messages A list of character strings that users want to send to claude.
#' @param model A character string specifying the model of claude (e.g., "claude-3-sonnet-20240229").
#' @param version When using the Claude model, the version parameter required defaults to "2023-06-01".
#' @param ... Variable parameter lists allow you to input additional parameters supported by the model you're using. Note: You must ensure the validity of the parameters you enter; otherwise, an error will occur.
#' @return A list of character strings containing the claude's responses.
#' @noRd
claude_chat <- function(
  messages = list(list(role = "user", content = "Please repeat 'Setup Successful'. DON'T say anything else.")),
  model = "claude-3-sonnet-20240229",
  max_tokens = 1024,
  version = "2023-06-01",
  ...
){

  if (is.null(Sys.getenv("key"))) {
    stop("API key is not set.")
  }


  headers <- c(
    'x-api-key' = Sys.getenv("key"),
    'anthropic-version' = version,
    'content-type' = 'application/json'
  )

  args <- list(
    model = model,
    messages = messages,
    max_tokens = max_tokens,
    ...
  )


  tryCatch({

    res <- POST(
      url = Sys.getenv("url"),
      add_headers(headers),
      body = toJSON(args),
      encode = "json",
      config = config(ssl_verifypeer = 0L, timeout = 300)
    )
    
    if(res$status_code != 200 && res$status_code != 201){
      response_content = paste("error with code:",res$status_code)
      message(response_content)
      message(content(res, 'text', encoding = "UTF-8"))
      stop(handle_error_code(res$status_code))
    }


    response_text <- content(res, 'text', encoding = "UTF-8")

    res_json <- rjson::fromJSON(response_text)


    content <- res_json$content

    content_text <- content[[1]]$text



  }, warning = function(war) {
    message(paste("Caught warning:", war$message))

  }, error = function(err) {

    stop(err)

  })

  result_list <- list(content_list = list(content_text), raw_response = response_text)
  return(result_list)
}


#' Internal function to interact with gemini
#'
#' This internal function sends requests to the gemini API, initiating a conversation with gemini. It uses specified parameters for the gemini model.
#' @import httr
#' @import rjson
#' @param messages A list of character strings that users want to send to gemini.
#' @param Retrieve the model from the environment variables
#' @param version When using the gemini model, the version parameter required defaults to "2023-06-01".
#' @param ... Variable parameter lists allow you to input additional parameters supported by the model you're using. Note: You must ensure the validity of the parameters you enter; otherwise, an error will occur.
#' @return A list of character strings containing the gemini's responses.
#' @noRd
gemini_chat <- function(
  messages = list(list(parts = list(text = "Please repeat 'Setup successful'. DON'T say anything else at the beginning of your reponse."))),
  model = Sys.getenv("model"),
  ...
){

  if (is.null(Sys.getenv("key"))) {
    stop("API key is not set.")
  }
  gptConfig <- tryCatch(get("gptConfig", envir = .GlobalEnv), error = function(e) NULL)
  if (exists("gptConfig")) {
    if (!is.null(gptConfig$systemPrompt) && gptConfig$systemPrompt != "") {
      system_instruction <- list(parts = list(text = gptConfig$systemPrompt))
    } else {
      system_instruction <- ""
    }
  } else {
    system_instruction <- ""
  }

  generationConfig = list(...)

  if (system_instruction == "") {
    body <- list(
      contents = messages,
      model = model
    )
    
    if (!is.null(generationConfig)) {
      body$generationConfig <- generationConfig
    }
    
  } else {
    body <- list(
      system_instruction = system_instruction,
      contents = messages,
      model = model
    )
    
    if (!is.null(generationConfig)) {
      body$generationConfig <- generationConfig
    }
  }
# message(body)

  current_url <- paste0("https://generativelanguage.googleapis.com/v1beta/models/",model,":generateContent?key=",Sys.getenv("key"))

  tryCatch({
    
    if (Sys.getenv("LOG_FILE") != "") {
      log_file_path <- Sys.getenv("LOG_FILE")
      log_file_connection <- file(log_file_path, open = "a")
      sink(log_file_connection, append = TRUE, type = "message")
      res <- POST(
        url = current_url,
        body = body,
        encode = "json",
        config = config(ssl_verifypeer = 0L, timeout = 300),
        verbose(data_out = TRUE, data_in = FALSE, info = FALSE)
      )
      sink(type = "message")
    } else {
      res <- POST(
        url = current_url,
        body = body,
        encode = "json",
        config = config(ssl_verifypeer = 0L, timeout = 300)
        #verbose(data_out = TRUE, data_in = FALSE, info = FALSE)
      )
      }


    if(res$status_code != 200 && res$status_code != 201){
      response_content = paste("error with code:",res$status_code)
      message(response_content)
      message(content(res, 'text', encoding = "UTF-8"))
      stop(handle_error_code(res$status_code))
    }

    response_text <- content(res, 'text', encoding = "UTF-8")

    res_json <- rjson::fromJSON(response_text)

    if(!is.null(res_json$candidates[[1]]$finishReason)){
      if(res_json$candidates[[1]]$finishReason=="MAX_TOKENS"){
        stop("over max tokens limited")
      }
    }

    if(!is.null(res_json$promptFeedback$blockReason)) {
      content_text<-"Prompt Safety Error!"
    }
    else{
      content <- res_json$candidates[[1]]$content
      parts <- content$parts
      content_text <- parts[[1]]$text
    }

  }, warning = function(war) {
    message(paste("Caught warning:", war$message))

  }, error = function(err) {

    stop(err)

  })

  result_list <- list(content_list = list(content_text), raw_response = response_text)
  return(result_list)

}

#' Internal function to interact with baichuan
#'
#' This internal function sends requests to the baichuan API, initiating a conversation with baichuan. It uses specified parameters for the baichuan model.
#' @import httr
#' @import rjson
#' @param messages A list of character strings that users want to send to baichuan.
#' @param model A character string specifying the model of baichuan (e.g., "Baichuan2-Turbo").
#' @param ... Variable parameter lists allow you to input additional parameters supported by the model you're using. Note: You must ensure the validity of the parameters you enter; otherwise, an error will occur.
#' @return A list of character strings containing the baichuan's responses.
#' @noRd
baichuan_chat <- function(
  messages = list(),
  model = "Baichuan2-Turbo",
  ...
){

  if (is.null(Sys.getenv("key"))) {
    stop("API key is not set.")
  }

  headers <- c(
    'Authorization' = paste('Bearer', Sys.getenv("key")),
    'Content-Type' = 'application/json'
  )

  args <- list(
    messages = messages,
    model = model
  )

  tryCatch({

    res <- POST(
      url = Sys.getenv("url"),
      body = modifyList(args, list(...)),
      add_headers(headers),
      encode = "json",
      config = config(ssl_verifypeer = 0L, timeout = 300)
    )

    if(res$status_code != 200 && res$status_code != 201){
      response_content = paste("error with code:",res$status_code)
      message(response_content)
      message(content(res, 'text', encoding = "UTF-8"))
      stop(handle_error_code(res$status_code))
    }

    response_text <- content(res, 'text', encoding = "UTF-8")

    res_json <- rjson::fromJSON(response_text)

    choices <- res_json$choices

    content_list <- sapply(choices, function(x) x$message$content)

  }, warning = function(war) {
    message(paste("Caught warning:", war$message))

  }, error = function(err) {

    stop(err)

  })

  result_list <- list(content_list = content_list, raw_response = response_text)
  return(result_list)

}

#' Internal function to interact with openai completion api
#'
#' This internal function sends requests to the OpenAI Completion API, initiating a conversation with ChatGPT. It uses specified parameters for the ChatGPT model.
#' @import httr
#' @import rjson
#' @param messages A list of character strings that users want to send to ChatGPT.
#' @param model A character string specifying the model of GPT (e.g., "gpt-3.5-turbo-instruct").
#' @param ... Variable parameter lists allow you to input additional parameters supported by the model you're using, such as  logprobs=2... Note: You must ensure the validity of the parameters you enter; otherwise, an error will occur.
#' @return A list of character strings containing the ChatGPT's responses.
#' @noRd
openai_completion <- function(
  prompt = "Please repeat 'Setup successful'. DON'T say anything else.",
  model = "gpt-3.5-turbo-instruct",
  ...
){
  if (is.null(Sys.getenv("key"))) {
    stop("API key is not set.")
  }

  headers <- c(
    'Authorization' = paste('Bearer', Sys.getenv("key")),
    'Content-Type' = 'application/json'
  )

  args <- list(
    prompt = prompt,
    model = model
  )
  
  log_file_path <- Sys.getenv("LOG_FILE")
  log_file_connection <- file(log_file_path, open = "a")

  tryCatch({
  
    sink(log_file_connection, append = TRUE, type = "message")

    res <- POST(
      url = Sys.getenv("url"),
      body = toJSON(args),  
      add_headers(
        'Content-Type' = 'application/json',
        'Authorization' = paste('Bearer', Sys.getenv("key")),
        'X-use-cache' = "false"
      ),
      encode = "json",
      verbose(data_out = TRUE, data_in = TRUE, info = FALSE)  # 捕获详细信息
    )
    
    sink(type = "message")
    
    if(res$status_code != 200 && res$status_code != 201){
      response_content = paste("error with code:",res$status_code)
      message(response_content)
      message(content(res, 'text', encoding = "UTF-8"))
      stop(handle_error_code(res$status_code))
    }

    response_text <- content(res, 'text', encoding = "UTF-8")

    res_json <- rjson::fromJSON(response_text)

    choices <- res_json$choices

    content_list <- sapply(choices, function(x) x$text)
  }, warning = function(war) {
    message(paste("Caught warning:", war$message))
  }, error = function(err) {
    stop(err)
  })

  result_list <- list(content_list = content_list, raw_response = response_text)
  return(result_list)
}

#' Internal function to interact with baichuan
#'
#' This internal function sends requests to the baichuan API, initiating a conversation with baichuan. It uses specified parameters for the baichuan model.
#' @import httr
#' @import rjson
#' @param messages A list of character strings that users want to send to baichuan.
#' @param model A character string specifying the model of baichuan (e.g., "Baichuan2-Turbo").
#' @param ... Variable parameter lists allow you to input additional parameters supported by the model you're using. Note: You must ensure the validity of the parameters you enter; otherwise, an error will occur.
#' @return A list of character strings containing the baichuan's responses.
#' @noRd

wenxin_chat <- function(messages = list(list(role = "user", content = "Please repeat 'Setup successful'. DON'T say anything else.")), ...) {
  model = Sys.getenv("model")
  if (tolower(model) == "yi-34b-chat") {
    model <- "yi_34b_chat"
  }
  api_key = Sys.getenv("key")
  secret_key = Sys.getenv("secret_key")
  url = Sys.getenv("url")
  
  
  get_access_token <- function(api_key, secret_key) {
    url_access_token <- paste0("https://aip.baidubce.com/oauth/2.0/token?grant_type=client_credentials&client_id=", api_key, "&client_secret=", secret_key)
    res <- GET(url_access_token)
    
    if (res$status_code != 200 && res$status_code != 201) {
      stop(paste("Error getting access token, status code:", res$status_code))
    }
    
    res_json <- fromJSON(content(res, "text", encoding = "UTF-8"))
    return(res_json$access_token)
  }
  
  access_token <- get_access_token(api_key, secret_key)
  
  headers <- c('Content-Type' = 'application/json')
  
  #message("wenxin_chat: messages: ", messages)
  args <- list(
    messages = messages,
    ...
  )
  
  #message("wenxin_chat: args: ", args)


  tryCatch({
    res <- POST(
      #url = model_url,
      url = paste0("https://aip.baidubce.com/rpc/2.0/ai_custom/v1/wenxinworkshop/chat/",model,"?access_token=",access_token),
      body = toJSON(args),
      add_headers(headers),
      encode = "json",
      config = config(ssl_verifypeer = 0L, timeout = 300)
    )
    #message(res)
    
    if (res$status_code != 200 && res$status_code != 201) {
      response_content = paste("Error with code:", res$status_code)
      message(response_content)
      message(content(res, 'text', encoding = "UTF-8"))
      stop(paste("Error:", res$status_code))
    }
    
    response_text <- content(res, 'text', encoding = "UTF-8")
    
    
    res_json <- fromJSON(response_text)
    
    # message(res_json)
    result <- list(content_list = res_json$result, raw_response = response_text)
  }, warning = function(war) {
    message(paste("Caught warning:", war$message))
  }, error = function(err) {
    stop(err)
  })
  
  return(result)
}
