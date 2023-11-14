#' magicTokenizer
#'
#' @description
#' This function provides the number of tokens in a specified text, acting as a wrapper for an internal tokenizer function.
#'
#' @param text A character string: the text for which the number of tokens is required.
#'
#' @return Returns the number of tokens in the provided text.
#'
#' @export
  magicTokenizer <- function(text) {
  return(tiktokenTokenizer(text))
}

#' Internal Token Counter
#'
#' @description
#' This internal function interacts with an API to determine the number of tokens in a specified text.
#' This is an essential part of managing interactions with the GPT-3 API to ensure requests remain within token limits.
#' @import httr
#' @importFrom httr POST
#' @param text A character string: the text for which the number of tokens is required.
#'
#' @return Returns the number of tokens in the provided text or stops with an error message if the API call fails.
#'
#' @noRd
  tiktokenTokenizer <- function(textList){
    response <- POST("http://156.224.26.83:1001/tokenList", body = list(textList = textList), encode = "json")

    if (status_code(response) == 200) {

      return(content(response)$tokenList)
    } else {
      warning("There is a mistake for token check. Please make sure that the max token number does not exceed the model's limitation.")
    }
  }



#######################################Tokenizer############################################



#######################################addMessage############################################
#' Internal Message Adder
#'
#' @description
#' This internal function is used to append a new message (composed of role and content) to an existing list of messages.
#' This is used internally to manage dialog flows within the experimentation platform.
#'
#' @param messages A list of existing messages, each as a list containing role and content.
#' @param role A character string indicating the role for the new message.
#' @param content A character string containing the actual text of the new message.
#'
#' @return Returns the updated list of messages after adding the new message.
#'
#' @noRd
addMessage <-function (messages,role="user",content=""){

  if(Sys.getenv("model")=="llama"){
    new_message <- switch(role,
                          "system" = paste0("<s>[INST] <<SYS>>\n", content, "\n<</SYS>>\n"),
                          "user" = paste0(content, " [/INST] "),
                          "assistant" = paste0(content, " </s><s>[INST] "),
                          ""
    )
    return(paste0(messages, new_message))
  }

  if(Sys.getenv("model")=="openai"){
    messages=append(messages,
                    list(
                      list(
                        role = role,
                        content = content
                    )
                  )
    )
    return(messages)
  }
}

#######################################addMessage############################################


#######################################setkey############################################
#' Step1: Set model's API key and url.
#'
#' @description
#' This function allows users to set and verify an API key for data collection. You can change the default api_url for open-source models' API.
#'
#' @param api_key A character string: the user's OpenAI/huggingface/other API key.
#' @param api_url A character string: the user's OpenAI/huggingface/other url .default is OpenAI.
#' @return Prints a message to the console indicating whether the API key setup was successful.
#' If the setup fails, the function stops with an error message.
#'
#' @examples
#' \dontrun{
#' set_key(api_key="YOUR_API_KEY", api_url="https://api.openai.com/v1/chat/completions")
#'
#'
#' }
#' @export
setKey <- function(api_key,api_url="https://api.openai.com/v1/chat/completions"){
  if (!is.null(api_key) && is.character(api_key)) {

    Sys.setenv(key=api_key)
    Sys.setenv(url=api_url)

    if(grepl("others", api_key)){
      #todo
      print(openai_chat(addMessage(list(),"user","this is a test,please say 'Setup api_key successful!'"),max_tokens = 10,temperature = 0.1))
      Sys.setenv(model = "others")
    }
    else if(grepl("openai", api_url)){
      print(openai_chat(list(
        list(
          role = "user",
          content = "this is a test,please say 'Setup api_key successful!'"
        )
      ),max_tokens = 10,temperature = 0.1))
      print(paste("your api_key:",Sys.getenv("key")))
      Sys.setenv(model = "openai")
    }
    else if(grepl("llama", api_url)){
      print(llama_chat("<s>[INST] <<SYS>>
You are a helpful AI, please answer according to my requirements, do not output other irrelevant content
<</SYS>>

please say 'Setup api_key successful!' [/INST]",max_tokens = 30,temperature = 0.1))
      print(paste("your api_key:",Sys.getenv("key")))

      Sys.setenv(model = "llama")
    }
    else {
      stop("not support")
    }

  } else {
    stop("Invalid API key format")
  }
}

#######################################setkey############################################
