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
#'
  tiktokenTokenizer <- function(textList){
    response <- POST("http://chat.cuhklpl.com/tokenList", body = list(textList = textList,model_name=Sys.getenv("model")), encode = "json")
    if (status_code(response) == 200) {
      message(content(response)$info)
      return(content(response)$tokenList)
    } else {
      warning("There is a mistake for token check. Please make sure that the max token number does not exceed the model's limitation.")
    }
  }

#######################################Tokenizer#############################################





#######################################addContent#############################################
#' Internal addContent
#'
#' @description
#' This internal function is used to append a new message's content.
#' @param content A character string: a new message's content
#' @param imgDetail A character string: In OpenAI's multimodal model for images, the quality parameter of an image is set to "auto" by default.
#' @return Returns the number of tokens in the provided text or stops with an error message if the API call fails.
#'
#' @noRd
addContent <- function(content, imgDetail) {
  pattern <- "<text>.*?</text>|<img>.*?</img>|[^<>]+"
  elements <- unlist(regmatches(content, gregexpr(pattern, content, perl = TRUE)))
  content_str <- list()
  for (element in elements) {
    if (grepl("^<text>.*</text>$", element)) {
      text <- gsub("</?text>", "", element)
      content_str <- append(content_str, list(list(type = "text", text = text)))
    } else if (grepl("^<img>.*</img>$", element)) {
      imgUrl <- gsub("</?img>", "", element)
      content_str <- append(content_str, list(list(type = "image_url", image_url = list(url = imgUrl, detail = imgDetail))))
    } else {
      content_str <- append(content_str, list(list(type = "text", text = element)))
    }
  }

  return(content_str)
}

