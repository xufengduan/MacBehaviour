#' Internal Token Check for Individual Trials
#'
#' @description
#' This internal function calculates the number of tokens for each prompt within individual trials in the provided data.
#' It serves to warn if the maximum allowed token limit is exceeded for any specific trial.
#'
#' @param data The data frame containing the prompts for each trial.
#' @param max_tokens The user-defined maximum number of tokens allowed per model response.
#' @param systemPrompt The system-defined prompt text.
#' @param n The number of responses per prompt, used for token calculation.
#'
#' @return Invisibly returns the token usage statistics and provides a warning if the token limit is exceeded for any trial.
#' This function is intended for internal use and not exported.
#'
#'
#' @noRd
tokenCheckOne <- function (data,max_tokens,systemPrompt,n){

  tokens_list <- tiktokenTokenizer(data$Prompt)
  tokens_vector <- unlist(tokens_list)

  token_sum = sum(tokens_vector)+ nrow(data) * n * max_tokens
  token_max = max(tokens_vector)

  result <- data.frame(
    CheckItem = c("item numbers", "max_token_numbers"),
    Values = c(nrow(data),token_max)
  )

  print(result)

  system_tokens <- tiktokenTokenizer(list(systemPrompt))[1]

  # warning("The max token number of Your input & output (systemPrompt+prompt+n*max_tokens) is ",(token_max+n*max_tokens+as.numeric(system_tokens))," among trails, please check the maximum token limit for the current model.")
  print("checked.")
}


#' Internal Token Check for Individual Trials
#'
#' @description
#' This internal function calculates the number of tokens for each prompt within individual trials in the provided data.
#' It serves to warn if the maximum allowed token limit is exceeded for any specific trial, based on the constraints of the gpt-3.5-turbo-1106 API.
#'
#' @import dplyr
#' @param data The data frame containing the prompts for each trial.
#' @param max_tokens The user-defined maximum number of tokens allowed per model response.
#' @param systemPrompt The system-defined prompt text.
#' @param n The number of responses per prompt, used for token calculation.
#'
#' @return Invisibly returns the token usage statistics and provides a warning if the token limit is exceeded for any trial.
#' This function is intended for internal use and not exported.
#'
#' @noRd
tokenCheckRun <- function (data,max_tokens,systemPrompt){
  ####################################################################
  show <- data.frame(Run = numeric(0))
  session_data <- data[data$Session == 1, ]
    # Run loop

  for (r in unique(data$Run)) {
    r_data <- session_data[session_data$Run == r, ]

    prompt_tokens_list <- unlist(tiktokenTokenizer(r_data$Prompt))
    prompt_tokens_vector <- unlist(prompt_tokens_list)
    prompt_token_sum = sum(prompt_tokens_vector)

    max_token_per_run = nrow(r_data) * (max_tokens + as.numeric(tiktokenTokenizer(list(systemPrompt))[1])) + prompt_token_sum
    new_row <- data.frame(Run = r, max_tokens_per_run = max_token_per_run)

    show <- rbind(show, new_row)
  }

  print(show)
  # warning("The max token number among runs is ",max(show$sum_tokens_per_run),",please check the maximum allowed limit for current model.")
  print("checked.")
}

#' Step4: Pre-check for token usage in experiment design.
#'
#' Configures experimental parameters before execution.
#'
#' @param data A data.frame that has been structured by the 'experimentDesign' function, containing the experimental setup.
#' @param checkToken Whether to perform token count check, select TRUE to submit your experiment to our server's tokenizer for token count check, the default selection is FALSE (i.e., no token check will be performed, but you need to manually check if the number of tokens exceeds the model limit to avoid errors in the experiment).
#' @param systemPrompt The system prompt text used in the chatGPT model interaction. If left empty, a space character is assumed.
#' @param max_tokens The maximum number of tokens allowed for the model's response, default is 500.
#' @param temperature The temperature setting for the chatGPT model, controlling randomness. Default is 0.7.
#' @param top_p The top_p setting for the chatGPT model, controlling the diversity of responses. Default is 0.9.
#' @param n The number of model responses per prompt, default is 1. Relevant only if 'oneTrialMode' is TRUE.
#' @return A list containing the original data and the parameters for the chatGPT model interaction, confirming that the setup has passed the token checks or indicating issues if found.
#' @export
#'
#' @examples
#' \dontrun{
#'
#' gptConfig=preCheck(Design, systemPrompt="You are a participant in a psycholinguistic experiment",
#'                     max_tokens=10,temperature=0.7,top_p=1,n=1)
#'
#' # Assuming 'exp_design' is the data obtained from 'experimentDesign' function
#'
#' Design=experimentDesign(ExperimentItem,Step=1,random = TRUE)
#'
#' }
preCheck <- function (data, checkToken=F,systemPrompt="",max_tokens=500,temperature=1.0,top_p=1,n=1){

  if(Sys.getenv("model")=="llama" && top_p==1)
  {
    top_p=0.9
  }
  if(Sys.getenv("model")=="llama" && temperature==1)
  {
    temperature=0.7
  }

  session_data <- data[data$Session == 1, ]

  if(any(duplicated(session_data$Run))){
    oneTrialMode=FALSE
  }else{
    oneTrialMode=TRUE
  }

  if(n!=1 && Sys.getenv("model")=="llama")
  {
    stop("there is no n parameter for Llama. If you want to collect mutiple responses per item, please use step parameter in experimentDesign function.")
  }


  if(oneTrialMode){
    if(checkToken){
      result <- tryCatch({
        tokenCheckOne(data,max_tokens,systemPrompt,n)
      }, error = function(e) {
        warning("There was an error in token Check: Failed to connect server, but it doesn't affect continued use.")
        NULL
      })
    }

    gptConfig=list(data,systemPrompt=systemPrompt,model=Sys.getenv("model"),max_tokens=max_tokens,temperature=temperature,top_p=top_p,n=n)
    return(gptConfig)
  }

  else{
    if(n>1){
      warning("In the multi-turn dialogue mode (i.e., not the One Trial per Run model), n cannot be greater than 1; the operation will proceed with n=1.")
    }

    if(checkToken){
      result <- tryCatch({
        tokenCheckRun(data, max_tokens, systemPrompt)
      }, error = function(e) {
        warning("There was an error in token Check: Failed to connect server, but it doesn't affect continued use.")
        NULL
      })
    }


    gptConfig=list(data,systemPrompt=systemPrompt,model=Sys.getenv("model"),max_tokens=max_tokens,temperature=temperature,top_p=top_p,n=1)
    return(gptConfig)
  }
}




