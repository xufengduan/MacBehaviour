#' Step2: Load and format data
#'
#' Prepares the stimuli data for the experiment.
#'
#' @param runList A numeric vector of data representing the 'Run' column in the experiment.
#' @param itemList A numeric vector of data representing the 'Item' column in the experiment.
#' @param eventList A numeric vector of data representing the 'Event' column in the experiment.
#' @param conditionList A numeric/character vector of data representing the 'Condition' column in the experiment.
#' @param promptList A character vector of the main prompt (usually experiment items).
#' @param header A logical value indicating if the output data.frame should include column headers (default is TRUE).
#' @return A data frame with the processed columns 'Run', 'Event', 'Item', 'Condition', and 'Prompt', ready for use in experiments.
#' @export
#'
#' @examples
#'
#' df <- data.frame(
#' Run = c(1,2),
#' Item = c(1,2),
#' Condition = c(1,2),
#' TargetPrompt = c("1","2"),
#' Event = c(1,1)
#' )
#' ExperimentItem=loadData(df$Run,df$Item,df$Event,df$Condition,promptList = df$TargetPrompt)
#'
loadData <- function(runList,itemList,conditionList,promptList,header=TRUE,eventList=NULL){


  runs <- as.numeric(runList)
  items <- as.numeric(itemList)
  if (is.null(eventList)) {
    events <- rep(1, length(runList))
  } else {
    events <- as.numeric(eventList)
  }
  conditions <- conditionList
  prompts <- promptList

  # parameter test
  vectors <- list(runs=runs,  items=items, events=events ,conditions=conditions , prompts=prompts)
  for (name in names(vectors)) {
    if (ncol(as.matrix(vectors[[name]])) != 1) {
      stop(paste("The size of second dimension in ", name, " is not one (expected a single column)"))
    }
  }

  lengths <- sapply(vectors, length)
  if (length(unique(lengths)) > 1) {
    stop("Inconsistent number of rows between run, list, item and condition.")
  }




  data <- data.frame(
    Run = runs,
    Item = items,
    Event = events,
    Condition = conditions,
    Prompt = prompts
  )
  return(data)
}