#######################################addContent#############################################











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
#' @param imgDetail A character string: In OpenAI's multimodal model for images, the quality parameter of an image is set to "auto" by default.
#' @return Returns the updated list of messages after adding the new message.
#'
#' @noRd
addMessage <-function (messages,role="user",content="",imgDetail="low"){

  if(Sys.getenv("llm")=="llama-2"){
    new_message <- switch(role,
                          "system" = paste0("<<SYS>>\n", content, "\n<</SYS>>\n\n"),
                          "user" = paste0(content, " [/INST] "),
                          "assistant" = paste0(content, "</s>\n<s>[INST] "),
                          ""
    )
    return(paste0(messages, new_message))
  }
  else if(Sys.getenv("llm")=="llama-3"){
    new_message <- switch(role,
                          "system" = paste0("<|start_header_id|>system<|end_header_id|>\n\n", content, "<|eot_id|>"),
                          "user" = paste0("<|start_header_id|>user<|end_header_id|>\n\n",content, "<|eot_id|>\n"),
                          "assistant" = paste0("<|start_header_id|>assistant<|end_header_id|>\n\n",substring(content, 12),"<|eot_id|>\n"),
                          ""
    )
    return(paste0(messages, new_message))
  }

  else if((Sys.getenv("llm")=="chatgpt")||(Sys.getenv("llm")=="openai")||(Sys.getenv("llm")=="custom")){
      messages <- append(messages,
                      list(
                        list(
                          role = role,
                          content = addContent(content,imgDetail)
                        )
                      )
      )

    return(messages)
  }
  else if(Sys.getenv("llm")=="claude"){
      messages <- append(messages,
                         list(
                      list(
                        role = role,
                        content = content
                      )
                    )
      )

    return(messages)
  }
  else if((Sys.getenv("llm")=="gemini")){
    newMessage <- list(
      role = role,
      parts = list(
        list(
          text = content
        )
      )
    )
    messages <- append(messages, list(newMessage))
    return(messages)

    return(messages)
  }
  else if((Sys.getenv("llm")=="baichuan")){
    messages <- append(messages,
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
#' This function allows users to set and verify an API key for data collection. You can change the default api_url for others models' API.
#'
#'
#' @param api_key A character string: the user's OpenAI/huggingface/gemini/claude/baichuan/other API key.Please fill 'NA' for self-deployed models.
#' @param api_url A character string: the user's OpenAI/huggingface/gemini/claude/baichuan/other url .default is OpenAI. for gemini, you just input "https://generativelanguage.googleapis.com/"
#' @param model  A character string: specify the model version.For gemini, you could input "gemini-pro"
#' @return Prints a message to the console indicating whether the API key setup was successful.
#' If the setup fails, the function stops with an error message.
#'
#' @examples
#' \dontrun{
#' set_key(api_key="YOUR_API_KEY", api_url="api.openai.com/v1/chat/completions",model="gpt-3.5-turbo")
#' }
#' @export
setKey <- function(api_key,api_url="https://api.openai.com/v1/chat/completions",model){
  if (!is.null(api_key) && is.character(api_key)) {

    if(grepl("aimlapi",tolower(api_url))){
      Sys.setenv(llm="aimlapi")
    }
    else{
      if(grepl("gpt",tolower(model))){
        Sys.setenv(llm="openai")
      }
      else if(grepl("baichuan",tolower(model))){
        Sys.setenv(llm="baichuan")
      }
      else if(grepl("claude",tolower(model))){
        Sys.setenv(llm="claude")
      }
      else if(grepl("gemini",tolower(model))){
        Sys.setenv(llm="gemini")
      }
      else if(grepl("llama-3",tolower(model))){
        Sys.setenv(llm="llama-3")
      }
      else if(grepl("llama",tolower(model))){
        Sys.setenv(llm="llama-2")
      }
      else{
        Sys.setenv(llm="custom")
      }
    }


    Sys.setenv(key=api_key)
    Sys.setenv(url=api_url)
    Sys.setenv(model=model)

    switch(tolower(Sys.getenv("llm")),
           "openai" = chatgpt_test(api_key,model),
           "llama-3" = llama3_test(api_key,model),
           "llama-2" = llama2_test(api_key,model),
           "claude"= claude_test(api_key,model),
           "gemini"= gemini_test(api_key,model),
           "baichuan"= baichuan_test(api_key,model),
           "custom"= custom_test(model),
           "aimlapi"=aimlapi_test(api_key,model),
           stop("Failed to the interact with the LLM.")
    )
  }
  else {
    stop("Failed to the interact with the LLM.")
  }
}

#######################################setkey############################################
#' Internal model test function
#'
#' @description
#' This internal function is designed to verify the correctness of the API key and ensure that communication with the model is functioning properly.
#'
#' @param api_key A character string: the user's OpenAI/huggingface/gemini/claude/baichuan/other API key.Please fill 'NA' for self-deployed models.
#' @param model  A character string: specify the model version.For gemini, you could input "gemini-pro"
#' @return If the test is normal, it will display "Setup api_key successful!"
#'
#' @noRd
chatgpt_test <- function(key,model){

  if (grepl("chat", Sys.getenv("url"))) {
    message(openai_chat(list(
      list(
        role = "user",
        content = "this is a test,please say 'Setup api_key successful!'"
      )
    ),max_tokens = 10,temperature = 0.1,model=model)$content_list)
    message(paste("your api_key:",key))
  }
  else{
    message(openai_completion(list(
      list(
        role = "user",
        content = "this is a test,please say 'Setup api_key successful!'"
      )
    ),max_tokens = 10,temperature = 0.1,model=model)$content_list)
    message(paste("your api_key:",key))
  }


}

#' Internal model test function
#'
#' @description
#' This internal function is designed to verify the correctness of the API key and ensure that communication with the model is functioning properly.
#'
#' @param api_key A character string: the user's OpenAI/huggingface/gemini/claude/baichuan/other API key.Please fill 'NA' for self-deployed models.
#' @param model  A character string: specify the model version.For gemini, you could input "gemini-pro"
#' @return If the test is normal, it will display "Setup api_key successful!"
#'
#' @noRd
llama2_test <- function(key,model){
  message(llama_chat("<s>[INST] <<SYS>>
You are a helpful AI, please answer according to my instruction, do not output other irrelevant content.
<</SYS>>

please repeat: 'Setup api_key successful!' [/INST]",max_tokens = 30,temperature = 0.1)$content_list)
  message(paste("your api_key:",key))

  Sys.setenv(model = "llama-2")
}

#' Internal model test function
#'
#' @description
#' This internal function is designed to verify the correctness of the API key and ensure that communication with the model is functioning properly.
#'
#' @param api_key A character string: the user's OpenAI/huggingface/gemini/claude/baichuan/other API key.Please fill 'NA' for self-deployed models.
#' @param model  A character string: specify the model version.For gemini, you could input "gemini-pro"
#' @return If the test is normal, it will display "Setup api_key successful!"
#'
#' @noRd
llama3_test <- function(key,model){
  message(llama_chat("<|begin_of_text|><|start_header_id|>system<|end_header_id|>

You are a helpful AI, please answer according to my instruction, do not output other irrelevant content. <|eot_id|><|start_header_id|>user<|end_header_id|>

please repeat: 'Setup api_key successful!'<|eot_id|><|start_header_id|>assistant<|end_header_id|>",max_tokens = 30,temperature = 0.1)$content_list)
  message(paste("your api_key:",key))
  
  Sys.setenv(model = "llama-3")
}


#' Internal model test function
#'
#' @description
#' This internal function is designed to verify the correctness of the API key and ensure that communication with the model is functioning properly.
#'
#' @param api_key A character string: the user's OpenAI/huggingface/gemini/claude/baichuan/other API key.Please fill 'NA' for self-deployed models.
#' @param model  A character string: specify the model version.For gemini, you could input "gemini-pro"
#' @return If the test is normal, it will display "Setup api_key successful!"
#'
#' @noRd
claude_test <- function(key,model){
  message(claude_chat(messages=list(
    list(
      role = "user",
      content = "this is a test,please say 'Setup api_key successful!'"
    )
  ),max_tokens = 10,temperature = 0.1,model=model,version ="2023-06-01")$content_list)
  message(paste("your api_key:",key))
}

#' Internal model test function
#'
#' @description
#' This internal function is designed to verify the correctness of the API key and ensure that communication with the model is functioning properly.
#'
#' @param api_key A character string: the user's OpenAI/huggingface/gemini/claude/baichuan/other API key.Please fill 'NA' for self-deployed models.
#' @param model  A character string: specify the model version.For gemini, you could input "gemini-pro"
#' @return If the test is normal, it will display "Setup api_key successful!"
#'
#' @noRd
gemini_test <- function(key,model){
  message(gemini_chat(messages = list(list(parts = list(list(text = "this is a test,please say 'Setup api_key successful!'"))))
  ,maxOutputTokens = 10,temperature = 0.1,model = model)$content_list)
  message(paste("your api_key:",key))
}

#' Internal model test function
#'
#' @description
#' This internal function is designed to verify the correctness of the API key and ensure that communication with the model is functioning properly.
#'
#' @param api_key A character string: the user's OpenAI/huggingface/gemini/claude/baichuan/other API key.Please fill 'NA' for self-deployed models.
#' @param model  A character string: specify the model version.For gemini, you could input "gemini-pro"
#' @return If the test is normal, it will display "Setup api_key successful!"
#'
#' @noRd
custom_test <- function(model){
  if (grepl("chat", Sys.getenv("url"))) {
    message(openai_chat(list(
      list(
        role = "user",
        content = "this is a test,please say 'Model test successful!'"
      )
    ),max_tokens = 10,temperature = 0.1,model=Sys.getenv("model"))$content_list)

  } else {
    # 不包含chat
    message(openai_completion(list(
      list(
        role = "user",
        content = "this is a test,please say 'Model test successful!'"
      )
    ),max_tokens = 15,model=Sys.getenv("model"))$content_list)
  }

}

#' Internal model test function
#'
#' @description
#' This internal function is designed to verify the correctness of the API key and ensure that communication with the model is functioning properly.
#'
#' @param api_key A character string: the user's OpenAI/huggingface/gemini/claude/baichuan/other API key.Please fill 'NA' for self-deployed models.
#' @param model  A character string: specify the model version.For gemini, you could input "gemini-pro"
#' @return If the test is normal, it will display "Setup api_key successful!"
#'
#' @noRd
baichuan_test <- function(key,model){
  message(baichuan_chat(list(
    list(
      role = "user",
      content = "this is a test,please say 'Setup api_key successful!'"
    )
  ),max_tokens = 10,temperature = 0.1,model=model)$content_list)
  message(paste("your api_key:",key))
}


#' Internal model test function
#'
#' @description
#' This internal function is designed to verify the correctness of the API key and ensure that communication with the model is functioning properly.
#'
#' @param api_key A character string: the user's OpenAI/huggingface/gemini/claude/baichuan/other API key.Please fill 'NA' for self-deployed models.
#' @param model  A character string: specify the model version.For gemini, you could input "gemini-pro"
#' @return If the test is normal, it will display "Setup api_key successful!"
#'
#' @noRd
aimlapi_test <- function(key,model){
  message(openai_chat(list(
    list(
      role = "user",
      content = "this is a test,please say 'Setup api_key successful!'"
    )
  ),max_tokens = 10,temperature = 0.1,model=model)$content_list)
  message(paste("your api_key:",key))
}