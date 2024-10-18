#' Step3: Generate the experimental design matrix.
#'
#' Defines the experiment setup based on the stimuli loaded.
#'
#' @importFrom stats aggregate
#' @param data A data frame that has been processed through the 'loadData' function, containing the experimental items and their attributes.
#' @param session An integer indicating how many sessions (the whole set of trials) should be run. Default is 1, meaning no repetition.
#' @param randomItem A logical indicating whether the Item should be randomized. Default is FALSE, meaning trials will occur in the order provided.
#' @param randomEvent A logical indicating whether the Event should be randomized. Default is FALSE, meaning trials will occur in the order provided.
#' @return A data.frame with the designed structure for the experiment, including any repetitions and randomizations as specified. Each row corresponds to a single trial or instance in the experiment.And it will display the type of experiment with the materials you provide.
#' @export
#'
#' @examples
#'
#' df <- data.frame(
#' Run = c(1,2),
#' Item = c(1,2),
#' Event= c(1,1),
#' Condition = c(1,2),
#' TargetPrompt = c("1","2")
#' )
#'
#' ExperimentItem=loadData(df$Run,df$Item,df$Event,df$Condition,promptList = df$TargetPrompt)
#'
#' Design=experimentDesign(ExperimentItem,session=1,randomItem=TRUE)
#'

experimentDesign <-function(data,session=1,randomItem=FALSE,randomEvent=FALSE){

  run_details <- aggregate(cbind(Item, Event) ~ Run, data, FUN=function(x) length(unique(x)))

  run_counts <- table(data$Run)

  if (all(run_counts == 1) && all(run_details$Item == 1) && all(run_details$Event == 1)) {
    # One item per run (single-event)
    Sys.setenv(exp="1")
  } else if (any(run_counts > 1) && all(run_details$Item == 1)) {
    # One item per run (multi-events)
    Sys.setenv(exp="2")
  } else if (any(run_counts > 1) && !all(run_details$Item == 1) && all(run_details$Event == 1)) {
    # Multiple items per run (single-event)
    Sys.setenv(exp="3")
  } else if (any(run_counts > 1) && !all(run_details$Item == 1) && !all(run_details$Event == 1)) {
    # Multiple items per run (multi-events)
    Sys.setenv(exp="4")
  } else {
    # others
    Sys.setenv(exp="0")
    stop("error design in your exp data, plz check it.")
  }

  # forbid NA in Item and Run
  if (any(is.na(data$Item)) || any(is.na(data$Run))) {
    stop("Item and Run cannot have NA values, please check your data.")
  }
  
  switch(Sys.getenv("exp"),
         "1" = message("Exp mode : One trial per run"),
         "2" = message("Exp mode : One trial per run"),
         "3" = message("Exp mode : Multiple trial per run"),
         "4" = message("Exp mode : Multiple trial per run"),
         stop("Please check your experimental data for design errors")
  )



  new_data <- data.frame()
    for (s in 1:session) {
      session_data <- data

      if(Sys.getenv("exp")=="3"||Sys.getenv("exp")=="4") {
          if (randomItem) {
        df<-session_data
        unique_runs <- unique(df$Run)
        randomized_items <- integer(nrow(df))
        for (run in unique_runs) {
          subset <- df[df$Run == run, ]
          item_values <- unique(subset$Item)
          item_counts <- table(subset$Item)
          randomized_item_order <- sample(item_values)
          subset_new <- subset[order(match(subset$Item, randomized_item_order)), ]
          session_data[df$Run == run, ] <- subset_new
        }
      }
      }
      if (randomEvent) {

        df<-session_data
        randomized_events <- numeric(nrow(df))

        unique_combinations <- unique(df[c("Run", "Item")])

        for (i in 1:nrow(unique_combinations)) {
          current_run <- unique_combinations$Run[i]
          current_item <- unique_combinations$Item[i]
          subset_indices <- df$Run == current_run & df$Item == current_item

          randomized_events[subset_indices] <- sample(df$Event[subset_indices])
        }

        session_data$Event <- randomized_events

      }

      session_data$Session <- s
      # new_data[[i]] <- session_data
      new_data <- rbind(new_data, session_data)
    }


    return(new_data)
  }




