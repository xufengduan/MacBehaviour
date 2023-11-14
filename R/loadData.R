#' Step2: Load and format data
#'
#' Prepares the stimuli data for the experiment.
#'
#' @param runList A numeric vector of data representing the 'Run' column in the experiment.
#' @param itemIDList A numeric vector of data representing the 'itemID' column in the experiment.
#' @param conditionList A numeric/character vector of data representing the 'Condition' column in the experiment.
#' @param beforePrompt A string that will be used as the prefix of the 'Prompt' text.
#' @param targetPrompt A character vector of the main prompt (usually experiment items) that will be placed between the beforePrompt and afterPrompt.
#' @param afterPrompt An optional string that will be used as the suffix of the 'Prompt' text (default is an empty string).
#' @param header A logical value indicating if the output data.frame should include column headers (default is TRUE).
#' @return A data frame with the processed columns 'Run', 'Trial', 'Item', 'Condition', and 'Prompt', ready for use in experiments.
#' @export
#'
#' @examples
#' {
#'
#' df <- data.frame(
#' Run = c(1, 2, 3, 4, 5, 6, 7, 8, 9),
#' Item = c(1,1, 1, 1, 1, 1, 1, 1, 2),
#' Condition = c(1, 2, 3, 4, 5, 6, 7, 8, 2),
#' TargetPrompt1 = c("The racing driver showed the torn overall...",
#'                 "The racing driver showed the helpful mechanic...",
#'                 "The report claimed that the racing driver showed the torn overall...",
#'                 "The report claimed that the racing driver showed the helpful mechanic...",
#'                 "The racing driver showed the torn overall...",
#'                 "The racing driver showed the helpful mechanic...",
#'                 "The report claimed that the racing driver showed the torn overall...",
#'                 "The report claimed that the racing driver showed the helpful mechanic...",
#'                 "The cricket player showed the ball..."),
#' TargetPrompt2 = c("The patient showed...",
#'                  "The patient showed...",
#'                  "The patient showed...",
#'                  "The patient showed...",
#'                  "The rumours alleged that the patient showed...",
#'                  "The rumours alleged that the patient showed...",
#'                  "The rumours alleged that the patient showed...",
#'                  "The rumours alleged that the patient showed...",
#'                  "The car mechanic showed...")
#' )
#' ExperimentItem=loadData(runList=df$Run,itemIDList=df$Item,conditionList=df$Condition,beforePrompt="",targetPrompt = paste(df$TargetPrompt1,df$TargetPrompt2,sep="\n"),afterPrompt="")
#' print(ExperimentItem)
#' }
#'
loadData <- function(runList,itemIDList,conditionList,beforePrompt="",targetPrompt,afterPrompt="",header=T){


  runs <- as.numeric(runList)

  items <- as.numeric(itemIDList)
  conditions <- conditionList

  # parameter test
  vectors <- list(runs=runs,  items=items, conditions=conditions)
  for (name in names(vectors)) {
    if (ncol(as.matrix(vectors[[name]])) != 1) {
      stop(paste( "The number of colomn is not equal to 1 in column", name))
    }
  }

  lengths <- sapply(vectors, length)
  if (length(unique(lengths)) > 1) {
    stop("Inconsistent number of rows between run, list, item and condition.")
  }


  if (beforePrompt=="" && afterPrompt=="") {
    Prompt <- paste(targetPrompt)
  } else if (beforePrompt=="") {
    Prompt <- paste(targetPrompt, afterPrompt, sep = "\n")
  } else if (afterPrompt=="") {
    Prompt <- paste(beforePrompt, targetPrompt, sep = "\n")
  } else {
    Prompt <- paste(beforePrompt, targetPrompt, afterPrompt, sep = "\n")
  }


  data <- data.frame(
    Run = runs,
    ItemID = items,
    Condition = conditions,
    Prompt = paste(beforePrompt,targetPrompt,afterPrompt,sep="\n")
  )
  return(data)
}

