#' Internal Token Check for Individual Trials
#'
#' @description
#' This internal function calculates the number of tokens for each prompt within individual trials in the provided data.
#' It serves to warn if the maximum allowed token limit is exceeded for any specific trial.
#'
#' @param data The data frame containing the prompts for each trial.
#' @param max_tokens The user-defined maximum number of tokens allowed per model response.
#' @param systemPrompt The system-defined prompt text.
#' @return Invisibly returns the token usage statistics and provides a warning if the token limit is exceeded for any trial.
#' This function is intended for internal use and not exported.
#'
#'
#' @noRd
tokenCheckOne <- function (data){

  tokens_list <- tiktokenTokenizer(data$Prompt)
  tokens_vector <- unlist(tokens_list)
  token_max = max(tokens_vector)

  result <- data.frame(
    CheckItem = c("item numbers", "max_token_numbers"),
    Values = c(nrow(data),token_max),
    stringsAsFactors = FALSE 
  )
  
  output <- ""
  output <- paste(output, paste(names(result), collapse = " "), "\n", sep="")
  for (i in 1:nrow(result)) {
    line <- paste(result[i, ], collapse = " ")
    output <- paste(output, line, "\n", sep="")
  }
  message(output)
  

  # print(result)
  # system_tokens <- tiktokenTokenizer(list(systemPrompt))[1]

  # warning("The max token number of Your input & output (systemPrompt+prompt+n*max_tokens) is ",(token_max+n*max_tokens+as.numeric(system_tokens))," among trails, please check the maximum token limit for the current model.")
  message("checked.")
}


#' Internal Token Check for Individual Trials
#'
#' @description
#' This internal function calculates the number of tokens for each prompt within individual trials in the provided data.
#' It serves to warn if the maximum allowed token limit is exceeded for any specific trial, based on the constraints of the maxtoken.
#'
#' @param data The data frame containing the prompts for each trial.
#' @param max_tokens The user-defined maximum number of tokens allowed per model response.
#' @param systemPrompt The system-defined prompt text.
#'
#' @return Invisibly returns the token usage statistics and provides a warning if the token limit is exceeded for any trial.
#' This function is intended for internal use and not exported.
#'
#' @noRd
tokenCheckRun <- function (data,systemPrompt){
  ####################################################################
  show <- data.frame(Run = numeric(0))
  session_data <- data[data$Session == 1, ]
    # Run loop

  for (r in unique(data$Run)) {
    r_data <- session_data[session_data$Run == r, ]

    prompt_tokens_list <- unlist(tiktokenTokenizer(r_data$Prompt))
    prompt_tokens_vector <- unlist(prompt_tokens_list)
    prompt_token_sum = sum(prompt_tokens_vector)

    max_token_per_run = nrow(r_data) * (as.numeric(tiktokenTokenizer(list(systemPrompt))[1])) + prompt_token_sum
    new_row <- data.frame(Run = r, max_tokens_per_run = max_token_per_run)

    show <- rbind(show, new_row)
  }

  output <- ""
  
  output <- paste(output, paste(names(show), collapse = " "), "\n", sep="")

  for (i in 1:nrow(show)) {
    line <- paste(show[i, ], collapse = " ")
    output <- paste(output, line, "\n", sep="")
  }

  message(output)
  # print(show)
  # warning("The max token number among runs is ",max(show$sum_tokens_per_run),",please check the maximum allowed limit for current model.")
  message("checked.")
}

#' Step4: Pre-check for token usage in experiment design.
#'
#' Configures experimental parameters before execution.
#'
#' @param data A data.frame that has been structured by the 'experimentDesign' function, containing the experimental setup.
#' @param checkToken Whether to perform token count check, select TRUE to submit your experiment to our server's tokenizer for token count check, the default selection is FALSE (i.e., no token check will be performed, but you need to manually check if the number of tokens exceeds the model limit to avoid errors in the experiment).
#' @param systemPrompt The system prompt text used in the chatGPT model interaction. If left empty, a space character is assumed.Note: This parameter does not work in models that do not support system prompts.
#' @param imgDetail The image quality of the img modality is set to auto by default, with low/high as selectable options.
#' @param version When using the Claude model, the version parameter required defaults to "2023-06-01".
#' @param ... Variable parameter lists allow you to input additional parameters supported by the model you're using, such as n=2 / logprobs=TRUE... Note: You must ensure the validity of the parameters you enter; otherwise, an error will occur.
#' @return A list containing the original data and the parameters for the chatGPT model interaction, confirming that the setup has passed the token checks or indicating issues if found.
#' @export
#'
#' @examples
#'
#' df <- data.frame(
#' Run = c(1,2),
#' Item = c(1,2),
#' Event =c(1,1),
#' Condition = c(1,2),
#' TargetPrompt = c("please repeat this sentence: test1","please repeat this sentence: test2")
#' )
#'
#' ExperimentItem=loadData(df$Run,df$Item,df$Event,df$Condition,promptList = df$TargetPrompt)
#'
#' Design=experimentDesign(ExperimentItem,session=1)
#'
#' gptConfig=preCheck(Design, systemPrompt="You are a participant in a psychological experiment",
#'                     imgDetail="low",temperature=0.7)
#'

preCheck <- function (data, checkToken=FALSE,systemPrompt="",imgDetail="auto",version="2023-06-01",...){

  args <- list(...)

  if(Sys.getenv("exp")=="1"){
    if(checkToken){
      result <- tryCatch({
        tokenCheckOne(data)
      }, error = function(e) {
        warning("There was an error in token Check: Failed to connect server, but it doesn't affect continued use.")
        NULL
      })
    }

    gptConfig <- list(data,systemPrompt=systemPrompt,imgDetail=imgDetail,version=version,args=args)
    return(gptConfig)
  }

  else if(Sys.getenv("exp")=="2"||Sys.getenv("exp")=="3"||Sys.getenv("exp")=="4"){

    if(checkToken){
      result <- tryCatch({
        tokenCheckRun(data,systemPrompt)
      }, error = function(e) {
        warning("There was an error in token Check: Failed to connect server, but it doesn't affect continued use.")
        NULL
      })
    }

    gptConfig=list(data,systemPrompt=systemPrompt,imgDetail=imgDetail,version=version,args=args)
    return(gptConfig)
  }
}




